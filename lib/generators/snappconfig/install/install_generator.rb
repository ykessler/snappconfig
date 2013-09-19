module Snappconfig
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      # all public methods in here will be run in order
    
      def create_configuration
        template "snapp.yml", "config/snapp.yml"
        template "snapp.secrets.yml", "config/snapp.secrets.yml"
      end

      def ignore_configuration
        if File.exists?(".gitignore")
          append_to_file(".gitignore") do
            <<-EOF.strip_heredoc

            # Ignore application configuration.
            /config/snapp.secrets.yml
            EOF
          end
        end
      end
    
    end
  end
end