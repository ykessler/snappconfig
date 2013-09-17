require "snappconfig/railtie"
#require "snappconfig/tasks"

module Snappconfig
  extend self
  
  def raw
    @raw ||= yaml && YAML.load(yaml) || {}
  end

  def yaml
    @yaml ||= File.exist?(path) ? ERB.new(File.read(path)).result : nil
  end

  def path
    @path ||= Rails.root.join("config", "application.yml")
  end
  
end
