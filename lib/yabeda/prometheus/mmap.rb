# frozen_string_literal: true

require 'yabeda'
require 'prometheus/client'
require 'yabeda/prometheus/mmap/version'
require 'yabeda/prometheus/mmap/adapter'
require 'yabeda/prometheus/exporter'

module Yabeda
  module Prometheus
    # Base module for mmap
    module Mmap
      class << self
        def registry
          ::Prometheus::Client.registry
        end
      end
    end
  end
end
