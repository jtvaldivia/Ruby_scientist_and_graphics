# RubyScientistAndGraphics

Lightweight data science toolkit for Ruby: load/clean data, get quick stats, plot charts, and train simple ML models — all in one gem and with zero heavy dependencies.

It ships with a minimal in-house DataFrame (no Daru required), Gruff for plotting, and tiny implementations for statistics and ML (linear regression and k-means).

## Features

- Load and save CSV/JSON, plus save/load a simple “project” (columns + rows).
- Data cleaning helpers: remove columns, fill missing values, limit rows.
- Quick stats: per-column mean/min/max and Pearson correlation.
- Plotting: bar and line charts via Gruff.
- ML: linear regression (least squares) and k-means clustering.

## Installation

Clone and use directly, or add to your Gemfile from a git source until published to RubyGems:

```ruby
gem 'ruby_scientist_and_graphics', git: 'https://github.com/your-user/ruby_scientist_and_graphics'
```

Then install:

```bash
bundle install
```

Ruby 3.2+ is recommended.

## Quick start

Run the demo to see the workflow end-to-end:

```bash
ruby demo.rb
```

Or use the API:

```ruby
require_relative 'lib/ruby_scientist_and_graphics'

interface = RubyScientistAndGraphics::Interface.new

# 1) Load and clean
interface.load('test/fixtures/sample.csv', remove_columns: [:comentarios], limit: 5)
interface.clean(missing: 0)

# 2) Stats
interface.analyze

# 3) Plot
interface.graph(type: :bar, x: :mes, y: :ventas, file: 'output.png')

# 4) Train a model
model = interface.train_model(type: :linear_regression, features: [:mes], target: :ventas)
preds = model.predict([[1.0], [2.0], [3.0]])

# 5) Save project
interface.save_project('project.json')

# 6) Load a previously saved project and predict
interface.load_project('project.json')
interface.train_model(type: :linear_regression, features: [:mes], target: :ventas)
preds = interface.predict([[6.0], [7.0]])
```

## API overview

- DataFrame (internal): CSV load, indexing by column symbol, `head`, `write_csv`, `map_vectors`, `filter_rows`.
- IO: `load_csv`, `load_json`, `save_csv`, `save_json`, `save_project`, `load_project`.
- Dataset: `remove_columns`, `add_column`, `limit_rows`, `fill_missing`, `head`, `stats`, `plot`.
- Stats: `describe`, `correlation(col1, col2)`.
- Plotter: `bar(x:, y:, file:)`, `line(x:, y:, file:)`.
- Interface: `load`, `clean`, `analyze`, `graph`, `pipeline`, `train_model`, `save_project`.
- Interface: `load`, `clean`, `analyze`, `graph`, `pipeline`, `train_model`, `save_project`, `load_project`, `predict`.

## Adapters (optional backends)

This gem includes a minimal in-house DataFrame that powers all features. If you want more performance or richer operations (group-by, joins, rolling, etc.), you can plug a third-party backend behind the same API using a simple adapter pattern.

Potential backends:

- Polars (Ruby bindings): very fast, columnar engine written in Rust.
- Rover-Df: pure Ruby DataFrame with a friendly API.

Adapter idea (sketch):

```ruby
module RubyScientistAndGraphics
	module Backends
		class PolarsAdapter
			def self.from_csv(path); end
			def vectors; end
			def [](col); end
			def to_a; end
			# implement methods used by Dataset/Stats/Plotter
		end
	end
end

# Then inject at app start:
# RubyScientistAndGraphics::DataFrame = RubyScientistAndGraphics::Backends::PolarsAdapter
```

This keeps your app code unchanged while letting you switch engines.

## Development

Setup and tests:

```bash
bin/setup
bundle exec rake test
```

Run an interactive console:

```bash
bin/console
```

Build and install locally:

```bash
bundle exec rake install
```

Release flow: bump version in `lib/ruby_scientist_and_graphics/version.rb`, then:

```bash
bundle exec rake release
```

## Contributing

Pull requests are welcome. Please open an issue to discuss large changes first. See CODE_OF_CONDUCT.md.

## License

MIT License. See LICENSE.txt.
