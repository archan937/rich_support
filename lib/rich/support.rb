module Rich
  module Support
    extend self

    def append_gem_path(path)
      (@gem_paths ||= []) << path

      check_controllers_for path
      check_routes_for      path
      check_views_for       path
    end

    def after_initialize(&block)
      if Rails::VERSION::MAJOR >= 3
        config.after_initialize &block
      else
        Rails.configuration.after_initialize &block
      end
    end

  private

    def check_controllers_for(path)
      return if Rails::VERSION::MAJOR >= 3
      if File.exists?(controllers = File.expand_path("app/controllers", path))
        $LOAD_PATH << controllers
        ActiveSupport::Dependencies.autoload_paths << controllers
        ActiveSupport::Dependencies.autoload_once_paths.delete controllers
      end
    end

    def check_routes_for(path)
      return if Rails::VERSION::MAJOR >= 3
      if File.exists?(routes = File.expand_path("config/routes.rb", path))
        require routes
      end
    end

    def check_views_for(path)
      return if Rails::VERSION::MAJOR >= 3
      if File.exists?(views = File.expand_path("app/views", path))
        if ActionController::Base.respond_to? :append_view_path
          ActionController::Base.append_view_path views
        elsif ActionController::Base.respond_to? :view_paths
          ActionController::Base.self.view_paths << views
        end
      end
    end

  end
end