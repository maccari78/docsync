require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module DocSync
  class Application < Rails::Application

    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    config.time_zone = 'America/Argentina/Buenos_Aires'
  end
end
