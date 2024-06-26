require_relative "boot"

require "rails/all"

ENV["LITESTACK_DATA_PATH"] ="./storage/database"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Clippy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    config.active_job.queue_adapter = :litejob

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = ENV.fetch("TZ", "Central Time (US & Canada)")

    # config.eager_load_paths << Rails.root.join("extras")

    config.secret_key_base = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']
  end
end
