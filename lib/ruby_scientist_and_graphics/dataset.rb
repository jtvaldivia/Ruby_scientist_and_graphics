module RubyScientistAndGraphics
  require "csv"
  require_relative "dataframe"
  class Dataset
    attr_accessor :df

    def initialize(dataframe, options = {})
      @df = dataframe
      apply_options(options)
    end

    # Aplicar configuraciones iniciales
    def apply_options(options)
      remove_columns(options[:remove_columns]) if options[:remove_columns]
      limit_rows(options[:limit]) if options[:limit]
    end

    # Eliminar columnas
    def remove_columns(columns)
      columns.each { |col| @df.delete_vector(col) if @df.vectors.include?(col) }
      self
    end

    # Agregar nueva columna
    def add_column(name, values)
      @df[name] = values
      self
    end

    # Limitar cantidad de filas
    def limit_rows(n)
      @df = DataFrame.rows(@df.to_a.first(n), order: @df.vectors.to_a)
      self
    end

    # Reemplazar valores nulos
    def fill_missing(value)
      @df = @df.map_vectors { |vector| vector.map { |v| v.nil? ? value : v } }
      self
    end

    # Mostrar primeras filas
    def head(n = 5)
      @df.head(n)
    end

    # Acceso rápido a estadísticas
    def stats
      Stats.new(@df)
    end

    # Acceso rápido a gráficos
    def plot
      Plotter.new(@df)
    end
  end
end
