# frozen_string_literal: true

require_relative 'lib/yabeda/prometheus/mmap/version'

Gem::Specification.new do |spec|
  spec.name          = 'yabeda-prometheus-mmap'
  spec.version       = Yabeda::Prometheus::Mmap::VERSION
  spec.authors       = ['Dmitry Salahutdinov']
  spec.email         = ['dsalahutdinov@gmail.com']

  spec.summary       = 'Extensible Prometheus exporter for your application'
  spec.description   = 'Uses prometheus-client-mmap'
  spec.homepage      = 'https://github.com/yabeda-rb/yabeda-prometheus-mmap'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/yabeda-rb/yabeda-prometheus-mmap'
  spec.metadata['changelog_uri'] = 'https://github.com/yabeda-rb/yabeda-prometheus-mmap/blob/master/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'prometheus-client-mmap'
  spec.add_dependency 'yabeda', '~> 0.5'
end
