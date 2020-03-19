require "yabeda"
require "prometheus/client"
require "yabeda/prometheus/mmap/version"
require "yabeda/prometheus/mmap/adapter"
require "yabeda/prometheus/mmap/exporter"

module Yabeda
  module Prometheus
    module Mmap
      class << self
        def registry
          ::Prometheus::Client.registry
        end
      end
    end
  end
end
