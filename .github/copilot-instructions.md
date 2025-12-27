# Copilot Instructions for Redmine Home Project Plugin

## Project Overview

A Redmine plugin that redirects the home screen (`/`) to a selected project's overview page. Uses the **Controller Patch Pattern** - prepending modules to existing Redmine controllers.

**Target**: Redmine 6.0+, Ruby 3.x, Rails 7.x

## Architecture

### Core Pattern: Controller Patching

```ruby
# lib/redmine_home_project/welcome_controller_patch.rb
module RedmineHomeProject
  module WelcomeControllerPatch
    def index
      # Custom logic
      super  # Call original
    end
  end
end
WelcomeController.prepend RedmineHomeProject::WelcomeControllerPatch
```

### Key Components

| File | Purpose |
|------|---------|
| [init.rb](../init.rb) | Plugin registration, settings definition |
| [lib/redmine_home_project/welcome_controller_patch.rb](../lib/redmine_home_project/welcome_controller_patch.rb) | Redirect logic with permission checks |
| [app/views/settings/_redmine_home_project_settings.html.erb](../app/views/settings/_redmine_home_project_settings.html.erb) | Admin settings UI |
| [config/locales/{en,ja}.yml](../config/locales/) | I18n translations |

### Settings Storage

Uses `Setting.plugin_redmine_home_project` hash (no custom DB tables):
```ruby
Setting.plugin_redmine_home_project['home_project_id']
```

## Development Commands

```bash
# From /usr/local/redmine (NOT plugin directory)
cd /usr/local/redmine

# Run all plugin tests
bundle exec rake redmine:plugins:test NAME=redmine_home_project

# Run specific test file
bundle exec ruby -I"test" plugins/redmine_home_project/test/functional/welcome_controller_test.rb

# Rails console
bundle exec rails console
```

## Code Conventions

### Required in ALL Ruby files
```ruby
# frozen_string_literal: true
```

### Language
- **Source code comments**: English only
- **Commit messages**: English

### Controller Patches
- Use `prepend`, NOT `include` or `alias_method_chain`
- Guard against double-patching: `unless Controller.included_modules.include?(Patch)`

### Dependencies
- Use `require_relative`, NOT deprecated `require_dependency`

## Testing Patterns

### Plugin Settings in Tests
Initialize and set directly (NOT stubs - causes SQLite constraint errors):
```ruby
def setup
  Setting.plugin_redmine_home_project  # Initialize record
end

def test_example
  Setting.plugin_redmine_home_project = { 'home_project_id' => '1' }
end
```

### Key Fixtures
- `projects`: ID 1 (ecookbook) = public, ID 2 (onlinestore) = private
- `users`: ID 1 = admin, ID 2 (jsmith) = member of project 1

## Security Requirements

Always check permissions before redirecting:
```ruby
if project && User.current.allowed_to?(:view_project, project)
  redirect_to project_path(project)
end
```

Use safe finds: `Project.find_by(id: id)` not `Project.find(id)`
