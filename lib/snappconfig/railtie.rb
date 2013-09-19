require "rails"

CONFIG = {}

module Snappconfig
  class Railtie < ::Rails::Railtie
  
    config.before_configuration do

      # Look for config file in ENV (For Heroku) or else load from file system:
      app_config = ENV['SNAPP_CONFIG'] ? YAML.load(ENV['SNAPP_CONFIG']) : Snappconfig.merged_raw
    
      app_config.deep_merge! app_config.fetch('defaults', {})
      app_config.deep_merge! app_config.fetch(Rails.env, {})

      check_required(app_config)

      # Assign ENV values...
      if app_config.has_key?('ENV')
        app_config['ENV'].each do |key, value|
          ENV[key] = value.to_s unless value.kind_of? Hash
        end
        # ... and clear ENV values from CONFIG so we don't have duplicate data:
        app_config.delete('ENV')
        app_config.each do |key,value|
          value.delete('ENV') if value.is_a?(Hash) && value.has_key?('ENV')
        end
      end

      app_config = recursively_symbolize_keys(app_config)
      CONFIG.merge! app_config
      
    end

    rake_tasks do
      load "snappconfig/tasks.rake"
    end
    
    private
    
    def check_required(hash)
      hash.each_pair do |key,value|
        if value == '_REQUIRED'
          raise "The configuration value #{key} is required but was not supplied. Check your snapp.yml files."
        elsif value.is_a?(Hash)
          check_required(value) 
        end
      end
    end
    
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