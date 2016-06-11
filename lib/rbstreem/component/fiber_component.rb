module RbStreem
  class Component < Fiber

    include Connectable

    def dead?
    end

    def ready?
    end

  end
end

