require_relative 'test_helper'

class TestML < Minitest::Test
  def setup
    df = RubyScientistAndGraphics::IO.load_csv('test/fixtures/sample.csv')
    @ml = RubyScientistAndGraphics::ML.new(df)
  end

  def test_linear_regression
    model = @ml.linear_regression(features: [:mes], target: :ventas)
    assert model.respond_to?(:predict)
  end

  def test_kmeans
    model = @ml.kmeans(features: [:ventas], clusters: 2)
    assert_equal 2, model.n_clusters
  end
end
