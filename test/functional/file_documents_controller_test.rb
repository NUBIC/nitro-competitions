require 'test_helper'

class FileDocumentsControllerTest < ActionController::TestCase

  test "should show file_document" do
    get :show, :id => file_documents(:one).to_param
    assert_response :success
    assert assigns(:file_document)
    assert_not_nil assigns(:file_document)
    assert assigns(:file_document).file_file_name =~ /mystring/i
    assert assigns(:file_document).file_content_type =~ /text/i
    assert @response.body.include? "This is a test to see what we can store"
  end

  test "invalid show file_document" do
    get :show, :id => '5542'
    assert_response :success
    assert_nil assigns(:file_document)
#    puts @response.inspect
    assert @response.body =~ /file does not exist/i
  end

end
