class SessionsController < Devise::SessionsController

  def new
    super
  end

  def create
    request.params['ldap_user'] = request.params['external_user'] = request.params['user']
    user_class    = set_user_class

    self.resource = warden.authenticate! scope: user_class

    if self.resource.nil?
      return redirect_to new_session_path
    end

    # self.resource is a valid user account - either NorthwesternUser or ExternalUser
    sign_in(user_class, self.resource)


    # store_user_location to send user on to the proper page
    #  https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
    respond_with self.resource, :location => after_sign_in_path_for(self.resource)
  end

  def destroy
    super
  end

  private

  def set_user_class
    (request.params['user']['username'].include? '@') ? :external_user : :ldap_user
  end

end
