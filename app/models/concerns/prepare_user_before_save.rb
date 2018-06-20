module PrepareUserBeforeSave
  extend ActiveSupport::Concern

  included do
    before_save :downcase_and_strip_user
  end

  def downcase_and_strip_user
    self.username = self.username.strip if self.username.respond_to?(:strip)
    self.username.downcase!

    self.email = self.email.strip if self.email.respond_to?(:strip)
    self.email.downcase!
  end
end