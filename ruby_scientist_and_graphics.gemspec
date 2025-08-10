# frozen_string_literal: true

require_relative "lib/ruby_scientist_and_graphics/version"

Gem::Specification.new do |spec|
  spec.name = "ruby_scientist_and_graphics"
  spec.version = RubyScientistAndGraphics::VERSION
  spec.authors = ["jtvaldivia"]
  spec.email = ["josevaldivia9@gmail.com"]

  spec.summary       = "Ruby data science toolkit: lightweight DataFrame, cleaning, stats, plotting, simple ML, and project save/load."
  spec.description   = <<~DESC
    Ruby Scientist and Graphics is a practical data science toolkit for Ruby.
    It includes a lightweight built-in DataFrame for loading, cleaning, and transforming data; quick
    descriptive statistics and correlations; charting via Gruff (bar and line); and simple ML utilities
    (linear regression and k-means)—all behind a small, unified, pandas-inspired API.

    Key features:
    - Load data from CSV and JSON.
    - Clean and transform (remove/add columns, handle missing values, limit rows).
    - Describe datasets and compute correlations quickly.
    - Create bar and line charts with customization options.
    - Train/predict with linear regression; cluster with k-means.
    - Save/load project state (data + trained model) and run simple pipelines.
    - Optional backend adapters (e.g., Rover) while keeping the same API.

    Ideal for analysts and developers who want to explore data in Ruby without relying on Python or R.
    Note: plotting via Gruff uses rmagick, which requires ImageMagick installed on the system.
  DESC

  spec.homepage = "https://github.com/jtvaldivia/Ruby_scientist_and_graphics"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  # Runtime dependencies
  spec.add_dependency "csv", "~> 3.3"
  spec.add_dependency "gruff", "~> 0.29"

  # Development/test dependencies
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  # matrix is no longer required as we removed statsample

  # spec.metadata["allowed_push_host"] is only needed for private gem servers
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jtvaldivia/Ruby_scientist_and_graphics"
  spec.metadata["changelog_uri"] = "https://github.com/jtvaldivia/Ruby_scientist_and_graphics/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://github.com/jtvaldivia/Ruby_scientist_and_graphics#readme"
  spec.metadata["bug_tracker_uri"] = "https://github.com/jtvaldivia/Ruby_scientist_and_graphics/issues"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
