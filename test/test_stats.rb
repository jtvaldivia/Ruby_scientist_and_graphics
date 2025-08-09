require_relative 'test_helper'

class TestStats < Minitest::Test
  def setup
    df = RubyScientistAndGraphics::IO.load_csv('test/fixtures/sample.csv')
    @stats = RubyScientistAndGraphics::Stats.new(df)
  end

  def test_describe_output
    output = capture_io { @stats.describe }
    assert_match /mes:/, output.first
  end

  def test_correlation
    corr = @stats.correlation(:ventas, :ventas)
    assert_in_delta 1.0, corr, 0.0001
  end
end
