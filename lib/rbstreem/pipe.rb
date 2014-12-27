require 'securerandom'

# Pipe in streem.rb always be single direction!
module Connectable

  # Pipe must have a uniq name to deal with data flow
  class Pipe

    def self.find_by_name(name)
      ObjectSpace.each_object(self).find {|obj| obj.name == name}
    end

    attr_reader :name
    attr_reader :producer, :customer
    
    def initialize(producer, customer, name=nil)
      # FIXME: typecheck
      @name = name.nil? ? SecureRandom.base64(10) : name
      @buffer = []
    end

    def puts(val)
      @buffer << val
      val
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
