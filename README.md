# Redmine Home Project Plugin

A Redmine plugin that redirects the home screen (Welcome page) to a selected project's overview page.

## Features

- Redirects Redmine's root page (`/`) to a specific project's overview page
- Easy project selection through the plugin settings interface
- Permission-based access control (guest users can only access public projects)

## Requirements

- Redmine 6.0 or higher
- Ruby 3.x
- Rails 7.x

## Installation

1. Clone the plugin into your Redmine plugins directory
   ```bash
   cd /path/to/redmine/plugins
   git clone [repository_url] redmine_home_project
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

MIT License

## Author

Author Name
