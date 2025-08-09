# Optional backend adapter using Rover::DataFrame
# Requires the 'rover-df' gem when activated via use_backend(:rover)

module RubyScientistAndGraphics
  module Backends
    class RoverAdapter
      # Constructors
      def self.from_csv(path)
        require "rover"
        ::Rover::DataFrame.read_csv(path)
      end

      def self.rows(rows, order: [])
        require "rover"
        data = order.map.with_index { |k, i| [k.to_sym, rows.map { |r| r[i] }] }.to_h
        ::Rover::DataFrame.new(data)
      end

      def initialize(df)
        @df = df
      end

      # Align with internal DataFrame API used in the gem
      def vectors
        Vectors.new(@df.keys.map(&:to_sym))
      end

      class Vectors
        def initialize(keys)
          @keys = keys
        end

        def to_a = @keys
        def include?(key) = @keys.include?(key)
        def each(&block) = @keys.each(&block)
      end

      class Column
        def initialize(values)
          @values = values
        end

        def to_a = @values.dup
        def [](idx) = @values.[](idx)

        def type
          all_numeric = @values.compact.all? { |v| v.is_a?(Numeric) }
          all_numeric ? :numeric : :object
        end

        def map(&block) = @values.map(&block)
      end

      def [](col)
        Column.new(@df[col.to_s] || @df[col.to_sym] || [])
      end

      def []=(name, values)
        name = name.to_s
        @df[name] = values
      end

      def delete_vector(col)
        name = col.to_s
        @df.delete(name)
      end

      def to_a
        keys = vectors.to_a
        (0...size).map do |i|
          keys.map { |k| (@df[k.to_s] || @df[k.to_sym])[i] }
        end
      end

      def size
        @df.size
      end

      def head(n = 5)
        RoverAdapter.new(@df.head(n))
      end

      def write_csv(path)
        @df.to_csv(path)
      end

      def map_vectors
        result = {}
        vectors.to_a.each do |k|
          mapped = yield Column.new(@df[k.to_s] || @df[k.to_sym])
          result[k.to_sym] = mapped.is_a?(Column) ? mapped.to_a : Array(mapped)
        end
        self.class.new(::Rover::DataFrame.new(result))
      end

      def filter_rows(&block)
        kept = to_a.select(&block)
        self.class.rows(kept, order: vectors.to_a)
      end
    end
  end
end
