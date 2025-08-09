require_relative "test_helper"

class TestBackendSwitch < Minitest::Test
  def setup
    # Ensure we start from internal backend for isolation
    RubyScientistAndGraphics.use_backend(:internal)
  end

  def test_switch_to_internal_backend_sets_dataframe_constant
    RubyScientistAndGraphics.use_backend(:internal)
    assert_equal RubyScientistAndGraphics::ORIG_DATAFRAME, RubyScientistAndGraphics::DataFrame

    df = RubyScientistAndGraphics::IO.load_csv("test/fixtures/sample.csv")
    assert_equal RubyScientistAndGraphics::ORIG_DATAFRAME, df.class
    assert_equal 5, df.size
  end

  def test_unknown_backend_raises
    assert_raises(ArgumentError) { RubyScientistAndGraphics.use_backend(:unknown_backend) }
  end
end
