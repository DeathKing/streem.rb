require 'securerandom'

# Pipe in streem.rb always be single direction!
module RbStreem

  class Pipe

    include Connectable

    class << self
      def find_by_name(name)
        ObjectSpace.each_object(self).find {|obj| obj.name == name}
      end

      def generate_pipe_name
        "pipe-#{SecureRandom.base64(6)}"
      end

      def generate_flow_tag
        "flow-#{SecureRandom.base64(6)}"
      end
    end

    attr_reader :name
    attr_reader :source, :target

    attr_accessor :flow_tag

    def initialize(src, dest, flow_tag=nil)
      @name = self.class.generate_pipe_name
      @queue = []
      @source = src
      @target = dest
      @flow_tag = flow_tag || self.class.generate_flow_tag
      @source.add_write_pipe(self)
      @target.add_read_pipe(self)
    end

    def check_connection_target_type(target)
      fail("target cannot be a pipe!") if target.is_a? Pipe
    end

    def connection_source
      target
    end

    def connection_target
      source
    end

    def be_removed_from_source
      @source = nil
    end

    def be_removed_from_target
      @target = nil
    end

    def broken?
      return true if @broken
      result = target.nil? || (target.nil? && source.nil?) || (source.nil? && empty?)
      @broken = result
    end

    def puts(val)
      @queue << val
      val
    end

    def gets
      @queue.empty? ? fail("Pipe empty!") : @queue.shift
    end

    def head
      @queue.empty? ? nil : @queue.first
    end

    def empty?
      @queue.empty?
    end

    def ready?
      !empty?
    end

    def remove_out
      target && target.remove_read_pipe(self)
      source && source.remove_write_pipe(self)
    end

  end

end
