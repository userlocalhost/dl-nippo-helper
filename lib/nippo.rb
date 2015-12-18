require "nippo/version"
require "nippo/server"
require "nippo/task"

module Nippo
  # load plugins
  plugin_path = File.dirname(__FILE__) + "/plugin"

  Dir["#{plugin_path}/*"].each do |file|
      require file
  end
end
