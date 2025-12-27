# frozen_string_literal: true

Redmine::Plugin.register :redmine_home_project do
  name 'Redmine Home Project plugin'
  author 'Author Name'
  description 'ホーム画面を指定したプロジェクトの概要画面に変更します'
  version '0.1.0'
  url 'https://github.com/username/redmine_home_project'
  author_url 'https://github.com/username'

  # Redmine 6.0 以上に対応
  requires_redmine version_or_higher: '6.0.0'

  settings default: { 'home_project_id' => '' },
           partial: 'settings/redmine_home_project_settings'
end

# Redmine 6.x では require_relative を使用
require_relative 'lib/redmine_home_project/welcome_controller_patch'
