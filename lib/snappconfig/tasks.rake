require "shellwords"

namespace :heroku do
  namespace :config do

    task :load do   
      puts "Loading configuration files into Heroku..."
      merged_yaml = Snappconfig.merged_raw.to_yaml
      shell_yaml = Shellwords.escape(merged_yaml)
      puts `heroku config:set CONFIG=#{shell_yaml}`
    end

  end
end





