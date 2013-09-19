module Snappconfig
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      # all public methods in here will be run in order
    
      def create_configuration
        template "application.yml", "config/application.yml"
        template "application.secrets.yml", "config/application.secrets.yml"
      end

      def ignore_configuration
        if File.exists?(".gitignore")
          append_to_file(".gitignore") do
            <<-EOF.strip_heredoc

            # Ignore application secrets.
            /config/application.secrets.yml
            EOF
          end
        end
      end
    
    end
  end
end