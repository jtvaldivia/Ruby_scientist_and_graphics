require_relative 'test_helper'

class TestInterface < Minitest::Test
  def setup
    @interface = RubyScientistAndGraphics::Interface.new
  end

  def test_load_and_clean_limit
    @interface.load('test/fixtures/sample.csv', remove_columns: [:comentarios], limit: 3)
    assert_equal 3, @interface.dataset.df.size
    refute_includes @interface.dataset.df.vectors.to_a, :comentarios
  end

  def test_fill_missing
    @interface.load('test/fixtures/sample.csv')
    @interface.clean(missing: 0)
    assert !@interface.dataset.df.to_a.flatten.include?(nil)
  end

  def test_pipeline_full
    @interface.pipeline(
      path: 'test/fixtures/sample.csv',
      clean_opts: { missing: 0, remove_columns: [:comentarios] },
      analysis: true,
      graph_opts: { type: :bar, x: :mes, y: :ventas, file: 'test/output.png' }
    )
    assert File.exist?('test/output.png')
  end
end
