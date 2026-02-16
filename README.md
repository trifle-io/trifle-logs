# Trifle::Logs

[![Gem Version](https://badge.fury.io/rb/trifle-logs.svg)](https://rubygems.org/gems/trifle-logs)
[![Ruby](https://github.com/trifle-io/trifle-logs/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-logs)

File-based log storage with ripgrep-powered search for Ruby. Dump structured logs to disk, then search them with fast regex queries and paginate with head/tail. No Elasticsearch. No external services.

Part of the [Trifle](https://trifle.io) ecosystem.

## Quick Start

```ruby
gem 'trifle-logs'
```

### 1. Configure

```ruby
require 'trifle/logs'

Trifle::Logs.configure do |config|
  config.driver = Trifle::Logs::Driver::File.new(path: './logs')
  config.formatter = Trifle::Logs::Formatter::Json.new
end
```

### 2. Dump logs

```ruby
Trifle::Logs.dump('orders', 'Order #1234 processed successfully')
Trifle::Logs.dump('orders', 'Payment confirmed for $49.90')
```

### 3. Search

```ruby
result = Trifle::Logs.searcher('orders', pattern: 'Payment').perform
result.data
#=> [{ "type" => "match", "data" => { "lines" => { "text" => "Payment confirmed for $49.90\n" }, ... } }]
```

## Features

- **File-based storage** — Simple, reliable, no external dependencies
- **Fast search** — Uses ripgrep for high-performance regex queries
- **Flexible formatting** — JSON, text, and timestamp formatters
- **Pagination** — Head/tail navigation through log files
- **Structured logging** — Scope and metadata support

## Formatters

- **JSON** — Structured output with timestamps and scope
- **Text** — Plain text for human readability
- **Timestamp** — Automatic timestamping on all entries

## Documentation

Full guides and API reference at **[docs.trifle.io/trifle-logs](https://docs.trifle.io/trifle-logs)**

## Trifle Ecosystem

| Component | What it does |
|-----------|-------------|
| **[Trifle App](https://trifle.io/product-app)** | Dashboards, alerts, scheduled reports, AI-powered chat. |
| **[Trifle::Stats](https://github.com/trifle-io/trifle-stats)** | Time-series metrics for Ruby (Postgres, Redis, MongoDB, MySQL, SQLite). |
| **[Trifle CLI](https://github.com/trifle-io/trifle-cli)** | Terminal access to metrics. MCP server mode for AI agents. |
| **[Trifle::Traces](https://github.com/trifle-io/trifle-traces)** | Structured execution tracing for background jobs. |
| **[Trifle::Docs](https://github.com/trifle-io/trifle-docs)** | Map a folder of Markdown files to documentation URLs. |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trifle-io/trifle-logs.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
