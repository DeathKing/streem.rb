module RbStreem
  Connection = Struct.new(:src, :dest, :pipe) do
    include RbStreem::Connectable

    def connection_target
      src
    end

    def connection_source
      dest
    end
  end
end