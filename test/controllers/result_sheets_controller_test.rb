require 'test_helper'

class ResultSheetsControllerTest < ActionDispatch::IntegrationTest
  test 'signed user can create new result sheet' do
    user = users(:registered_user)
    params = { result_sheet: { doctor: 'example', document: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'files', 'document.txt')) } }
    sign_in user

    post result_sheets_path(), params: params
    
    assert_response :success
  end

  test 'signed user can delete result sheet' do
    user = users(:registered_user)
    sign_in user

    delete result_sheet_path(user.result_sheets.last)

    assert_redirected_to result_sheets_path
  end
  
  test 'signed user can visit index' do
    user = users(:registered_user)
    
    sign_in user
    get result_sheets_path

    assert_response :success
  end

  test 'No logged user cant visit index' do
    get result_sheets_path

    assert_redirected_to new_user_session_path
  end
end
