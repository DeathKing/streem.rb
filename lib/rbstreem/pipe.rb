require 'securerandom'

# Pipe in streem.rb always be single direction!
module RbStreem

  class Pipe

    # Find a specific pipe
    def self.find_by_name(name)
      ObjectSpace.each_object(self).find {|obj| obj.name == name}
    end

    def self.generate_pipe_name
      "pipe-#{SecureRandom.base64(6)}"
    end

    attr_reader :name
    attr_reader :producer, :customer

    attr_accessor :flow_tag

    def initialize(src, dest, flow_tag)
      @name = self.class.generate_pipe_name
      @queue = []
      @producer = src
      @customer = dest
      @flow_tag = flow_tag
      @producer.add_write_pipe(self)
      @customer.add_read_pipe(self)
    end

    def broken?
      @customer.nil? || ((@producer.nil? || @producer.dead?) && empty?)
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

  end

end
