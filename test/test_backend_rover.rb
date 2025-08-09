require_relative "test_helper"

class TestBackendRover < Minitest::Test
  def setup
    # Only run if rover-df is available

    gem "rover-df"
    require "rover"
  rescue Gem::LoadError
    skip "rover-df not installed; skipping adapter smoke test"
  end

  def test_switch_to_rover_backend
    skip "rover-df not installed; skipping adapter smoke test" unless defined?(::Rover)

    RubyScientistAndGraphics.use_backend(:rover)
    df = RubyScientistAndGraphics::IO.load_csv("test/fixtures/sample.csv")

    # Basic expectations
    assert_equal 5, df.size
    assert_includes df.vectors.to_a, :mes

    # Switch back to internal backend to not affect other tests
    RubyScientistAndGraphics.use_backend(:internal)
  end
end
