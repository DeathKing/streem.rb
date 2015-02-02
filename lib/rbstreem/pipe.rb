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
    
    def initialize(src, dest, name=nil)
      # FIXME: typecheck
      # Pipe must have a uniq name to deal with data flow
      name = dest.is_a?(Pipe) ? dest.name : name
      @name = name.nil? ? SecureRandom.base64(9) : name
      @queue = []
      # producer and customer seems useless because a pipe never
      # informe the customer once it gets ready.
      @producer = Component.build(src)
      @customer = Component.build(dest)

      @producer.add_write_pipe(self)
      @customer.add_read_pipe(self)
    end

    def dead?
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
