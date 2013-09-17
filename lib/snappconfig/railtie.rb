require "rails"
#require "yaml"

CONFIG = {}

module Snappconfig
  class Railtie < ::Rails::Railtie
  
    config.before_configuration do
      
      begin
      
        if ENV['CONFIG_FILE']
          
          # ERB
          ##config_file = ENV['CONFIG_FILE']
          ##yaml = ERB.new(config_file).result
          
          # Non-ERB:
          yaml = ENV['CONFIG_FILE']
          
          app_conf = yaml && YAML.load(yaml) || {}
        else
          app_conf = Snappconfig.raw
        end
      
        # Merge environment-specific values with defaults:
        app_conf.deep_merge! app_conf.fetch(Rails.env, {})

        # Assign ENV values:
        if app_conf.has_key?('ENV')
          app_conf['ENV'].each do |key, value|
            ENV[key] = value.to_s unless value.kind_of? Hash
          end
          # Clear ENV values from CONFIG so we don't have duplicate data:
          app_conf.delete('ENV')
          app_conf.each do |key,value|
            value.delete('ENV') if value.is_a?(Hash) && value.has_key?('ENV')
          end
        end

        # Symbolize keys:
        app_conf = recursively_symbolize_keys(app_conf)
        # Apply to constant:
        CONFIG.merge! app_conf
      
      rescue
        raise #{}"Could not load configuration"
      end
      
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