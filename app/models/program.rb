class Program < ActiveRecord::Base
  has_many :roles_users
  has_many :admins, :source => :user, :through => :roles_users,
    :include => [:roles],
    :conditions => ["(roles.name = 'Admin' and roles.id = roles_users.role_id) "]

  has_many :projects
  has_many :reviewers
  has_many :logs
  belongs_to :creater, :class_name => "User", :foreign_key => "created_id"
  before_validation :clean_params

  validates_uniqueness_of :program_name  #simplifies the logic a lot if we force the project names to be absolutely unique
  validates_length_of :program_title, :within => 2..80, :too_long => "--- pick a shorter title", :too_short => "--- pick a longer title"
  validates_length_of :program_name, :within => 2..20, :too_long => "--- pick a shorter name", :too_short => "--- pick a longer name"
  
  def clean_params
    # need the before_type_cast or else Rails 2.3 truncates after any comma. strange
    txt = self.program_name
    return if txt.blank?
    txt = txt.gsub(/\s/, "").gsub(/[^A-Za-z0-9]/, "_").gsub(/__+/, "_") 
    self.program_name=txt
  end
  
end
