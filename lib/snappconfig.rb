require "snappconfig/railtie"

module Snappconfig
  extend self
  
  def config_files
    @config_files ||= Dir.entries(Rails.root.join("config").to_s).grep(/(^application)(\.|\..*\.)(yml$)/).sort { |x,y| x.chomp(".yml") <=> y.chomp(".yml") }
  end
  
  def merged_raw
    if @merged_raw 
      return @merged_raw
    else  
      @merged_raw = {}
      config_files.each do | file_name |
        file = ConfigFile.new(file_name)
        @merged_raw.deep_merge! file.raw
      end
      return @merged_raw
    end
  end
  
  class ConfigFile
    
    def initialize(name)
      @name = name
    end
    
    def raw
      @raw ||= yaml && YAML.load(yaml) || {}
    end
    
    def yaml
      @yaml ||= File.exist?(path) ? ERB.new(File.read(path)).result : nil
    end

    def path
      @path ||= Rails.root.join("config", @name)
    end
    
  end
  
end
