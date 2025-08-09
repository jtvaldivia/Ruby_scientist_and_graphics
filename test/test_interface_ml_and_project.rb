require_relative "test_helper"

class TestInterfaceMLAndProject < Minitest::Test
  def setup
    @interface = RubyScientistAndGraphics::Interface.new
  end

  def test_train_model_linear_via_interface_and_predict
    @interface.load("test/fixtures/sample.csv")
    model = @interface.train_model(type: :linear_regression, features: [:mes], target: :ventas)
    assert model.respond_to?(:predict)

    preds = @interface.predict([[1.0], [2.0]])
    assert_instance_of Array, preds
    assert_equal 2, preds.size
  end

  def test_predict_without_model_raises
    @interface.load("test/fixtures/sample.csv")
    assert_raises(RuntimeError) { @interface.predict([[1.0]]) }
  end

  def test_save_and_load_project_via_interface
    @interface.load("test/fixtures/sample.csv")
    path = "test/tmp_project.json"
    @interface.save_project(path)
    assert File.exist?(path)

    @interface.load_project(path)
    refute_nil @interface.dataset
    assert_includes @interface.dataset.df.vectors.to_a, :mes
  ensure
    File.delete(path) if File.exist?(path)
  end
end
