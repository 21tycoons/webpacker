require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/string/inquiry"
require "active_support/logger"
require "active_support/tagged_logging"

module Webpacker
  extend self

  def instance=(instance)
    @instance = instance
  end

  def instance
    @instance ||= Webpacker::Instance.new
  end

  def with_node_env(env)
    original = ENV["NODE_ENV"]
    ENV["NODE_ENV"] = env
    yield
  ensure
    ENV["NODE_ENV"] = original
  end

  def ensure_log_goes_to_stdout
    old_logger = Webpacker.logger
    Webpacker.logger = Logger.new(STDOUT)
    yield
  ensure
    Webpacker.logger = old_logger
  end

  def delegate_to(object, definitions)
    delegate definitions, to: object
  end

  delegate :logger, :logger=, :env, :inlining_css?, to: :instance
  delegate :config, :compiler, :manifest, :commands, :dev_server, to: :instance

  delegate :bootstrap, :clean, :clobber, :compile, to: :commands
  # delegate_to :commands, :bootstrap, :clean, :clobber, :compile
end

require "webpacker/instance"
require "webpacker/env"
require "webpacker/configuration"
require "webpacker/manifest"
require "webpacker/compiler"
require "webpacker/commands"
require "webpacker/dev_server"

require "webpacker/railtie" if defined?(Rails)
