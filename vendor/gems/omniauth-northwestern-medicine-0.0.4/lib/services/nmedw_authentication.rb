require 'net/http'
require 'multi_xml'

class NmedwAuthentication
  DEFAULT_HOST_URL = "https://edwapps.nmff.org/EDWPortal.Services/SecurityRest.svc/Authenticate"
  DEFAULT_INFO_URL = "https://edwapps.nmff.org/campusdirectory/campuslookup.asmx/LookUp?input="
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
      log msg
    end
    result
  end

  ##
  # Given a valid username, expect the results from the web service to be
  # <ArrayOfResults>
  #   <Results>
  #     <lastName>LN</lastName>
  #     <firstName>FM</firstName>
  #     <fullNameUser>NU (FN LN)</fullNameUser>
  #     <account>NU\abc123</account>
  #     <mail>fn.ln@northwestern.edu</mail>
  #     <phone>+1 312 503 1234</phone>
  #     <source>NU</source>
  #   </Results>
  # </ArrayOfResults>
  #
  # @param String username
  # @return Hash or nil if encountering an exception
  def self.get_user_details(username)
    begin
      url = "#{DEFAULT_INFO_URL}#{URI.escape(username)}"
      request, http = build_edw_service_request(url)
      response = http.request(request)
      document = MultiXml.parse(response.body.gsub("xmlns=\"edw\"", "xmlns=\"http://edw.northwestern.edu\""))
      extract_data(username, document['ArrayOfResults']['Results'])
    rescue Exception => e
      msg = "Warden::northwestern_medicine.get_user_details? - Exception [#{e.message}] occurred when calling EDW ActiveDirectory.\n"
      msg << e.backtrace.join("\n")
      log msg
      return nil
    end
  end

  def self.extract_data(username, document_results)
    result = nil
    if document_results.class == Hash
      result = document_results
    elsif document_results.class == Array
      result = get_user_details_for_username(username, document_results)
    end
    result
  end

  ##
  # @param String username
  # @param Array arr
  # @return Hash or nil if encountering an exception
  def self.get_user_details_for_username(username, arr)
    result = nil
    arr.each do |hsh|
      if hsh['account'].downcase == username.downcase
        result = hsh
      end
    end
    result
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
  def self.build_edw_service_request(url)
    uri     = URI.parse(url)
    http    = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    http.use_ssl = true
    [request, http]
  end

  def self.log(msg)
    if defined?(Rails)
      Rails.logger.error(msg)
    else
      puts msg
    end
  end

end