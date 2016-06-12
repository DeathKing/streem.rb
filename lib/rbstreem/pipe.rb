require 'securerandom'

# Pipe in streem.rb always be single direction!
module RbStreem

  class Pipe

    # Find a specific pipe
    def self.find_by_name(name)
      ObjectSpace.each_object(self).find {|obj| obj.name == name}
    end

    attr_reader :name
    attr_reader :producer, :customer

    attr_accessor :tag

    def initialize(src, dest, tag=nil)
      @tag = tag.nil? ? SecureRandom.base64(9) : tag
      @name = SecureRandom.base64(9)
      @queue = []
      @producer = src
      @customer = dest
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
