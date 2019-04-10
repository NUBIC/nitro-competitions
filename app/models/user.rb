# encoding: UTF-8

class User < ApplicationRecord
  include PrepareUserBeforeSave

  USER_TYPES = ["LdapUser", "ExternalUser"]

  UNKNOWN = 'Unknown'

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
  before_validation :prepare_user
  after_save :save_documents

  # Validations
  validates_presence_of :username
  validates_presence_of :first_name, :if => :validate_first_last
  validates_presence_of :last_name, :if => :validate_first_last
  validates_presence_of :era_commons_name, :if => :validate_era_commons
  validates_presence_of :email, :if => :validate_email

  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :era_commons_name, :if => :validate_era_commons
  validates_uniqueness_of :email, :if => :validate_email_attr
  validates_format_of :email,
                      :with => %r{^[a-zA-Z0-9\.\-\_][a-zA-Z0-9\.\-\_]+@[^\.]+\..+$}i,
                      :multiline => true,
                      :message => 'Email address is not valid. Please correct',
                      :if => Proc.new { |c| !c.email.blank? }

  validates_inclusion_of :system_admin,
                      :in => [true, false],
                      :message => 'The value must be true or false'

  validates_inclusion_of :type, in: USER_TYPES


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

  def prepare_user
    self.username = self.username.strip if self.username.respond_to?(:strip)
    self.username.downcase!

    self.email = self.email.strip if self.email.respond_to?(:strip)
    self.email.downcase!
  end


  def save_documents
    self.biosketch.save if !self.biosketch.nil? && self.biosketch.changed?
  end

  def self.search(params)
    q = ' 1 = 1 '
    q << " AND first_name ilike '#{params[:first_name]}%'" unless params[:first_name].blank?
    q << " AND last_name ilike '#{params[:last_name]}%'" unless params[:last_name].blank?
    q << " AND email ilike '#{params[:email]}%'" unless params[:email].blank?
    User.where(q).to_a
  end

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

end
