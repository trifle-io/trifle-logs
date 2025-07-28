# Trifle::Logs

[![Gem Version](https://badge.fury.io/rb/trifle-logs.svg)](https://rubygems.org/gems/trifle-logs)
[![Ruby](https://github.com/trifle-io/trifle-logs/workflows/Ruby/badge.svg?branch=main)](https://github.com/trifle-io/trifle-logs)

Simple log storage where you can dump your data. It allows you to search on top of your log files with `ripgrep` for fast regexp queries and utilises `head` and `tail` to paginate through a file.

## Documentation

For comprehensive guides, API reference, and examples, visit [trifle.io/trifle-logs](https://trifle.io/trifle-logs)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trifle-logs'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install trifle-logs
```

## Quick Start

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
Trifle::Logs.dump('test', 'This is test message')
Trifle::Logs.dump('test', 'Or another message')
Trifle::Logs.dump('test', 'That someone cares about')
```

### 3. Search logs

```ruby
search = Trifle::Logs.searcher('test', pattern: 'test')
result = search.perform
result.data
#=> [
#     {
#       "type"=>"match",
#       "data"=>{
#         "path"=>{"text"=>"<stdin>"},
#         "lines"=>{"text"=>"2022-09-17T08:33:04.843195 {\"scope\":{},\"content\":\"This is test message\"}\n"},
#         "line_number"=>1,
#         "absolute_offset"=>0,
#         "submatches"=>[{"match"=>{"text"=>"test"}, "start"=>58, "end"=>62}]
#       }
#     }
#   ]
```

## Features

- **File-based storage** - Simple, reliable log storage
- **Fast search** - Uses ripgrep for high-performance regex searches
- **Flexible formatting** - JSON, text, and custom formatters
- **Pagination support** - Efficient log browsing with head/tail
- **Structured logging** - Scope and metadata support
- **Production ready** - Handles log rotation and large files

## Drivers

Currently supports:

- **File** - Local file system storage with rotation support

## Formatters

- **JSON** - Structured JSON output with timestamps
- **Text** - Plain text formatting for human readability
- **Timestamp** - Adds automatic timestamping to all entries

## Testing

Tests verify log storage, search functionality, and formatter behavior. To run the test suite:

```bash
$ bundle exec rspec
```

Ensure `ripgrep` is installed locally for search functionality tests.

Tests are meant to be **simple and isolated**. Every test should be **independent** and able to run in any order. Tests should be **self-contained** and set up their own configuration.

Use **single layer testing** to focus on testing a specific class or module in isolation. Use **appropriate stubbing** for file system operations when testing drivers and formatters.

**Repeat yourself** in test setup for clarity rather than complex shared setups that can hide dependencies.

Tests verify that logs are properly written, search operations return expected results, and formatters produce correct output. File system tests use temporary directories to avoid conflicts.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trifle-io/trifle-logs.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
