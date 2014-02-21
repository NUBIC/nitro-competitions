# encoding: UTF-8
# == Schema Information
# Schema version: 20130511121216
#
# Table name: users
#
#  address               :text
#  biosketch_document_id :integer
#  business_phone        :string(255)
#  campus                :string(255)
#  campus_address        :text
#  city                  :string(255)
#  country               :string(255)
#  created_at            :datetime
#  created_id            :integer
#  created_ip            :string(255)
#  degrees               :string(255)
#  deleted_at            :datetime
#  deleted_id            :integer
#  deleted_ip            :string(255)
#  email                 :string(255)
#  employee_id           :integer
#  era_commons_name      :string(255)
#  fax                   :string(255)
#  first_login_at        :datetime
#  first_name            :string(255)      not null
#  id                    :integer          not null, primary key
#  last_login_at         :datetime
#  last_name             :string(255)      not null
#  middle_name           :string(255)
#  name_suffix           :string(255)
#  password_changed_at   :datetime
#  password_changed_id   :integer
#  password_changed_ip   :string(255)
#  password_hash         :string(255)
#  password_salt         :string(255)
#  photo                 :binary
#  photo_content_type    :string(255)
#  photo_file_name       :string(255)
#  postal_code           :string(255)
#  primary_department    :string(255)
#  state                 :string(255)
#  title                 :string(255)
#  updated_at            :datetime
#  updated_id            :integer
#  updated_ip            :string(255)
#  username              :string(255)      not null
#

class User < ActiveRecord::Base

  has_many :reviewers  #really program reviewers since the reviewer model is a user + program
  belongs_to :biosketch, :class_name => 'FileDocument', :foreign_key => 'biosketch_document_id'
  has_many :key_personnel
  has_many :submission_reviews, :foreign_key => 'reviewer_id'
  has_many :reviewed_submissions, :class_name => 'Submission', :through => :submission_reviews, :source => :submission
  has_many :roles_users
  has_many :roles, :through => :roles_users
  has_many :logs

  has_many :submissions, :foreign_key => 'applicant_id'
  has_many :proxy_submissions, :class_name => 'Submission', :foreign_key => 'created_id'
  attr_accessor :validate_for_applicant
  attr_accessor :validate_era_commons_name
  attr_accessor :validate_name
  attr_accessor :validate_email_attr
  attr_accessible *column_names
  attr_accessible :biosketch, :uploaded_biosketch, :uploaded_photo

  after_save :save_documents

  scope :project_applicants, lambda { |*args| joins([:submissions]).where('submissions.project_id IN (:project_ids)', { :project_ids => args.first }) }

  default_scope order('lower(users.last_name),lower(users.first_name)')
  scope :program_reviewers, lambda { |*args| joins(:reviewers).where('reviewers.program_id = :program_id', { :program_id => args.first }) }

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :first_name, :if => :validate_first_last
  validates_presence_of :last_name, :if => :validate_first_last
  validates_presence_of :era_commons_name, :if => :validate_era_commons
  validates_uniqueness_of :era_commons_name, :if => :validate_era_commons
  validates_presence_of :email, :if => :validate_email
  validates_uniqueness_of :email, :if => :validate_email
  validates_format_of :email,
                      :with => %r{^[a-zA-Z0-9\.\-\_][a-zA-Z0-9\.\-\_]+@[^\.]+\..+$}i,
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
      begin
        logger.warn "creating new biosketch object for investigator"
      rescue
        puts  "creating new biosketch object for investigator"
      end
    end
    self.biosketch.uploaded_file = field
  end

  def save_documents
    self.biosketch.save if !self.biosketch.nil? and self.biosketch.changed?
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
  private_class_method :find_user_from_omniauth

  ##
  # Use the record in the hash where the domain is nu to match
  # the User username (i.e. nu netid) before searching via other means
  def self.find_user_from_authentication_provider(identities)
    identity = identities.find { |pi| pi['domain'] == 'nu' }
    user = find_user_using_identity(identity) if identity
    if user.blank?
      identities.each do |identity|
        user = find_user_using_identity(identity)
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
