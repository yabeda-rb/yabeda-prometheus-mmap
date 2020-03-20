# frozen_string_literal: true

require 'prometheus/client'
require 'rack'
require 'prometheus/client/rack/collector'
require 'prometheus/client/rack/exporter'
require 'yabeda/base_adapter'

module Yabeda
  module Prometheus
    module Mmap
      # Prometheus metrics collecion adapter
      class Adapter < BaseAdapter
        def registry
          @registry ||= ::Yabeda::Prometheus::Mmap.registry
        end

        def register_counter!(metric)
          validate_metric!(metric)

          registry.counter(
            build_name(metric),
            metric.comment,
            build_tags(metric.tags)
          )
        end

        def perform_counter_increment!(metric, tags, value)
          registry.get(build_name(metric)).increment(tags, value)
        end

        def register_gauge!(metric)
          validate_metric!(metric)

          registry.gauge(
            build_name(metric),
            metric.comment,
            build_tags(metric.tags)
          )
        end

        def perform_gauge_set!(metric, tags, value)
          registry.get(build_name(metric)).set(tags, value)
        end

        def register_histogram!(metric)
          buckets = metric.buckets ||
                    ::Prometheus::Client::Histogram::DEFAULT_BUCKETS

          registry.histogram(
            build_name(metric),
            metric.comment,
            build_tags(metric.tags),
            buckets
          )
        end

        def perform_histogram_measure!(metric, tags, value)
          registry.get(build_name(metric)).observe(tags, value)
        end

        def build_name(metric)
          [metric.group, metric.name, metric.unit].compact.join('_').to_sym
        end

        def build_tags(tags)
          Array(tags).each_with_object({}) do |tag, hash|
            hash[tag] = nil
          end
        end

        def validate_metric!(metric)
          return if metric.comment

          raise ArgumentError, 'Prometheus require metrics to have comments'
        end

        Yabeda.register_adapter(:'prometheus-mmap', new)
      end
    end
  end
end
