# encoding: UTF-8
# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  username              :string(255)      not null
#  era_commons_name      :string(255)
#  first_name            :string(255)      not null
#  last_name             :string(255)      not null
#  middle_name           :string(255)
#  email                 :string(255)
#  degrees               :string(255)
#  name_suffix           :string(255)
#  business_phone        :string(255)
#  fax                   :string(255)
#  title                 :string(255)
#  employee_id           :integer
#  primary_department    :string(255)
#  campus                :string(255)
#  campus_address        :text
#  address               :text
#  city                  :string(255)
#  postal_code           :string(255)
#  state                 :string(255)
#  country               :string(255)
#  photo_content_type    :string(255)
#  photo_file_name       :string(255)
#  photo                 :binary
#  biosketch_document_id :integer
#  first_login_at        :datetime
#  last_login_at         :datetime
#  password_salt         :string(255)
#  password_hash         :string(255)
#  password_changed_at   :datetime
#  password_changed_id   :integer
#  password_changed_ip   :string(255)
#  created_id            :integer
#  created_ip            :string(255)
#  updated_id            :integer
#  updated_ip            :string(255)
#  deleted_at            :datetime
#  deleted_id            :integer
#  deleted_ip            :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class User < ActiveRecord::Base

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Associations
  has_many :reviewers  # really program reviewers since the reviewer model is a user + program
  belongs_to :biosketch, :class_name => 'FileDocument', :foreign_key => 'biosketch_document_id'
  has_many :key_personnel
  has_many :submissions, :foreign_key => 'applicant_id'
  has_many :proxy_submissions, :class_name => 'Submission', :foreign_key => 'created_id'
  has_many :submission_reviews, -> { includes(:submission) }, :foreign_key => 'reviewer_id'
  has_many :reviewed_submissions, :class_name => 'Submission', :through => :submission_reviews, :source => :submission
  has_many :roles_users
  has_many :roles, :through => :roles_users
  has_many :logs


  # Accessors
  attr_accessor :validate_era_commons_name
  attr_accessor :validate_name
  attr_accessor :validate_email_attr

  # Scopes
  def self.project_applicants(*args) 
    joins([:submissions]).where('submissions.project_id IN (:project_ids)', { project_ids: args.first })
  end
  def self.program_reviewers(*args) 
    joins(:reviewers).where('reviewers.program_id = :program_id', { program_id: args.first })
  end
  def self.applicants 
    joins('join submissions on submissions.applicant_id = users.id')
  end

  # Callbacks
  after_save :save_documents

  # Validations
  validates_presence_of :username
  validates_presence_of :first_name, :if => :validate_first_last
  validates_presence_of :last_name, :if => :validate_first_last
  validates_presence_of :era_commons_name, :if => :validate_era_commons
  validates_presence_of :email, :if => :validate_email

  validates_uniqueness_of :username
  validates_uniqueness_of :era_commons_name, :if => :validate_era_commons
  validates_uniqueness_of :email, :if => :validate_email_attr
  validates_format_of :email,
                      :with => %r{^[a-zA-Z0-9\.\-\_][a-zA-Z0-9\.\-\_]+@[^\.]+\..+$}i,
                      :multiline => true,
                      :message => 'Email address is not valid. Please correct',
                      :if => Proc.new { |c| !c.email.blank? }


  def name
    [first_name, last_name].join(' ').gsub(/\'/, "’")
  end

  def sort_name
    [last_name, first_name].join(', ').gsub(/\'/, "’").strip
  end

  def short_name
    begin
      [first_name[0,1]+'.', last_name].join(' ').gsub(/\'/, "’")
    rescue
      ''
    end
  end

  def long_name
    [name, degrees].compact.join(", ").gsub(/, +$/,"").gsub(/\'/, "’")
  end

  def validate_first_last
    validate_name || validate_name.nil?
  end

  def validate_email
    validate_email_attr
  end

  def validate_era_commons
    validate_era_commons_name
  end

  # this defines the connection between the model attribute exposed to the form (uploaded_photo )
  # and the storage fields for the file
  def uploaded_photo=(field)
    self.photo = FileDocument.new if self.photo.nil?
    self.photo.uploaded_file = field
  end

  def uploaded_biosketch=(field)
    if self.biosketch_document_id.nil?
      self.biosketch = FileDocument.new
      msg = 'creating new biosketch object for investigator'
      begin
        logger.warn msg
      rescue
        puts msg
      end
    end
    self.biosketch.uploaded_file = field
  end

  def save_documents
    self.biosketch.save if !self.biosketch.nil? && self.biosketch.changed?
  end

  ## 
  # Find or create user
  # @param auth [OmniAuth::AuthHash]
  # @param signed_in_resource [Boolean]
  # @reutrn User
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    user = create_user!(auth) if user.nil?

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  ##
  # @param auth [OmniAuth::AuthHash]
  # @return User
  def self.create_user!(auth)
    user = nil

    # Get the following from auth
    name, first_name, last_name, email = extract_user_info(auth)
    username = determine_username(auth)
    if !username.blank?
      user = User.where(username: username).first 
      Rails.logger.error("~~~ create_user! - found user with username [#{username}]" if user
      if user && user.email.blank? && !email.blank?
        user.email = email 
        user.save!
      end
    end
    if user.nil? && !email.blank?
      user = User.where(email: email).first
      Rails.logger.error("~~~ create_user! - found user with email [#{email}]" if user
    end

    # Create the user if it's a new registration
    if user.nil?
      user = User.new(
        oauth_name: name,
        first_name: first_name,
        last_name: last_name,
        username: username,
        email: email.blank? ? "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com" : email,
        password: Devise.friendly_token[0,20]
      )
      Rails.logger.error("~~~ create_user! - creating user with email [#{email}] and username [#{username}]"
      user.save!
    end
    user
  end

  ##
  # Get first name, last name, and email information
  # returned from the provider
  # twitter and yahoo provide 'name'
  # google, facebook, and linked in provide 'first_name' and 'last_name'
  # @param [Hash] auth from omniauth
  # @return [Array<String>]
  def self.extract_user_info(auth)
    name = auth['info']['name']
    if name && !name.blank?
      first_name = name.split[0]
      last_name  = name.split[1]
    else
      first_name = auth['info']['first_name']
      last_name  = auth['info']['last_name']
    end
    [name, first_name, last_name, auth['info']['email']]
  end

  def self.determine_username(auth)
    username = auth.info.nickname || auth.uid
    Identity.northwestern_domains.each do |domain|
      suffix = domain + "\\"
      username = username.sub(suffix, '') if username.start_with?(suffix)
    end
    Rails.logger.error("~~~ determine_username - auth [#{auth}]; username [#{username}]"
    username
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

end
