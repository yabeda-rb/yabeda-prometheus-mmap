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
            build_tags(metric.tags),
            gauge_aggregation_mode(metric.aggregation)
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

        def debug!
          Yabeda.configure do
            group :yabeda_prometheus_mmap

            histogram :render_duration,
                      tags: %i[], unit: :seconds,
                      buckets: [0.001, 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
                      comment: 'Time required to render all metrics in Prometheus format'
          end
        end

        private

        def gauge_aggregation_mode(yabeda_mode)
          case yabeda_mode
          when nil, :most_recent # TODO: Switch to most_recent when supported: https://gitlab.com/gitlab-org/ruby/gems/prometheus-client-mmap/-/issues/36
            :all
          when :min, :max, :all, :liveall
            yabeda_mode
          when :sum
            :livesum
          else
            raise ArgumentError, "Unsupported gauge aggregation mode #{yabeda_mode.inspect}"
          end
        end

        Yabeda.register_adapter(:prometheus, new)
      end
    end
  end
end
