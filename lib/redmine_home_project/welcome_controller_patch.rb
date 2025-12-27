# frozen_string_literal: true

module RedmineHomeProject
  module WelcomeControllerPatch
    def index
      home_project_id = Setting.plugin_redmine_home_project['home_project_id']

      if home_project_id.present?
        project = Project.find_by(id: home_project_id)

        # プロジェクトが存在し、ユーザー（ゲストユーザーを含む）が閲覧権限を持つ場合
        if project && User.current.allowed_to?(:view_project, project)
          redirect_to project_path(project)
          return
        end
      end

      super
    end
  end
end

# Redmine 6.x では prepend を使用してパッチを適用
unless WelcomeController.included_modules.include?(RedmineHomeProject::WelcomeControllerPatch)
  WelcomeController.prepend RedmineHomeProject::WelcomeControllerPatch
end
