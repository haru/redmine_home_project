# frozen_string_literal: true

module RedmineHomeProject
  module WelcomeControllerPatch
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

# Apply patch using prepend for Redmine 6.x
unless WelcomeController.included_modules.include?(RedmineHomeProject::WelcomeControllerPatch)
  WelcomeController.prepend RedmineHomeProject::WelcomeControllerPatch
end
