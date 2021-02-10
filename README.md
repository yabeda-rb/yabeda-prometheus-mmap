<a href="https://amplifr.com/?utm_source=yabeda-prometheus-mmap">
  <img width="100" height="140" align="right"
    alt="Sponsored by Amplifr" src="https://amplifr-direct.s3-eu-west-1.amazonaws.com/social_images/image/37b580d9-3668-4005-8d5a-137de3a3e77c.png" />
</a>

# Yabeda::[Prometheus]::Mmap


Adapter for easy exporting your collected metrics from your application to the [Prometheus]!
It is based on [Prometheus Ruby Mmap Client](https://gitlab.com/gitlab-org/prometheus-client-mmap), that uses mmap'ed files to share metrics from multiple processes.
This allows efficient metrics processing for Ruby web apps running in multiprocess setups like Unicorn or Puma (clustered mode).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yabeda-prometheus-mmap'
```

And then execute:

    $ bundle

## Usage

 1. Exporting from running web servers:

    Place following in your `config.ru` _before_ running your application:

    ```ruby
    require 'yabeda/prometheus/mmap'

    use Yabeda::Prometheus::Exporter
    ```

    Metrics will be available on `/metrics` path (configured by `:path` option).

    Also you can mount it in Rails application routes as standalone Rack application.

 2. Run web-server from long-running processes (delayed jobs, …):

    ```ruby
    require 'yabeda/prometheus/mmap'

    Yabeda::Prometheus::Exporter.start_metrics_server!
    ```

    WEBrick will be launched in separate thread and will serve metrics on `/metrics` path.

    See [yabeda-sidekiq] for example.

    Listening address is configured via `PROMETHEUS_EXPORTER_BIND` env variable (default is `0.0.0.0`).

    Port is configured by `PROMETHEUS_EXPORTER_PORT` or `PORT` variables (default is `9394`).


## Development with Docker

Get local development environment working and tests running is very easy with docker-compose:
```bash
docker-compose run app bundle
docker-compose run app bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yabeda-rb/yabeda-prometheus-mmap.

### Releasing

1. Bump version number in `lib/yabeda/prometheus/mmap/version.rb`

   In case of pre-releases keep in mind [rubygems/rubygems#3086](https://github.com/rubygems/rubygems/issues/3086) and check version with command like `Gem::Version.new(Yabeda::Prometheus::Mmap::VERSION).to_s`

2. Fill `CHANGELOG.md` with missing changes, add header with version and date.

3. Make a commit:

   ```sh
   git add lib/yabeda/prometheus/mmap/version.rb CHANGELOG.md
   version=$(ruby -r ./lib/yabeda/prometheus/mmap/version.rb -e "puts Gem::Version.new(Yabeda::Prometheus::Mmap::VERSION)")
   git commit --message="${version}: " --edit
   ```

4. Create annotated tag:

   ```sh
   git tag v${version} --annotate --message="${version}: " --edit --sign
   ```

5. Fill version name into subject line and (optionally) some description (list of changes will be taken from changelog and appended automatically)

6. Push it:

   ```sh
   git push --follow-tags
   ```

7. GitHub Actions will create a new release, build and push gem into RubyGems! You're done!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[Prometheus]: https://prometheus.io/ "Open-source monitoring solution"
[yabeda-sidekiq]: https://github.com/yabeda-rb/yabeda-sidekiq

