# frozen_string_literal: true

require "application_system_test_case"

class  LoginTest < ApplicationSystemTestCase
  test 'guest user visits sessions page' do
    visit new_user_session_path

    assert_content 'Log in'
    assert_current_path new_user_session_path
  end

  test 'signed in user cannot visit sessions page' do
    user = users(:registered_user)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Password1'
    click_on 'Log in'

    assert_current_path dashboard_path

    visit new_user_session_path

    refute_content 'log in'
    refute_current_path new_user_session_path
  end

  test 'user can access on sessions page' do
    user = users(:registered_user)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Password1'
    click_on 'Log in'

    refute_current_path new_user_session_path
    assert_current_path dashboard_path
  end

  test 'show errors when guest user does not enter valid email' do
    visit new_user_session_path
    fill_in 'Email', with: 'example@example.example'
    fill_in 'Password', with: 'passWord'
    click_on 'Log in'
    
    assert_content 'Invalid Email or password.'
    assert_current_path new_user_session_path
  end
end
