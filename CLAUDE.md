# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Redmine plugin that redirects the home screen (Welcome page) to a selected project's overview page. The plugin allows administrators to configure which project should be displayed as the home screen through a settings interface.

**Target Redmine Version**: 6.0+
**Development Environment**: Redmine 6.1, Ruby 3.x, Rails 7.x

## Architecture

### Core Implementation Pattern

This plugin uses the **Controller Patch Pattern** - a standard Redmine plugin technique where behavior is modified by prepending modules to existing controllers:

1. **WelcomeController Patch** (`lib/redmine_home_project/welcome_controller_patch.rb`):
   - Intercepts `WelcomeController#index`
   - Checks plugin settings for configured home project ID
   - Redirects to project overview if user has `view_project` permission
   - Falls back to original Welcome screen if no project configured or user lacks permission

2. **Settings Storage**:
   - Uses Redmine's built-in `Setting.plugin_redmine_home_project` hash
   - No custom database tables required
   - Stores `{ 'home_project_id' => <project_id> }` format

3. **Permission Handling**:
   - Leverages Redmine's `User.current.allowed_to?(:view_project, project)`
   - Automatically handles both authenticated users and guest users
   - Guest users only see public projects (Redmine's built-in behavior)

### Key Files

- `init.rb` - Plugin registration and settings partial configuration
- `lib/redmine_home_project/welcome_controller_patch.rb` - Redirect logic
- `app/views/settings/_redmine_home_project_settings.html.erb` - Admin settings UI
- `config/locales/{ja,en}.yml` - I18n strings
- `test/functional/welcome_controller_test.rb` - Functional tests for redirect behavior

## Development Commands

### Testing the Plugin

```bash
# From Redmine root directory (/usr/local/redmine)
cd /usr/local/redmine

# Run all plugin tests
bundle exec rake redmine:plugins:test NAME=redmine_home_project

# Run specific test file
bundle exec ruby -I"test" plugins/redmine_home_project/test/functional/welcome_controller_test.rb
```

### Restart Redmine (Development)

**Note**: This environment does not use Passenger, so `touch tmp/restart.txt` will not work. Redmine must be restarted manually by the user through their web server (Puma, Unicorn, WEBrick, etc.).

### Rails Console Testing

```bash
cd /usr/local/redmine
bundle exec rails console

# Verify patch is applied
> WelcomeController.ancestors
# Should include RedmineHomeProject::WelcomeControllerPatch

# Check plugin settings
> Setting.plugin_redmine_home_project
# => {"home_project_id"=>"1"}

# Test permission check
> project = Project.find(1)
> User.current.allowed_to?(:view_project, project)
```

## Important Redmine 6.x Conventions

### Code Comments Language

**All source code comments must be written in English.** This includes:
- Ruby file comments
- ERB template comments
- Test comments
- Inline documentation

### Git Commit Messages

**All Git commit messages must be written in English.** This applies to:
- Commit message subjects
- Commit message bodies
- Branch names
- Pull request titles and descriptions

### Frozen String Literals
All Ruby files must start with:
```ruby
# frozen_string_literal: true
```

### Requiring Dependencies
Use `require_relative` instead of deprecated `require_dependency`:
```ruby
# In init.rb
require_relative 'lib/redmine_home_project/welcome_controller_patch'
```

### Applying Controller Patches
Use `prepend` (not `include` or `alias_method_chain`):
```ruby
module RedmineHomeProject
  module WelcomeControllerPatch
    def index
      # Custom logic here
      super  # Call original method
    end
  end
end

unless WelcomeController.included_modules.include?(RedmineHomeProject::WelcomeControllerPatch)
  WelcomeController.prepend RedmineHomeProject::WelcomeControllerPatch
end
```

## Plugin Settings Pattern

Settings are defined in `init.rb`:
```ruby
settings default: { 'home_project_id' => '' },
         partial: 'settings/redmine_home_project_settings'
```

The settings partial (`app/views/settings/_redmine_home_project_settings.html.erb`) receives:
- `@settings` - Current plugin settings hash
- Access to all Redmine helpers and models

## Testing Considerations

### Setting Plugin Settings in Tests

In tests, plugin settings must be initialized and assigned directly using the actual Setting model (not stubs):

```ruby
def setup
  # Initialize the plugin settings record
  Setting.plugin_redmine_home_project
end

def test_something
  # Set plugin settings for this test
  Setting.plugin_redmine_home_project = { 'home_project_id' => '1' }
  # ... test code
end
```

**Do not use stubs** like `Setting.stubs(:plugin_redmine_home_project).returns(...)` as this can cause `NOT NULL constraint failed: settings.id` errors in SQLite.

### Test Fixtures

Tests use standard Redmine fixtures:
- `projects` - Project 1 (ecookbook) is public, Project 2 (onlinestore) is private
- `users` - User 1 is admin, User 2 (jsmith) is a member of project 1
- `roles`, `members`, `member_roles` - Define project memberships

## Security Considerations

- **Always check permissions** before redirecting: `User.current.allowed_to?(:view_project, project)`
- **Use safe finds**: `Project.find_by(id: id)` not `Project.find(id)` to avoid exceptions
- **Validate project exists** before redirecting
- Settings page is admin-only by default (Redmine handles this)


