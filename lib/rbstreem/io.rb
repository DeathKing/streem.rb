# Namespace
module Connectable
  class IO
  end
  class In < IO
    
    def initialize(source)
      @source = source
    end

    def blocked?
    end
  end

  class Out < IO

    def initialize(target)
      @target = target
    end

  end
end