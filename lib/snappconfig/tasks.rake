require "shellwords"

namespace :heroku do
  namespace :config do

    task :load, [:app] do |t, args|
      puts "Loading configuration files into Heroku..."
      merged_yaml = Snappconfig.merged_raw.to_yaml
      shell_yaml = Shellwords.escape(merged_yaml)
      
      app_switch = args[:app] ? " --app #{args[:app]}" : ""
      puts `heroku config:set CONFIG=#{shell_yaml}#{app_switch}`
    end

  end
end






