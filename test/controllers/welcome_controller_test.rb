require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test 'no logged user can visit welcome page' do
    get root_path
   
    assert :succes
  end

  test 'Signed user is redirected to  dashboard' do
    user = users(:registered_user)
    sign_in user

    get root_path

    assert_redirected_to dashboard_path
  end
end
