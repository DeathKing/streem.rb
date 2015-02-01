require 'securerandom'

# Pipe in streem.rb always be single direction!
module RbStreem
  class Pipe

    # Find a specific piple
    def self.find_by_name(name)
      ObjectSpace.each_object(self).find {|obj| obj.name == name}
    end

    attr_reader :name
    attr_reader :producer, :customer
    
    
    def initialize(producer, customer, name=nil)
      # FIXME: typecheck
      # Pipe must have a uniq name to deal with data flow
      @name = name.nil? ? SecureRandom.base64(10) : name
      @queue = []
      # producer and customer seems useless because a pipe never
      # informe the customer once it gets ready.
      @producer = producer
      @customer = customer
      @died = false
    end

    def puts(val)
      @queue << val
      val
    end

    # kill the component
    def kill
      @died = true
    end

    def gets
      if @queue.empty?
        raise "Pipe empty!"
      else
        @queue.shift
      end
    end

    def head
      @queue.empty? ? nil : @queue.first
    end

    def empty?
      @queue.empty?
    end

    def ready?
      not empty?
    end

    def died?
      @died
    end
  end

end
