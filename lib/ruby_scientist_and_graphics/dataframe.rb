module RubyScientistAndGraphics
  # Minimal DataFrame to cover the API used by this gem's code and tests
  class DataFrame
    # Helper wrapper that mimics Daru's vectors
    class Vectors
      def initialize(keys)
        @keys = keys
      end

      def to_a
        @keys
      end

      def include?(key)
        @keys.include?(key)
      end

      def each(&block)
        @keys.each(&block)
      end
    end

    # Column wrapper with minimal API
    class Column
      def initialize(values)
        @values = values
      end

      def to_a
        @values.dup
      end

      def [](idx)
        @values[idx]
      end

      # Simple type inference
      def type
        all_numeric = @values.compact.all? { |v| v.is_a?(Numeric) }
        all_numeric ? :numeric : :object
      end

      def map(&block)
        @values.map(&block)
      end
    end

    # Constructors
    def self.from_csv(path)
      require "csv"
      rows = []
      headers = nil
      CSV.foreach(path, headers: true, header_converters: ->(h) { h&.strip&.downcase&.to_sym }) do |row|
        headers ||= row.headers.map(&:to_sym)
        rows << headers.map { |h| coerce_value(row[h]) }
      end
      DataFrame.rows(rows, order: headers || [])
    end

    # Accept array of hashes (keys as symbols/strings) or hash of arrays
    def initialize(data)
      @columns = {}
      case data
      when Array
        if data.first.is_a?(Hash)
          keys = data.map(&:keys).flatten.uniq.map { |k| k.to_sym }
          keys.each { |k| @columns[k] = [] }
          data.each do |row|
            keys.each { |k| @columns[k] << (row.key?(k) ? row[k] : row[k.to_s]) }
          end
        elsif data.first.is_a?(Array)
          # Assume first row is header
          headers = (data.first || []).map { |h| h.to_sym }
          body = data[1..] || []
          @columns = headers.map.with_index { |h, i| [h, body.map { |r| r[i] }] }.to_h
        else
          # Single array -> make an index column
          @columns[:value] = data
        end
      when Hash
        data.each { |k, v| @columns[k.to_sym] = v.dup }
      else
        raise ArgumentError, "Unsupported data type for DataFrame"
      end
      normalize_column_lengths!
    end

    # Build from rows (array of arrays) and a column order
    def self.rows(rows, order: [])
      cols = order.map { |k| [k.to_sym, []] }.to_h
      rows.each do |r|
        order.each_with_index do |k, i|
          cols[k.to_sym] << r[i]
        end
      end
      new(cols)
    end

    # Basic accessors
    def vectors
      Vectors.new(@columns.keys)
    end

    def [](col)
      Column.new(@columns[col.to_sym] || [])
    end

    def []=(name, values)
      name = name.to_sym
      # Resize to match current rows; pad with nils if needed
      if values.nil?
        @columns[name] = Array.new(size, nil)
      else
        values = values.dup
        if values.size < size
          values += Array.new(size - values.size, nil)
        elsif values.size > size
          grow_to(values.size)
        end
        @columns[name] = values
      end
    end

    def delete_vector(col)
      @columns.delete(col.to_sym)
    end

    def to_a
      order = vectors.to_a
      (0...size).map do |i|
        order.map { |k| @columns[k][i] }
      end
    end

    def size
      @columns.values.map(&:size).max || 0
    end

    def head(n = 5)
      DataFrame.rows(to_a.first(n), order: vectors.to_a)
    end

    def write_csv(path)
      require "csv"
      order = vectors.to_a
      CSV.open(path, "w") do |csv|
        csv << order
        to_a.each { |row| csv << row }
      end
    end

    # Map each column (vector) and return a new DataFrame with resulting arrays
    def map_vectors
      result = {}
      @columns.each do |k, arr|
        mapped = yield Column.new(arr)
        result[k] = mapped.is_a?(Column) ? mapped.to_a : Array(mapped)
      end
      DataFrame.new(result)
    end

    # Filter rows by a predicate block that receives an Array of row values
    def filter_rows(&block)
      kept = to_a.select(&block)
      DataFrame.rows(kept, order: vectors.to_a)
    end

    # Pretty print as a simple table (headers + rows)
    def to_s
      headers = vectors.to_a.map(&:to_s)
      lines = []
      lines << headers.join("\t")
      to_a.each do |row|
        cells = row.map { |v| v.nil? ? "" : v }
        lines << cells.join("\t")
      end
      lines.join("\n")
    end

    # Compact inspect showing shape
    def inspect
      "#<#{self.class} rows=#{size} cols=#{vectors.to_a.size}>"
    end

    private

    def grow_to(n)
      @columns.each do |k, arr|
        @columns[k] = arr + Array.new(n - arr.size, nil) if arr.size < n
      end
    end

    def normalize_column_lengths!
      max_len = size
      grow_to(max_len)
    end

    class << self
      private

      def coerce_value(v)
        return nil if v.nil? || v == ""

        # Try numeric
        if v.is_a?(String)
          if v =~ /^-?\d+$/
            return v.to_i
          elsif v =~ /^-?\d*\.\d+$/
            return v.to_f
          end
        end
        v
      end
    end
  end
end
