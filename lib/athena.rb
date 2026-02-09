# frozen_string_literal: true

require "zeitwerk"
require "optparse"
require "colorize"

# Eager-loaded (not autoloadable by convention)
require_relative "athena/errors"
require_relative "athena/core_ext/string"
require_relative "athena/core_ext/object"
require_relative "athena/core_ext/array"
require_relative "athena/core_ext/hash"
require_relative "athena/core_ext/option_parser"

module Athena
  LOADER = Zeitwerk::Loader.new.tap do |loader|
    loader.tag = "athena"
    loader.inflector.inflect(
      "dsl" => "DSL",
      "command_dsl" => "CommandDSL",
      "block_dsl" => "BlockDSL"
    )
    loader.push_dir(File.expand_path("..", __FILE__))
    loader.ignore(File.expand_path("athena/errors.rb", __dir__))
    loader.ignore(File.expand_path("athena/core_ext", __dir__))
    loader.ignore(File.expand_path("ergane.rb", __dir__))
    loader.setup
  end

  def self.root
    @root ||= Pathname.new(File.expand_path("../..", __FILE__))
  end
end
