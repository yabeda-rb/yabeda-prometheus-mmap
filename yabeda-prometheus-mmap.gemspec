require_relative 'lib/yabeda/prometheus/mmap/version'

Gem::Specification.new do |spec|
  spec.name          = "yabeda-prometheus-mmap"
  spec.version       = Yabeda::Prometheus::Mmap::VERSION
  spec.authors       = ["Dmitry Salahutdinov"]
  spec.email         = ["dsalahutdinov@gmail.com"]

  spec.summary       = %q{Extensible Prometheus exporter for your application}
  spec.description   = %q{Uses prometheus-client-mmap}
  spec.homepage      = "https://github.com/yabeda-rb/yabeda-prometheus-mmap"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yabeda-rb/yabeda-prometheus-mmap"
  spec.metadata["changelog_uri"] = "https://github.com/yabeda-rb/yabeda-prometheus-mmap/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "prometheus-client-mmap"
  spec.add_dependency "yabeda", "~> 0.5"
end
