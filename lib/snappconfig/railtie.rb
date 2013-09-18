require "rails"

CONFIG = {}

module Snappconfig
  class Railtie < ::Rails::Railtie
  
    config.before_configuration do

      # Look for config file in ENV (For Heroku) or else load from file system:
      app_conf = ENV['CONFIG_FILE'] ? YAML.load(ENV['CONFIG_FILE']) : Snappconfig.raw
    
      app_conf.deep_merge! app_conf.fetch('defaults', {})
      app_conf.deep_merge! app_conf.fetch(Rails.env, {})

      # Assign ENV values...
      if app_conf.has_key?('ENV')
        app_conf['ENV'].each do |key, value|
          ENV[key] = value.to_s unless value.kind_of? Hash
        end
        # ... and clear ENV values from CONFIG so we don't have duplicate data:
        app_conf.delete('ENV')
        app_conf.each do |key,value|
          value.delete('ENV') if value.is_a?(Hash) && value.has_key?('ENV')
        end
      end

      app_conf = recursively_symbolize_keys(app_conf)
      CONFIG.merge! app_conf
      
    end

    rake_tasks do
      load "snappconfig/tasks.rake"
    end
    
    private
    
    def recursively_symbolize_keys(hash)
      sym_hash = {}
      hash.each_pair do |key,value|
        hash[key] = value.is_a?(Hash) ? recursively_symbolize_keys(value) : value 
        sym_hash[(key.to_sym rescue key) || key] = hash[key]
      end
      sym_hash
    end
    
  end
end