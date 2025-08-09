module RubyScientistAndGraphics
  class Plotter
    def initialize(df)
      @df = df
    end

    def bar(x:, y:, file: "plot.png")
      g = Gruff::Bar.new
      g.title = "#{y} por #{x}"
      @df[x].to_a.each_with_index do |label, idx|
        g.data(label, [@df[y][idx]])
      end
      g.write(file)
      puts "Gráfico guardado en #{file}"
    end

    def line(x:, y:, file: "plot.png")
      g = Gruff::Line.new
      g.title = "#{y} por #{x}"
      g.labels = @df[x].to_a.each_with_index.map { |v, i| [i, v.to_s] }.to_h
      g.data(y.to_sym, @df[y].to_a)
      g.write(file)
      puts "Gráfico guardado en #{file}"
    end
  end
end
