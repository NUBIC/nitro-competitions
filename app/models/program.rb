# encoding: UTF-8

class Program < ActiveRecord::Base
  # Associations
  has_many :roles_users

  def admins
    roles_users.admins.map(&:user)
  end

  def submission_notifiable_admins
    admins.select { |a| a.should_receive_submission_notifications }
  end

  has_many :projects
  has_many :reviewers
  has_many :logs
  belongs_to :creator, :class_name => "User", :foreign_key => "created_id"

  # Callbacks
  before_validation :normalize_name

  # Validations
  validates :email,
            presence: true

  validates :program_url,
            presence: true

  validates :program_title,
            presence: true,
            length: { within: 2..80 }

  validates :program_name,
            presence: true,
            uniqueness: true,
            length: { within: 2..20 },
            format: { with: /\A[A-Za-z0-9\_]+\Z/ }

private
  def normalize_name
    unless self.program_name.blank?
      self.program_name = self.program_name.gsub(/\s/, "").gsub(/[^A-Za-z0-9]/, "_").gsub(/__+/, "_")
    end
  end
end
