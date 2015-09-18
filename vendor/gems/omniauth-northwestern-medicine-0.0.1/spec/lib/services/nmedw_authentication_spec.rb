require 'spec_helper'
require 'services/nmedw_authentication'

describe NmedwAuthentication do
  it "builds a secure connection to call the web service" do
    request, http = NmedwAuthentication.build_edw_service_request
    request.should be_a(Net::HTTP::Get)
    http.should be_a(Net::HTTP)
    http.use_ssl?.should be_true
  end

  it "determines validation status from the web service response" do
    [[200, true], [500, false], [401, false]].each do |code, expectation|
      stub_authentication_with_status_code code
      NmedwAuthentication.valid_credentials?("test", "test").should eql(expectation)
    end
  end

  describe "error raised calling authentication service" do
    before do
      stub_authentication_to_raise_error
    end
    it "validates false" do
      NmedwAuthentication.valid_credentials?("test", "test").should be_false
    end

    it "logs the error message" do
      Rails.logger.should_receive(:error)
      NmedwAuthentication.valid_credentials?("test", "test")
    end
  end
end

def stub_authentication_with_status_code code
  WebMock.reset!
  stub_request(:any, /.*edwapps.*/).to_return({:status => code})
end

def stub_authentication_to_raise_error
  stub_request(:any, /.*edwapps.*/).to_raise(StandardError)
end