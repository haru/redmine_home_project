# frozen_string_literal: true

require_relative '../test_helper'

class RedmineHomeProject::WelcomeControllerTest < Redmine::ControllerTest
  tests WelcomeController
  fixtures :projects, :users, :roles, :members, :member_roles

  def setup
    @request.session[:user_id] = nil
    User.current = nil
    # Initialize plugin settings (create record)
    Setting.plugin_redmine_home_project
  end

  def test_index_without_home_project_setting
    # Without plugin setting, the default Welcome page is displayed
    Setting.plugin_redmine_home_project = { 'home_project_id' => '' }

    get :index
    assert_response :success
    assert_select 'h3', text: 'Latest news'
  end

  def test_index_with_home_project_setting_as_admin
    # With home project setting as admin user, redirects to the project
    @request.session[:user_id] = 1 # admin
    Setting.plugin_redmine_home_project = { 'home_project_id' => '1' }

    get :index
    assert_redirected_to '/projects/ecookbook'
  end

  def test_index_with_home_project_setting_as_member
    # With home project setting as project member, redirects to the project
    @request.session[:user_id] = 2 # jsmith (member of project 1)
    Setting.plugin_redmine_home_project = { 'home_project_id' => '1' }

    get :index
    assert_redirected_to '/projects/ecookbook'
  end

  def test_index_with_home_project_setting_as_non_member
    # With public project as non-member, redirects to the project
    @request.session[:user_id] = 3 # User without project 1 membership
    Setting.plugin_redmine_home_project = { 'home_project_id' => '1' } # public project

    get :index
    assert_redirected_to '/projects/ecookbook'
  end

  def test_index_with_private_project_as_non_member
    # With private project as non-member, shows the Welcome page
    @request.session[:user_id] = 3 # User without project 2 membership
    Setting.plugin_redmine_home_project = { 'home_project_id' => '2' } # private project

    get :index
    assert_response :success
    assert_select 'h3', text: 'Latest news'
  end

  def test_index_with_public_project_as_anonymous
    # With public project as anonymous user, redirects to the project
    Setting.plugin_redmine_home_project = { 'home_project_id' => '1' } # public project

    get :index
    assert_redirected_to '/projects/ecookbook'
  end

  def test_index_with_private_project_as_anonymous
    # With private project as anonymous user, shows the Welcome page
    Setting.plugin_redmine_home_project = { 'home_project_id' => '2' } # private project

    get :index
    assert_response :success
    assert_select 'h3', text: 'Latest news'
  end

  def test_index_with_non_existent_project
    # With non-existent project ID, shows the Welcome page
    Setting.plugin_redmine_home_project = { 'home_project_id' => '99999' }

    get :index
    assert_response :success
    assert_select 'h3', text: 'Latest news'
  end

  def test_index_with_invalid_project_id
    # With invalid project ID, shows the Welcome page
    Setting.plugin_redmine_home_project = { 'home_project_id' => 'invalid' }

    get :index
    assert_response :success
    assert_select 'h3', text: 'Latest news'
  end

  def test_patch_is_applied
    # Verify that the patch is correctly applied
    assert WelcomeController.ancestors.include?(RedmineHomeProject::WelcomeControllerPatch)
  end
end
