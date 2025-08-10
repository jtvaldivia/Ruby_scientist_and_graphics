# frozen_string_literal: true

require_relative "lib/ruby_scientist_and_graphics/version"

Gem::Specification.new do |spec|
  spec.name = "ruby_scientist_and_graphics"
  spec.version = RubyScientistAndGraphics::VERSION
  spec.authors = ["jtvaldivia"]
  spec.email = ["josevaldivia9@gmail.com"]

  spec.summary       = "Suite de Data Science para Ruby: limpieza, análisis y visualización de datos en una sola gema."
  spec.description   = <<~DESC
      RubyScience es una gema que integra utilidades prácticas para ciencia de datos en Ruby.
    Incluye un DataFrame minimal propio para manipulación y limpieza de datos y Gruff para visualización,
      todo bajo una API unificada y personalizable.

      Características principales:
      - Carga de datos desde CSV y otros formatos.
      - Limpieza y transformación de datos (eliminar columnas, manejar valores nulos, limitar filas).
      - Estadísticas descriptivas y correlaciones rápidas.
      - Creación de gráficos de barras y líneas con opciones personalizables.
      - API sencilla inspirada en pandas de Python, pero adaptada al estilo Ruby.

      Ideal para analistas, científicos de datos y desarrolladores Ruby que necesiten explorar datos
      sin depender de entornos como Python o R.
  DESC

  spec.homepage = "https://github.com/jtvaldivia/Ruby_scientist_and_graphics"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.add_dependency "csv"
  spec.add_dependency "gruff"
  # matrix is no longer required as we removed statsample

  # spec.metadata["allowed_push_host"] is only needed for private gem servers
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jtvaldivia/Ruby_scientist_and_graphics"
  spec.metadata["changelog_uri"] = "https://github.com/jtvaldivia/Ruby_scientist_and_graphics/blob/master/CHANGELOG.md"

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
