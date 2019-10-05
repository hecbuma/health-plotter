require 'test_helper'

class StudiesControllerTest < ActionDispatch::IntegrationTest
  test 'logged user can access index' do
    user = users(:registered_user)
    sign_in user

    get studies_path
    assert :success
  end

  test 'logged user can visit edit study' do
    user = users(:registered_user)

    sign_in user
    get edit_study_path(user.studies.last)

    assert :success
  end

  test 'logged user can edit study' do
    user = users(:registered_user)

    sign_in user
    put study_path(user.studies.last), params: {study: {name: 'Example new name'}}

    assert_equal 'Example new name', user.studies.reload.last.name
    assert :success
  end

  test 'logged user can delete study' do
    user = users(:registered_user)
    sign_in user

    assert_difference 'Study.count', -1 do
     delete study_path(user.studies.last)
    end
    assert_redirected_to result_sheet_path(user.result_sheets.last)
  end

  test 'no logged user cannot access study path' do
    get studies_path
    assert_redirected_to new_user_session_path
  end
end
