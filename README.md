# Redmine Home Project Plugin

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.md)
[![build](https://github.com/haru/redmine_home_project/actions/workflows/build.yml/badge.svg)](https://github.com/haru/redmine_home_project/actions/workflows/build.yml)
[![Maintainability](https://qlty.sh/badges/7b8b9602-1b5b-4056-a72d-4240bf6882ad/maintainability.svg)](https://qlty.sh/gh/haru/projects/redmine_home_project)
[![codecov](https://codecov.io/gh/haru/redmine_home_project/graph/badge.svg?token=KXhMNpM6u9)](https://codecov.io/gh/haru/redmine_home_project)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/haru/redmine_home_project)
![Redmine](https://img.shields.io/badge/redmine->=6.0-blue?logo=redmine&logoColor=%23B32024&labelColor=f0f0f0&link=https%3A%2F%2Fwww.redmine.org)

A Redmine plugin that redirects the home screen (Welcome page) to a selected project's overview page.

## Features

- Redirects Redmine's root page (`/`) to a specific project's overview page
- Easy project selection through the plugin settings interface
- Permission-based access control (respects user permissions for project access)
- Falls back to the default Welcome page if no project is configured or user lacks access

## Installation

1. Clone the plugin into your Redmine plugins directory
   ```bash
   cd /path/to/redmine/plugins
   git clone https://github.com/haru/redmine_home_project.git redmine_home_project
   ```

2. Restart Redmine
   ```bash
   touch /path/to/redmine/tmp/restart.txt
   ```
   Note: Restart method depends on your web server (Puma, Unicorn, WEBrick, etc.)

## Usage

1. Go to Redmine Administration > Plugins > "Redmine Home Project plugin" and click "Configure"
2. Select the project you want to display as the home screen
3. Click "Apply"
4. When you access Redmine's home screen (`/`), you will be redirected to the selected project's overview page

**Note:** If the selected project is not accessible by the current user (e.g., a private project for anonymous users), the default Welcome page will be displayed instead.

## Uninstallation

```bash
rm -rf /path/to/redmine/plugins/redmine_home_project
touch /path/to/redmine/tmp/restart.txt
```

## Testing

```bash
cd /path/to/redmine
bundle exec rake redmine:plugins:test NAME=redmine_home_project
```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Author

[Haruyuki Iida](https://github.com/haru)
