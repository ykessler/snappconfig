
namespace :configure do
  task :heroku, [:app] => :environment do   
    yaml = Snappconfig.yaml
    puts "Passing application configuration to Heroku..."
    puts `heroku config:set CONFIG_FILE='#{yaml}'`
  end
end

