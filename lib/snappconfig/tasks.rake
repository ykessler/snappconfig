
namespace :snappconfig do
  task :heroku, [:app] => :environment do   
    puts "Passing application configuration to Heroku..."
    shell_yaml = Snappconfig.shell_yaml
    puts `heroku config:set CONFIG_FILE=#{shell_yaml}`
  end
end

