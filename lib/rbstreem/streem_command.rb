module RbStreem
  class StreemCommand

    attr_reader :argv
    attr_reader :script_file
    attr_reader :rest_argument

    @@global = nil

    def self.global
      @@global
    end

    def initialize(argv)
      @argv = argv
      _, @rest_argument = process_argv
      @script_file = nil
      process_argv
      @@global = self unless @@global
    end

    def process_argv
      partion_index = nil

      @argv.each_with_index do |e, i|
        # FIXME: hard-code
        if e.end_with?(".strm.rb") || e.end_with?(".strm")
          partion_index = i + 1
          @script_file = e
        end
      end

      [@argv[0...partion_index], @argv[partion_index..-1]]

    end

    def empty?
      @argv.empty?
    end

  end
end
