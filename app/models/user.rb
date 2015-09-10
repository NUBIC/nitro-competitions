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
  has_many :submission_reviews, -> { includes(:submissions) }, :foreign_key => 'reviewer_id'
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
  validates_uniqueness_of :email, :if => :validate_email
  validates_format_of :email,
                      :with => %r{^[a-zA-Z0-9\.\-\_][a-zA-Z0-9\.\-\_]+@[^\.]+\..+$}i,
                      :multiline => true,
                      :message => 'Email address is not valid. Please correct',
                      :if => Proc.new { |c| !c.email.blank? }

  # FOR OMNIAUTH
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      email = auth.info.email
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          oauth_name: determine_name(auth),
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def self.determine_name(auth)
    auth.extra.info.name
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  ## END OMNIAUTH

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
  # This method will attempt to find an existing User record
  # with information obtained in the omniauth hash.
  #
  # First it will look for an existing User matching some data in the omniauth hash
  # @see find_user_from_omniauth
  #
  # @param [OmniAuth::AuthHash]
  # @return User
  def self.find_or_create_from_omniauth(omniauth)
    user = find_user_from_omniauth(omniauth)
    user = create_user_from_omniauth(omniauth) if user.blank?
    user
  end

  def self.create_user_from_omniauth(omniauth)
    # New user registration
    user = User.new(email: omniauth['info']['email'])
    if user
      user.validate_name = false
      user.username = extract_username_from_omniauth(omniauth)
      user.first_name = omniauth['info']['first_name'] || ''
      user.last_name  = omniauth['info']['last_name'] || ''
      user.save!
    end
    user
  end
  private_class_method :create_user_from_omniauth

  def self.extract_username_from_omniauth(omniauth)
    result = omniauth['info']['email']
    unless omniauth['extra']['raw_info']['person_identities'].blank?
      omniauth['extra']['raw_info']['person_identities'].each do |identity|
        if identity['provider_username'].blank?
          # TODO: what if the email is blank?
          # * omniauth.auth : {"provider"=>"nucatsaccounts", "uid"=>nil, "info"=>{"name"=>"fname lname", "email"=>nil, "first_name"=>"fname", "last_name"=>"lname"}, "credentials"=>{"token"=>"2932d009b8ddf9ccc012c94bf26f74b1", "refresh_token"=>"b64936c6cddb2c5c43d91d3768745cb9", "expires_at"=>1404856796, "expires"=>true}, "extra"=>{"raw_info"=>{"first_name"=>"fname", "middle_name"=>nil, "last_name"=>"lname", "suffix"=>nil, "degrees"=>nil, "email"=>nil, "uuid"=>"7277e6bf-7f66-47b2-983d-9dc2eb36927d", "person_identities"=>[{"provider"=>"twitter", "uid"=>"405189205", "email"=>nil, "provider_username"=>nil, "username"=>nil, "nickname"=>"twittername", "domain"=>nil}]}}}
          result = identity['email']
        else
          result = identity['provider_username']
          break if identity['domain'] == 'nu'
        end
      end
    end
    result
  end
  private_class_method :extract_username_from_omniauth

  ##
  # Find a User record matching data in the given omniauth hash.
  #
  # First check against email as that is easiest.
  #
  # If no User exists with that email then loop over the
  # identity records from the omniauth hash and look for the matching
  # User record first by username then by email.
  #
  # We intimately know what the omniauth['extra']['person_identities']
  # hash contains and how new Users are created from this data.
  #
  # @param [OmniAuth::AuthHash]
  # @return User or nil
  def self.find_user_from_omniauth(omniauth)
    email = omniauth['info']['email']
    user = User.where(email: email).first unless email.blank?
    if user.blank? && !omniauth['extra']['raw_info']['person_identities'].blank?
      user = find_user_from_authentication_provider(omniauth['extra']['raw_info']['person_identities'])
    end
    user
  end

  ##
  # Use the record in the hash where the domain is nu to match
  # the User username (i.e. nu netid) before searching via other means
  def self.find_user_from_authentication_provider(identities)
    identity = identities.find { |pi| pi['domain'] == 'nu' }
    user = find_user_using_identity(identity) if identity
    if user.blank?
      identities.each do |i|
        user = find_user_using_identity(i)
        break unless user.blank?
      end
    end
    user
  end
  private_class_method :find_user_from_authentication_provider

  ##
  # Loop through all identities in omniauth hash to locate a user by
  # email or username
  def self.find_user_using_identity(identity)
    username = identity['provider_username']
    user = User.where(username: username).first unless username.blank?
    if user.blank?
      email = identity['email']
      user = User.where(username: email).first unless email.blank?
    end
    user
  end
  private_class_method :find_user_using_identity
end
