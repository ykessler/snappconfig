require "rails"

# Fancy never-nil hash prevents NoMethodErrors during nested access of empty CONFIG object. 
# Need this to get through Heroku's asset precompile stage, when ENV vars are not available. 
# - https://devcenter.heroku.com/articles/rails-asset-pipeline
# - http://stackoverflow.com/a/170240/165673
CONFIG = Hash.new(&(p=lambda{|h,k| h[k] = Hash.new(&p)}))

module Snappconfig
  class Railtie < ::Rails::Railtie
  
    config.before_configuration do

      # Look for CONFIG file in ENV (For Heroku) or else load from file system:
      appconfig = ENV['CONFIG'] ? YAML.load(ENV['CONFIG']) : Snappconfig.merged_raw.deep_dup

      appconfig.deep_merge! appconfig.fetch('defaults', {})
      appconfig.deep_merge! appconfig.fetch(Rails.env.to_s, {})

      Snappconfig.environments.each { |environment| appconfig.delete(environment) }

      check_required(appconfig)

      # Assign ENV values and then delete them from CONFIG so we don't have duplicate data:
      if appconfig.has_key?('ENV')
        appconfig['ENV'].each do |key, value|
          ENV[key] = value.to_s unless value.kind_of? Hash
        end
        appconfig.delete('ENV')
      end

      appconfig = recursively_symbolize_keys(appconfig)
      CONFIG.merge! appconfig
        
    end

    rake_tasks do
      load "snappconfig/tasks.rake"
    end
    
    def check_required(hash)
      
      logger = Logger.new(STDOUT)
      
      hash.each_pair do |key,value|
        if value == '_REQUIRED'
          hash[key] = nil
          logger.warn "Snappconfig missing configuration value: '#{key}' is required for '#{Rails.env.to_s}' environment. Check your application.yml file(s)."
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