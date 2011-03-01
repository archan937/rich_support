module Rich
  module Support
    extend self

    def append_gem_path(path)
      (@gem_paths ||= []) << path
      check_routes_for(path)

    def after_initialize(&block)
      if Rails::VERSION::MAJOR >= 3
        config.after_initialize &block
      else
        Rails.configuration.after_initialize &block
      end
    end

  private

    def check_routes_for
      require File.expand_path("config/routes", path) if Rails::VERSION::MAJOR < 3
    end

  end
end