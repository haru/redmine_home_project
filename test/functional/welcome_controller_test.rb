# frozen_string_literal: true

require_relative '../test_helper'

class RedmineHomeProject::WelcomeControllerTest < Redmine::ControllerTest
  tests WelcomeController
  fixtures :projects, :users, :roles, :members, :member_roles

  def setup
    @request.session[:user_id] = nil
    User.current = nil
    # プラグイン設定を初期化（レコードを作成）
    Setting.plugin_redmine_home_project
  end

  def test_index_without_home_project_setting
    # プラグイン設定なしの場合、通常のWelcome画面が表示される
    Setting.plugin_redmine_home_project = { 'home_project_id' => '' }

    get :index
    assert_response :success
    assert_select 'h3', text: 'Latest news'
  end

  def test_index_with_home_project_setting_as_admin
    # 管理者ユーザーでプロジェクトが設定されている場合、リダイレクトされる
    @request.session[:user_id] = 1 # admin
    Setting.plugin_redmine_home_project = { 'home_project_id' => '1' }

    get :index
    assert_redirected_to '/projects/ecookbook'
  end

  def test_index_with_home_project_setting_as_member
    # プロジェクトメンバーの場合、リダイレクトされる
    @request.session[:user_id] = 2 # jsmith (member of project 1)
    Setting.plugin_redmine_home_project = { 'home_project_id' => '1' }

    get :index
    assert_redirected_to '/projects/ecookbook'
  end

  def test_index_with_home_project_setting_as_non_member
    # プロジェクトメンバーでない場合でも公開プロジェクトならリダイレクトされる
    @request.session[:user_id] = 3 # User without project 1 membership
    Setting.plugin_redmine_home_project = { 'home_project_id' => '1' } # public project

    get :index
    assert_redirected_to '/projects/ecookbook'
  end

  def test_index_with_private_project_as_non_member
    # 非公開プロジェクトでメンバーでない場合、Welcome画面が表示される
    @request.session[:user_id] = 3 # User without project 2 membership
    Setting.plugin_redmine_home_project = { 'home_project_id' => '2' } # private project

    get :index
    assert_response :success
    assert_select 'h3', text: 'Latest news'
  end

  def test_index_with_public_project_as_anonymous
    # ゲストユーザーで公開プロジェクトの場合、リダイレクトされる
    Setting.plugin_redmine_home_project = { 'home_project_id' => '1' } # public project

    get :index
    assert_redirected_to '/projects/ecookbook'
  end

  def test_index_with_private_project_as_anonymous
    # ゲストユーザーで非公開プロジェクトの場合、Welcome画面が表示される
    Setting.plugin_redmine_home_project = { 'home_project_id' => '2' } # private project

    get :index
    assert_response :success
    assert_select 'h3', text: 'Latest news'
  end

  def test_index_with_non_existent_project
    # 存在しないプロジェクトIDの場合、Welcome画面が表示される
    Setting.plugin_redmine_home_project = { 'home_project_id' => '99999' }

    get :index
    assert_response :success
    assert_select 'h3', text: 'Latest news'
  end

  def test_index_with_invalid_project_id
    # 不正なプロジェクトIDの場合、Welcome画面が表示される
    Setting.plugin_redmine_home_project = { 'home_project_id' => 'invalid' }

    get :index
    assert_response :success
    assert_select 'h3', text: 'Latest news'
  end

  def test_patch_is_applied
    # パッチが正しく適用されていることを確認
    assert WelcomeController.ancestors.include?(RedmineHomeProject::WelcomeControllerPatch)
  end
end
