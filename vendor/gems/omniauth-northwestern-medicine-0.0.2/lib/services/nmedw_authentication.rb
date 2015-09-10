require 'net/http'
require 'multi_xml'

class NmedwAuthentication
  DEFAULT_HOST_URL = "https://edwapps.nmff.org/EDWPortal.Services/SecurityRest.svc/Authenticate"
  DEFAULT_INFO_URL = "https://edwapps.nmff.org/WebServices/ActiveDirectory.asmx/GetUserDetails?username="
  DEFAULT_APP_NAME = "nucats_membership_db"

  ##
  # With the given username and password, send this information
  # to the EDW Portal Authentication service. If the request is
  # successful then return true, otherwise false.
  # @param username [String]
  # @param password [String]
  # @return [Boolean]
  def self.valid_credentials?(username, password)
    return nil unless password && !password.strip.empty?

    result = false
    begin
      result = is_valid_user?(username, password)
    rescue Exception => e
      msg = "Warden::northwestern_medicine.valid_credentials? - Exception [#{e.message}] occurred when calling EDW Authorization.\n"
      msg << e.backtrace.join("\n")
      Rails.logger.error(msg)
    end
    result
  end

  ##
  # @return Hash or nil if encountering an exception
  def self.get_user_details(username)
    begin
      request, http = build_edw_service_request("#{DEFAULT_INFO_URL}#{URI.escape(username)}")
      response = http.request(request)
      document = MultiXml.parse(response.body.gsub("xmlns=\"edw\"", "xmlns=\"http://edw.northwestern.edu\""))
      return document['UserDetail']
    rescue Exception => e
      msg = "Warden::northwestern_medicine.get_user_details? - Exception [#{e.message}] occurred when calling EDW ActiveDirectory.\n"
      msg << e.backtrace.join("\n")
      Rails.logger.error(msg)
      return nil
    end
  end

  ##
  # With the given username and password, send this information
  # to the EDW Portal Authentication service. If the request is
  # successful then return true, otherwise false.
  # @param username [String]
  # @param password [String]
  # @return [Boolean]
  def self.is_valid_user?(username, password)
    request, http = build_edw_service_request("#{DEFAULT_HOST_URL}/#{DEFAULT_APP_NAME}")
    request.basic_auth(username, password)
    response = http.request(request)
    return response.kind_of?(Net::HTTPSuccess)
  end
  private_class_method :is_valid_user?

  ##
  # Builds the request to the EDW Portal Authentication service
  def self.build_edw_service_request url
    uri     = URI.parse(url)
    http    = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    http.use_ssl = true
    [request, http]
  end

end