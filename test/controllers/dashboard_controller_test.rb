require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test 'logged user can visit path' do
    user = users(:registered_user)

    sign_in user
    get dashboard_path

    assert :succes
  end

  test 'no logged user cannot visit path' do
    get dashboard_path

    assert_redirected_to new_user_session_path
  end
end
