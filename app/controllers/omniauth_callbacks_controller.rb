class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  include ApplicationHelper
  ##
  # Handle authentication from Google OAuth 2.0.
  def google_oauth2
    process_login
  end

  ##
  # Handle authentication from Twitter
  def twitter
    process_login
  end

  ##
  # Handle authentication from Yahoo
  def yahoo
    process_login
  end

  ##
  # Handle authentication from LinkedIn
  def linkedin
    process_login
  end

  ##
  # Handle authentication from facebook
  def facebook
    process_login
  end

  ##
  # Handle authentication from Northwestern Medicine
  def northwestern_medicine
    process_login
  end

  def process_login
    auth   = request.env['omniauth.auth']
    Rails.logger.error("~~~ [process_login] auth: #{auth.inspect}")
    # Here we check to see if we did get back an OmniAuth::AuthHash 
    # or something that responds to :[] 
    # Sometimes we are getting back true:TrueClass - still don't know the cause of that
    if auth.respond_to?(:[]) && auth['info'].respond_to?(:[])

      @user = User.find_for_oauth(env["omniauth.auth"], current_user)

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication

        remember_me(user) if params['remember_me'].to_i == 1
        flash[:notice] = I18n.t('login.authentication_success_via', provider: provider_name(auth['provider']))
      else
        session["devise.#{provider}_data"] = env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    else
      # And in the case of receiving true - simply redirect the user to the login page
      Rails.logger.error("~~~ [process_login] OmniAuth::AuthHash not found redirecting to new_user_session_path")
      redirect_to new_user_session_path, flash: { error: I18n.t('login.authentication_failure') }
    end
  end

  ##
  # Given a provider make a pretty presentation of the
  # provider name.
  # @param [String, Symbol, nil]
  # @return [String]
  def provider_name(provider)
    # Set var to String as default action is to call
    # titleize on the given parameter
    provider = provider.to_s
    case provider
    when 'google_oauth2'
      provider = 'Google'
    when 'linkedin'
      provider = 'LinkedIn'
    when 'northwestern_medicine', 'nu', 'nmff-net', 'nmh', 'nmff'
      provider = 'Northwestern Medicine'
    else
      provider = provider.titleize
    end
    provider
  end

  # def after_sign_in_path_for(resource)
  #   if resource.email_verified?
  #     super resource
  #   else
  #     finish_signup_path(resource)
  #   end
  # end
end