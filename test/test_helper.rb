# Load the Redmine helper
require "simplecov"
require "simplecov-cobertura"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::CoberturaFormatter,
  SimpleCov::Formatter::HTMLFormatter
  # Coveralls::SimpleCov::Formatter
])

SimpleCov.start do
  root File.expand_path(File.dirname(__FILE__) + "/..")
  add_filter "/test/"
  add_filter "lib/tasks"

  add_group "Controllers", "app/controllers"
  add_group "Models", "app/models"
  add_group "Helpers", "app/helpers"

  add_group "Plugin Features", "lib/redmine_ai_helper"
end

require_relative '../../../test/test_helper'
