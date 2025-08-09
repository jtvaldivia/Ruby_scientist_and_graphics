module RubyScientistAndGraphics
  class Stats
    def initialize(df)
      @df = df
    end

    def describe
      @df.vectors.each do |col|
        col_data = @df[col]
        next unless col_data.type == :numeric

        data = col_data.to_a.compact.map(&:to_f)
        next if data.empty?

        mean = data.sum / data.size
        min = data.min
        max = data.max
        puts "#{col}: Media=#{mean.round(2)}, Min=#{min}, Max=#{max}"
      end
    end

    def correlation(col1, col2)
      x = @df[col1].to_a.compact.map(&:to_f)
      y = @df[col2].to_a.compact.map(&:to_f)
      n = [x.size, y.size].min
      x = x.first(n)
      y = y.first(n)
      return 0.0 if n == 0

      mean_x = x.sum / n
      mean_y = y.sum / n
      num = 0.0
      den_x = 0.0
      den_y = 0.0
      n.times do |i|
        dx = x[i] - mean_x
        dy = y[i] - mean_y
        num += dx * dy
        den_x += dx * dx
        den_y += dy * dy
      end
      den = Math.sqrt(den_x * den_y)
      return 0.0 if den.zero?

      num / den
    end
  end
end
