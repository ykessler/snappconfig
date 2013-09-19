require "snappconfig/railtie"

module Snappconfig
  extend self
  
  def snapp_files
    @snapp_files ||= Dir.entries(Rails.root.join("config").to_s).grep(/(^snapp)(\.|\..*\.)(yml$)/).sort
  end
  
  def merged_raw
    if @merged_raw 
      return @merged_raw
    else  
      @merged_raw = {}
      snapp_files.each do | file_name |
        file = Snappfile.new(file_name)
        @merged_raw.deep_merge! file.raw
      end
      return @merged_raw
    end
  end
  
  class Snappfile
    
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
