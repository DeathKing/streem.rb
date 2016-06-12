require 'securerandom'

module RbStreem
  Connection = Struct.new(:src, :dest, :pipe) do

    include RbStreem::Connectable

    def self.generate_flow_tag
      "flow-#{SecureRandom.base64(6)}"
    end

    def connection_target
      src
    end

    def connection_source
      dest
    end

    def pipe_flow_tag
      pipe.flow_tag
    end
  end
end