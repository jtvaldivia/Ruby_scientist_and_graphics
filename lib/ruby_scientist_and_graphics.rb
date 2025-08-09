require "gruff"

require_relative "ruby_scientist_and_graphics/dataframe"
require_relative "ruby_scientist_and_graphics/dataset"
require_relative "ruby_scientist_and_graphics/plotter"
require_relative "ruby_scientist_and_graphics/stats"
require_relative "ruby_scientist_and_graphics/interface"
require_relative "ruby_scientist_and_graphics/version"

module RubyScientistAndGraphics
  def self.load_csv(path, options = {})
    Dataset.new(DataFrame.from_csv(path), options)
  end

  # Simple configuration holder
  module Config
    class << self
      attr_accessor :backend
    end
  end

  # Keep a reference to the original internal DataFrame
  ORIG_DATAFRAME = DataFrame unless const_defined?(:ORIG_DATAFRAME)

  # Switch the backend at runtime. Supported: :internal, :rover
  def self.use_backend(backend)
    case backend
    when :internal
      remove_const(:DataFrame) if const_defined?(:DataFrame)
      const_set(:DataFrame, ORIG_DATAFRAME)
      Config.backend = :internal
    when :rover
      require_relative "ruby_scientist_and_graphics/backends/rover_adapter"
      remove_const(:DataFrame) if const_defined?(:DataFrame)
      const_set(:DataFrame, RubyScientistAndGraphics::Backends::RoverAdapter)
      Config.backend = :rover
    else
      raise ArgumentError, "Unknown backend: #{backend}"
    end
    true
  end
end
