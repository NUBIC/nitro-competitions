class ExternalUser < User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :validatable

  before_create :set_username
  after_create :create_profile

  private
  def set_username
    self.username = self.email
  end

  def create_profile
    Profile.create!(user_id: self.id)
  end
end

