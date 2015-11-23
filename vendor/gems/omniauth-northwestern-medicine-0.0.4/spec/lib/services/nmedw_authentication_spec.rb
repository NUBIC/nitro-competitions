require 'spec_helper'
require 'services/nmedw_authentication'

describe NmedwAuthentication do
  it 'builds a secure connection to call the web service' do
    url = "#{NmedwAuthentication::DEFAULT_HOST_URL}/#{NmedwAuthentication::DEFAULT_APP_NAME}"
    request, http = NmedwAuthentication.build_edw_service_request(url)
    request.should be_a(Net::HTTP::Get)
    http.should be_a(Net::HTTP)
    http.use_ssl?.should be_truthy
  end

  it 'determines validation status from the web service response' do
    [[200, true], [500, false], [401, false]].each do |code, expectation|
      stub_authentication_with_status_code code
      NmedwAuthentication.valid_credentials?('test', 'test').should eql(expectation)
    end
  end

  # describe 'error raised calling authentication service' do
  #   before do
  #     stub_authentication_to_raise_error
  #   end
  #   it 'validates false' do
  #     NmedwAuthentication.valid_credentials?('test', 'test').should be_falsey
  #   end

  #   # it 'logs the error message' do
  #   #   # Rails.logger.should_receive(:error)
  #   #   NmedwAuthentication.valid_credentials?('test', 'test')
  #   # end
  # end

  describe '.get_user_details' do
    it 'returns a Hash' do 
      stub_request(:get, 'https://edwapps.nmff.org/campusdirectory/campuslookup.asmx/LookUp?input=nu\pfr957').
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: '<ArrayOfResults><Results><lastName>Friedman</lastName><firstName>Paul</firstName><fullNameUser>NU (Paul Friedman)</fullNameUser><account>NU\pfr957</account><mail>p-friedman@northwestern.edu</mail><source>NU</source></Results></ArrayOfResults>', headers: {})

      hsh = NmedwAuthentication.get_user_details('nu\pfr957')
      hsh['firstName'].should eql('Paul')
      hsh['lastName'].should eql('Friedman')
      hsh['mail'].should eql('p-friedman@northwestern.edu')
    end

    it 'handles more than one record returned' do
      result = '<ArrayOfResults><Results><lastName>Holmgren</lastName><firstName>Robert</firstName><fullNameUser>NU (Robert Holmgren)</fullNameUser><account>NU\holmgren</account><mail>r-holmgren@northwestern.edu</mail><phone>+1 847 491 5460</phone><source>NU</source></Results><Results><lastName>Holmgren</lastName><firstName>Laura</firstName><fullNameUser>NU (Laura Holmgren)</fullNameUser><account>NU\lmh902</account><mail>LauraHolmgren2015@u.northwestern.edu</mail><source>NU</source></Results></ArrayOfResults>'

      stub_request(:get, 'https://edwapps.nmff.org/campusdirectory/campuslookup.asmx/LookUp?input=nu\holmgren').
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: result, headers: {})

      hsh = NmedwAuthentication.get_user_details('nu\holmgren')
      hsh['firstName'].should eql('Robert')
      hsh['lastName'].should eql('Holmgren')
      hsh['mail'].should eql('r-holmgren@northwestern.edu')
    end
  end
end

def stub_authentication_with_status_code code
  WebMock.reset!
  stub_request(:any, /.*edwapps.*/).to_return({status: code})
end

def stub_authentication_to_raise_error
  stub_request(:any, /.*edwapps.*/).to_raise(StandardError)
end