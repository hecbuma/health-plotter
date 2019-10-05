require 'test_helper'

class ResultSheetsControllerTest < ActionDispatch::IntegrationTest
  test 'signed user can create new result sheet' do
    user = users(:registered_user)
    params = { result_sheet: {document: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'files', 'LAB-SEP.pdf')) } }
    sign_in user
    
    assert_difference 'ResultSheet.count', 1 do
      post result_sheets_path(), params: params
    end

    assert_response :success
  end

  test 'signed user can delete result sheet' do
    user = users(:registered_user)
    sign_in user

    assert_difference 'ResultSheet.count', -1 do
      delete result_sheet_path(user.result_sheets.last)
    end

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
