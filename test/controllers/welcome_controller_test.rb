require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test 'Signed user can visit welcome page' do
    user = users(:user_without_results)
    sign_in user

    assert_current_path = root_path
  end

  test 'Signed user can see information of last sheet data' do
    user = users(:registered_user)
    result_sheet = result_sheets(:one)
    sign_in user

    assert_current_path = root_path
  end
end
