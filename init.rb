# frozen_string_literal: true

Redmine::Plugin.register :redmine_home_project do
  name 'Redmine Home Project plugin'
  author 'Haruyuki Iida'
  description 'Redirects the home screen to a selected project overview page'
  version '0.1.0'
  url 'https://github.com/haru/redmine_home_project'
  author_url 'https://github.com/haru'

  # Requires Redmine 6.0 or higher
  requires_redmine version_or_higher: '6.0.0'

  settings default: { 'home_project_id' => '' },
           partial: 'settings/redmine_home_project_settings'
end

# Use require_relative for Redmine 6.x
require_relative 'lib/redmine_home_project/welcome_controller_patch'
