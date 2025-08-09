# lib/ruby_scientist_and_graphics/ml.rb
module RubyScientistAndGraphics
  class ML
    def initialize(df)
      @df = df
    end

    # Entrenar un modelo de regresión lineal (mínimos cuadrados)
    def linear_regression(features:, target:)
      x = build_matrix(features)
      y = @df[target].to_a.map(&:to_f)
      # añadir bias (columna de 1s)
      x_bias = x.map { |row| [1.0] + row }
      xt = transpose(x_bias)
      xtx = mat_mul(xt, x_bias)
      xty = mat_vec_mul(xt, y)
      w = solve_sym_posdef(xtx, xty) # vector de pesos
      LinearRegressionModel.new(w)
    end

    # Entrenar K-Means (Lloyd)
    def kmeans(features:, clusters: 3, max_iter: 100)
      data = build_matrix(features)
      model = KMeansModel.new(clusters)
      model.fit(data, max_iter: max_iter)
      model
    end

    private

    def build_matrix(features)
      feats = Array(features)
      cols = feats.map { |f| @df[f].to_a.map(&:to_f) }
      rows = @df.size
      (0...rows).map { |i| cols.map { |c| c[i] } }
    end

    def transpose(m)
      return [] if m.empty?

      (0...m.first.size).map { |j| m.map { |row| row[j] } }
    end

    def mat_mul(a, b)
      bt = transpose(b)
      a.map { |row| bt.map { |col| dot(row, col) } }
    end

    def mat_vec_mul(a, v)
      a.map { |row| dot(row, v) }
    end

    def dot(x, y)
      x.each_index.reduce(0.0) { |s, i| s + x[i] * y[i] }
    end

    # Resolver (A w = b) para A simétrica definida positiva (Cholesky)
    def solve_sym_posdef(a, b)
      l = cholesky(a)
      # forward substitution: L y = b
      y = Array.new(b.size, 0.0)
      (0...l.size).each do |i|
        sum = 0.0
        (0...i).each { |k| sum += l[i][k] * y[k] }
        y[i] = (b[i] - sum) / l[i][i]
      end
      # backward substitution: L^T w = y
      n = l.size
      w = Array.new(n, 0.0)
      (n - 1).downto(0) do |i|
        sum = 0.0
        (i + 1...n).each { |k| sum += l[k][i] * w[k] }
        w[i] = (y[i] - sum) / l[i][i]
      end
      w
    end

    def cholesky(a)
      n = a.size
      l = Array.new(n) { Array.new(n, 0.0) }
      n.times do |i|
        (0..i).each do |j|
          sum = 0.0
          (0...j).each { |k| sum += l[i][k] * l[j][k] }
          if i == j
            val = a[i][i] - sum
            l[i][j] = val > 0 ? Math.sqrt(val) : 0.0
          else
            l[i][j] = (a[i][j] - sum) / (l[j][j].zero? ? 1.0 : l[j][j])
          end
        end
      end
      l
    end
  end

  class LinearRegressionModel
    def initialize(weights)
      @weights = weights # [bias, w1, w2, ...]
    end

    def predict(x)
      mat = x.map { |row| [1.0] + row.map(&:to_f) }
      mat.map { |row| row.each_index.reduce(0.0) { |s, i| s + row[i] * @weights[i] } }
    end
  end

  class KMeansModel
    attr_reader :n_clusters

    def initialize(k)
      @n_clusters = k
      @centroids = []
    end

    def fit(data, max_iter: 100)
      k = @n_clusters
      # init: pick first k points (simple, deterministic for tests)
      @centroids = data.first(k).map(&:dup)
      max_iter.times do
        clusters = Array.new(k) { [] }
        data.each do |point|
          idx = nearest_centroid(point)
          clusters[idx] << point
        end
        new_centroids = clusters.map do |pts|
          if pts.empty?
            @centroids.sample || Array.new(data.first.size, 0.0)
          else
            mean_point(pts)
          end
        end
        break if converged?(@centroids, new_centroids)

        @centroids = new_centroids
      end
      self
    end

    def predict(data)
      data.map { |point| nearest_centroid(point) }
    end

    private

    def mean_point(points)
      dims = points.first.size
      sums = Array.new(dims, 0.0)
      points.each { |p| p.each_index { |i| sums[i] += p[i].to_f } }
      sums.map { |s| s / points.size }
    end

    def nearest_centroid(point)
      dists = @centroids.map { |c| squared_distance(c, point) }
      dists.each_with_index.min.last
    end

    def squared_distance(a, b)
      a.each_index.reduce(0.0) { |s, i| s + (a[i].to_f - b[i].to_f)**2 }
    end

    def converged?(a, b)
      a.each_with_index.all? do |cent, i|
        cent.each_index.all? { |j| (cent[j] - b[i][j]).abs < 1e-9 }
      end
    end
  end
end
