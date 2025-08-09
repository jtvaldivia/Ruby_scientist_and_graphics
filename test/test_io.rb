require_relative 'test_helper'

class TestIO < Minitest::Test
  def test_load_csv
    df = RubyScientistAndGraphics::IO.load_csv('test/fixtures/sample.csv')
    assert_equal 5, df.size
    assert_includes df.vectors.to_a, :mes
  end

  def test_save_and_load_project
    df = RubyScientistAndGraphics::IO.load_csv('test/fixtures/sample.csv')
    RubyScientistAndGraphics::IO.save_project(df, 'test/proj.json')
    loaded_df = RubyScientistAndGraphics::IO.load_project('test/proj.json')
    assert_equal df.vectors.to_a, loaded_df.vectors.to_a
  ensure
    File.delete('test/proj.json') if File.exist?('test/proj.json')
  end
end
