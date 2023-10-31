#Alex Porokhin
#113423484
#!/usr/bin/env ruby

class RGrep
    VALID_OPTIONS = %w[-w -p -v -c -m].freeze

    def initialize(filename, options, pattern)
        @pattern = pattern
        @filename = filename
        @options = options
        @line_count = 0
        @matches = []
    end

    def run
        validate_args
        read_and_process_file
        output_results
        rescue StandardError => e
            puts e.message
        end

    private

    def validate_args
        raise "Missing required arguments" if @filename.nil? || @pattern.nil?
        raise "Invalid option" if (@options.keys - VALID_OPTIONS).any?
        raise "Invalid combination of options" unless valid_option_combination?
    end

    def read_and_process_file
        File.foreach(@filename) do |line|
            process_line(line.chomp)
        end
    end

    def process_line(line)
        pattern_regexp = build_pattern_regexp
        if @options['-v']
            unless line.match(pattern_regexp)
                @line_count += 1
                @matches << line
            end
        else
            match_data = line.match(pattern_regexp)
            if match_data
                @line_count += 1
                @matches << (@options['-m'] ? match_data.to_s : line)
            end
        end
    end

    def build_pattern_regexp
        pat = if @options['-w']
                "\\b#{@pattern}\\b"
            else
                @pattern
            end
        Regexp.new(pat)
    end

    def valid_option_combination?
        return false if @options['-m'] && @options['-v']
        if @options['-c']
            return (@options.key?('-w') || @options.key?('-p') || @options.key?('-v'))
        end

         if @options['-m']
            return (@options.key?('-w') || @options.key?('-p'))
        end

        true
    end

    def output_results
        if @options['-c']
            puts @line_count
        else
            puts @matches
        end
    end
end

def parse_arguments(valid_options)
    pattern = nil
    options = {}
    filename = ARGV.shift

    ARGV.each do |arg|
        if arg.start_with?('-')
            raise "Invalid option" unless valid_options.include?(arg)
            options[arg] = true
        elsif pattern.nil?
            pattern = arg.delete_prefix("'").delete_suffix("'").delete_prefix('"').delete_suffix('"')
        else
            raise "Error"
        end
    end
    [filename, options, pattern]
end
  

begin
    filename, options, pattern = parse_arguments(RGrep::VALID_OPTIONS)
    rgrep = RGrep.new(filename, options, pattern)
    rgrep.run
    rescue => e
        puts e.message
end
