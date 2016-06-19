require "shellwords"

namespace :heroku do
  namespace :config do

    desc "Snappconfig task to load configuration into Heroku from YAML file(s)"
    task :load, [:app] do |t, args|

      puts "Loading configuration files into Heroku..."
      merged_yaml = Snappconfig.merged_raw.to_yaml
      shell_yaml = Shellwords.escape(merged_yaml)

      app_switch = args[:app] ? " --app #{args[:app]}" : ""
      # NOTE: Need to use 'Bundler.with_clean_env' instead of regular shell call
      # in order to avoid Bundler::RubyVersionMismatch error (SEE: https://github.com/rbenv/rbenv/issues/400)
      Bundler.with_clean_env { sh "heroku config:set CONFIG=#{shell_yaml}#{app_switch}" }
    end

  end
end
