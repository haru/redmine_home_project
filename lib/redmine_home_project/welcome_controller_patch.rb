# frozen_string_literal: true

# RedmineHomeProject namespace
#
# This module contains patches and functionality for the Redmine Home Project plugin,
# which redirects the home screen to a selected project's overview page.
module RedmineHomeProject
  # Patch for WelcomeController
  #
  # This module modifies the WelcomeController#index action to redirect users
  # to a configured home project instead of the default Redmine welcome page.
  # The redirect only occurs if a home project is configured and the current user
  # has permission to view it.
  module WelcomeControllerPatch
    # Override the index action to redirect to configured home project
    #
    # Checks plugin settings for a configured home project ID. If found and the
    # current user has view permissions, redirects to that project's overview page.
    # Otherwise, falls back to the original welcome page behavior.
    #
    # @return [void]
    def index
      home_project_id = Setting.plugin_redmine_home_project['home_project_id']

      if home_project_id.present?
        project = Project.find_by(id: home_project_id)

        # If project exists and user (including guest users) has view permission
        if project && User.current.allowed_to?(:view_project, project)
          redirect_to project_path(project)
          return
        end
      end

      super
    end
  end
end
