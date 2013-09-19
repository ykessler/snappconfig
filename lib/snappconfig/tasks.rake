require "shellwords"

namespace :snappconfig do
  
  task :heroku, [:app] => :environment do   
    puts "Passing application configuration to Heroku..."
    merged_yaml = Snappconfig.merged_raw.to_yaml
    shell_yaml = Shellwords.escape(merged_yaml)
    puts `heroku config:set CONFIG=#{shell_yaml}`
  end
  
end



