require 'securerandom'

# Pipe in streem.rb always be single direction!
module Connectable

  # Pipe must have a uniq name to deal with data flow
  class Pipe

    def self.find_by_name(name)
      ObjectSpace.each_object(self).select do |obj|
        obj.name == name
      end.first
    end


    attr_reader :name
    attr_reader :producer, :customer
    
    def initialize(producer, customer)
      # FIXME: typecheck
      @name = SecureRandom.base64(10)
      @buffer = []
    end

    def |(target)
      # target only could be connectable
    end

    def puts(val)
      @buffer << val
      @customer.trigger
    end

    def gets
      if @buffer.empty?
        raise "Pipe empty!"
      else
        @buffer.shift
      end
    end

    def empty?
      @buffer.empty?
    end

    def ready?
      not empty?
    end
  end

end
