# lib/ruby_scientist_and_graphics/utils.rb
module RubyScientistAndGraphics
  module Utils
    module_function

    # Normalizar valores a rango 0-1
    def normalize(array)
      min = array.min.to_f
      max = array.max.to_f
      array.map { |v| (v.to_f - min) / (max - min) }
    end

    # Estandarizar valores (media 0, desviación 1)
    def standardize(array)
      mean = array.sum.to_f / array.size
      stddev = Math.sqrt(array.map { |v| (v.to_f - mean)**2 }.sum / array.size)
      array.map { |v| (v.to_f - mean) / stddev }
    end

    # One-hot encoding para categóricas
    def one_hot_encode(array)
      categories = array.uniq
      array.map { |val| categories.map { |c| val == c ? 1 : 0 } }
    end

    # Eliminar filas con valores nulos
    def drop_na(df)
      df.filter_rows { |row| !row.include?(nil) }
    end
  end
end
