require "omniauth-northwestern-medicine/version"
require "services/nmedw_authentication"

module OmniAuth
  module Strategies
    class NorthwesternMedicine
      include OmniAuth::Strategy

      option :name, :northwestern_medicine
      option :fields, [:username]
      option :uid_field, :username

      def request_phase
        OmniAuth::Form.build(
          :title => (options[:title] || "Authenticate"),
          :url => callback_path
        ) do |field|
          field.text_field 'Username', 'username'
          field.password_field 'Password', 'password'
        end.to_response
      end

      def callback_phase
        return fail!(:invalid_credentials) unless identity
        super
      end

      uid { username }

      info do
        {
          :username => uid,
          :first_name => details['FirstName'],
          :last_name => details['LastName'],
          :name => "#{details['FirstName']} #{details['LastName']}".strip,
          :email => details['Email']
        }
      end

      #extra do
      #  { 'raw_info' => raw_info }
      #end

      def details
        @details ||= NmedwAuthentication::get_user_details(username)
        @details
      end

      def identity
        @identity = NmedwAuthentication::valid_credentials?(username, request['password'])
      end

      def username
        if @username.blank?
          @username = request['username']
          @username = "#{request['domain']}\\#{@username}" unless request['domain'].blank?
        end
        @username
      end
    end
  end
end

OmniAuth.config.add_camelization 'northwestern_medicine', 'NorthwesternMedicine'