require_relative 'test_helper'

class TestUtils < Minitest::Test
  def test_normalize
    arr = [1, 2, 3]
    norm = RubyScientistAndGraphics::Utils.normalize(arr)
    assert_in_delta 0.0, norm.min, 0.0001
    assert_in_delta 1.0, norm.max, 0.0001
  end

  def test_standardize
    arr = [1, 2, 3, 4, 5]
    std = RubyScientistAndGraphics::Utils.standardize(arr)
    assert_in_delta 0.0, std.sum / std.size, 0.01
  end

  def test_one_hot_encode
    arr = [:a, :b, :a]
    encoded = RubyScientistAndGraphics::Utils.one_hot_encode(arr)
    assert_equal [[1,0],[0,1],[1,0]], encoded
  end

  def test_drop_na
    df = RubyScientistAndGraphics::IO.load_csv('test/fixtures/sample.csv')
    filtered = RubyScientistAndGraphics::Utils.drop_na(df)
    refute filtered.to_a.flatten.include?(nil)
  end
end
