class ExternalUser < User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable, :recoverable, :validatable

  after_initialize :set_username, if: :new_record?

  private
  def set_username
    self.username = self.email
  end
end

