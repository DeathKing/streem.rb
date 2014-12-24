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

    attr_accessor :value
    attr_accessor :producer, :customer
    
    def initialize(producer, customer)
      # FIXME: typecheck
      @name = SecureRandom.base64(10)
      @producer = producer
      @customer = customer

      producer.add_output_pipe(@name, self)
      customer.add_input_pipe(@name, self)
    end

    def |(target)
      # target only could be connectable
    end

    def value=(val)
      @value = val
      @customer.trigger(@name)
    end

  end

end
