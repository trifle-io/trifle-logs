# frozen_string_literal: true

require 'open3'

module Trifle
  module Logs
    module Driver
      class File
        attr_accessor :path, :pattern, :read_size

        def initialize(path:, pattern: '%Y/%m_%d')
          @path = path
          @pattern = pattern
          @files = {}
          @read_size = 3 # 1000
        end

        def filename_for(namespace:)
          "#{path}/#{namespace}/#{Time.now.strftime(pattern)}.log"
        end

        def logfile_for(namespace:)
          @files[namespace] = begin
            filename = filename_for(namespace: namespace)
            FileUtils.mkdir_p(::File.dirname(filename))
            ::File.new(
              filename_for(namespace: namespace), 'a', encoding: 'utf-8'
            )
          end
        end

        def dump(message, namespace:)
          file = logfile_for(namespace: namespace)
          file.write("#{message}\n")
          file.flush
          true
        end

        def search(namespace:, queries:, file_loc: nil, direction: nil)
          files = files_for(namespace: namespace)

          send("search_#{direction}_in_file", files, file_loc, queries)
        end

        def search__in_file(files, file_loc, queries)
          file, _line, length = file_for(files, file_loc: file_loc)

          min_line = [length - read_size, 1].max
          max_line = length

          Trifle::Logs::Result.new(
            read(file, min_line, max_line, queries),
            min_loc: "#{file}##{min_line}", max_loc: "#{file}##{max_line}"
          )
        end

        def search_next_in_file(files, file_loc, queries) # rubocop:disable Metrics/MethodLength
          file, line, length = file_for(files, file_loc: file_loc)
          if line == length
            cfile, cline, clength = next_file_for(files, file) if line == length
            return Trifle::Logs::Result.new(nil, max_loc: "#{file}##{line}") if cfile.nil?

            file, line, length = cfile, cline, clength # rubocop:disable Style/ParallelAssignment
          end

          max_line = [line + read_size, length].min

          Trifle::Logs::Result.new(
            read(file, line, max_line, queries),
            max_loc: "#{file}##{max_line}"
          )
        end

        def search_prev_in_file(files, file_loc, queries) # rubocop:disable Metrics/MethodLength
          file, line, _length = file_for(files, file_loc: file_loc)
          if line.zero?
            cfile, cline, clength = prev_file_for(files, file)
            return Trifle::Logs::Result.new(nil, min_loc: "#{file}##{line}") if cfile.nil?

            file, line, _length = cfile, cline, clength # rubocop:disable Style/ParallelAssignment
          end

          min_line = [line - read_size, 1].max

          Trifle::Logs::Result.new(
            read(file, min_line, line, queries),
            min_loc: "#{file}##{min_line}"
          )
        end

        def read(file, from, to, queries)
          # sed -n '2,4p;5q' test/lolz/2022/09_06.log | rg '.*' --json
          # head -4 test/lolz/2022/09_06.log | tail +2 | rg '.*' --json
          cmd = "sed -n '#{from},#{to}p;#{to + 1}q' #{file} | rg '#{queries.first || '.*'}' --json"
          _stdin, stdout, _stderr = Open3.popen3(cmd)
          stdout.map { |l| JSON.parse(l) }
        end

        def prev_file_for(files, file)
          idx = files.index(file)
          return [nil, nil, nil] if idx.zero? # prev file doesnt exist

          file = files[idx - 1]
          [file, length_of(file), length_of(file)]
        end

        def next_file_for(files, file)
          idx = files.index(file)
          return [nil, nil, nil] if idx == files.length - 1 # next file doesnt exist

          file = files[idx + 1]
          [file, 1, length_of(file)]
        end

        def file_for(files, file_loc: nil)
          latest = files.last
          return [latest, length_of(latest), length_of(latest)] unless file_loc

          file, line = file_loc.split('#')
          return [latest, length_of(latest), length_of(latest)] unless files.include?(file)

          [file, line.to_i, length_of(latest)]
        end

        def files_for(namespace:)
          Dir.glob("#{path}/#{namespace}/**/*.log").sort
        end

        def length_of(file)
          `wc -l #{file}`.split.first.to_i
        end
      end
    end
  end
end
