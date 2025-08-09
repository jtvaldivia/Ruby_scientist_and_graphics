# lib/ruby_scientist_and_graphics/io.rb
require "json"
require "csv"

module RubyScientistAndGraphics
  module IO
    module_function

    require_relative "dataframe"

    # Cargar CSV
    def load_csv(path)
      DataFrame.from_csv(path)
    end

    # Cargar JSON
    def load_json(path)
      data = JSON.parse(File.read(path))
      DataFrame.new(data)
    end

    # Exportar a CSV
    def save_csv(df, path)
      df.write_csv(path)
      puts "Datos exportados a #{path}"
    end

    # Exportar a JSON
    def save_json(df, path)
      File.write(path, df.to_a.to_json)
      puts "Datos exportados a #{path}"
    end

    # Guardar proyecto (estructura completa)
    def save_project(df, path)
      File.write(path, {
        columns: df.vectors.to_a,
        data: df.to_a
      }.to_json)
      puts "Proyecto guardado en #{path}"
    end

    # Cargar proyecto
    def load_project(path)
      proj = JSON.parse(File.read(path))
      DataFrame.rows(proj["data"], order: proj["columns"].map(&:to_sym))
    end
  end
end
