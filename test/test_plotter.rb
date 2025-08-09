require_relative 'test_helper'

class TestPlotter < Minitest::Test
  def setup
    df = RubyScientistAndGraphics::IO.load_csv('test/fixtures/sample.csv')
    @plotter = RubyScientistAndGraphics::Plotter.new(df)
  end

  def test_bar_plot_creates_file
    @plotter.bar(x: :mes, y: :ventas, file: 'test/bar_test.png')
    assert File.exist?('test/bar_test.png')
  end

  def test_line_plot_creates_file
    @plotter.line(x: :mes, y: :ventas, file: 'test/line_test.png')
    assert File.exist?('test/line_test.png')
  end
end
