require_relative "ml"
require_relative "io"
require_relative "utils"
# Crear interfaz y ejecutar todo en una sola línea
module RubyScientistAndGraphics
  class Interface
    attr_reader :dataset, :model

    def initialize
      @dataset = nil
    end

    # 1. Cargar datos
    def load(path, options = {})
      @dataset = Dataset.new(DataFrame.from_csv(path), options)
      self
    end

    # 2. Limpiar datos
    def clean(missing: nil, remove_columns: nil, limit: nil)
      return self unless @dataset

      @dataset.fill_missing(missing) if missing
      @dataset.remove_columns(remove_columns) if remove_columns
      @dataset.limit_rows(limit) if limit
      self
    end

    # 3. Analizar datos
    def analyze
      return self unless @dataset

      @dataset.stats.describe
      self
    end

    # 4. Graficar
    def graph(x:, y:, type: :bar, file: "output.png")
      return self unless @dataset

      case type
      when :bar
        @dataset.plot.bar(x: x, y: y, file: file)
      when :line
        @dataset.plot.line(x: x, y: y, file: file)
      else
        puts "Tipo de gráfico no soportado."
      end
      self
    end

    # 5. Flujo completo
    def pipeline(path:, clean_opts: {}, analysis: true, graph_opts: nil)
      load(path)
      clean(**clean_opts)
      analyze if analysis
      graph(**graph_opts) if graph_opts
    end

    # 6. Entrenar modelos ML sencillos
    # type: :linear_regression o :kmeans
    # Para :linear_regression requiere target
    def train_model(type:, features:, target: nil, clusters: 3)
      return nil unless @dataset

      ml = ML.new(@dataset.df)
      case type
      when :linear_regression
        raise ArgumentError, "target requerido para linear_regression" unless target

        @model = ml.linear_regression(features: features, target: target)
      when :kmeans
        @model = ml.kmeans(features: features, clusters: clusters)
      else
        raise ArgumentError, "Tipo de modelo no soportado"
      end
      @model
    end

    # 7b. Cargar un proyecto y setear el dataset
    def load_project(path)
      df = IO.load_project(path)
      @dataset = Dataset.new(df)
      self
    end

    # 8. Predecir con el modelo actual
    # data: matriz (Array<Array<Numeric>>) con filas de features
    def predict(data)
      raise "No model trained" unless @model

      @model.predict(data)
    end

    # 7. Guardar proyecto (df actual a JSON estructurado)
    def save_project(path)
      return unless @dataset

      IO.save_project(@dataset.df, path)
    end
  end
end
