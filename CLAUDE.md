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
- `lib/redmine_home_project/welcome_controller_patch.rb` - Redirect logic (to be implemented)
- `app/views/settings/_redmine_home_project_settings.html.erb` - Admin settings UI (to be implemented)
- `config/locales/{ja,en}.yml` - I18n strings (to be implemented)

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

```bash
# After code changes, restart Redmine
touch /usr/local/redmine/tmp/restart.txt
```

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

## Security Considerations

- **Always check permissions** before redirecting: `User.current.allowed_to?(:view_project, project)`
- **Use safe finds**: `Project.find_by(id: id)` not `Project.find(id)` to avoid exceptions
- **Validate project exists** before redirecting
- Settings page is admin-only by default (Redmine handles this)

## Documentation References

Key documentation is in `docs/`:
- `requirement.md` - Original Japanese requirements
- `design.md` - Detailed technical design (Japanese)
- `implementation_plan.md` - Step-by-step implementation guide (Japanese)

All documentation is in Japanese as this is the project's working language.
