# frozen_string_literal: true

require "application_system_test_case"

class  ResetPasswordTest < ApplicationSystemTestCase
  test 'user can visit reset password page' do
    visit new_user_password_path

    assert_current_path new_user_password_path
    assert_content 'Forgot your password?'
  end

  test 'signed user can not visit reset password page' do
    user = users(:registered_user)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Password1'
    click_on 'Log in'

    visit new_user_password_path

    refute_current_path new_user_password_path
    refute_content 'Forgot your password?'
  end

  test 'valid user can try reset password' do
    user = users(:registered_user)
    visit new_user_password_path

    fill_in 'Email', with: user.email
    click_on 'Send me reset password instructions'

    assert_content I18n.t('devise.passwords.send_instructions')
    assert_current_path new_user_session_path	
  end

end
