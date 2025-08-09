require_relative 'test_helper'

class TestDataset < Minitest::Test
  def setup
    df = RubyScientistAndGraphics::IO.load_csv('test/fixtures/sample.csv')
    @dataset = RubyScientistAndGraphics::Dataset.new(df)
  end

  def test_remove_columns
    @dataset.remove_columns([:comentarios])
    refute_includes @dataset.df.vectors.to_a, :comentarios
  end

  def test_add_column
    @dataset.add_column(:nueva, [1,2,3])
    assert_includes @dataset.df.vectors.to_a, :nueva
  end

  def test_limit_rows
    @dataset.limit_rows(2)
    assert_equal 2, @dataset.df.size
  end

  def test_fill_missing
    @dataset.fill_missing(0)
    assert !@dataset.df.to_a.flatten.include?(nil)
  end
end
