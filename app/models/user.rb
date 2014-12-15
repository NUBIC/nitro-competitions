# encoding: UTF-8
class User < ActiveRecord::Base

  has_many :reviewers  # really program reviewers since the reviewer model is a user + program
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

  scope :applicants, joins('join submissions on submissions.applicant_id = users.id')

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
