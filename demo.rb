#!/usr/bin/env ruby
require_relative "lib/ruby_scientist_and_graphics"

puts "=== Demo RubyScientistAndGraphics ==="

interface = RubyScientistAndGraphics::Interface.new

puts "\nCargando dataset..."
interface.load("test/fixtures/sample.csv", remove_columns: [:comentarios], limit: 5)

puts "\nLimpiando datos (rellenar nils con 0)..."
interface.clean(missing: 0)

puts "\nMostrando primeras filas:"
puts interface.dataset.df.head(5)

puts "\nMostrando estadísticas descriptivas:"
interface.analyze

puts "\nGenerando gráfico de barras (ventas vs mes)..."
interface.graph(type: :bar, x: :mes, y: :ventas, file: "test/output_demo.png")

puts "\nEntrenando modelo de regresión lineal (mes -> ventas)..."
model = interface.train_model(type: :linear_regression, features: [:mes], target: :ventas)
puts "Modelo entrenado: #{model.class}"

puts "\nPredicciones con el modelo (mes = 6,7):"
preds = interface.predict([[6.0], [7.0]])
puts "Predicciones: #{preds.inspect}"

puts "\nCorrelación Pearson entre mes y ventas:"
corr = interface.dataset.stats.correlation(:mes, :ventas)
puts "correlación(mes, ventas) = #{corr.round(4)}"

puts "\nGráfico de línea (ventas vs mes)..."
interface.graph(type: :line, x: :mes, y: :ventas, file: "test/output_demo_line.png")

puts "\nEntrenando KMeans con 2 clusters sobre ventas..."
kmeans = interface.train_model(type: :kmeans, features: [:ventas], clusters: 2)
puts "Modelo KMeans con n_clusters = #{kmeans.n_clusters}"

puts "\nGuardando proyecto en 'test/project.json'..."
interface.save_project("test/project.json")

puts "\nCargando proyecto desde 'test/project.json' y mostrando primeras filas:"
interface2 = RubyScientistAndGraphics::Interface.new
interface2.load_project("test/project.json")
puts interface2.dataset.df.head(3)

puts "\nDemo terminado."
