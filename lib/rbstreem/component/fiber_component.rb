module RbStreem
  class FiberComponent < Fiber

    include Connectable

    def dead?
    end

    def ready?
    end

  end
end

