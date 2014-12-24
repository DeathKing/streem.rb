# Namespace
module Connectable
  class IO
    class In
      
      def initialize(source)
        @source = source
      end

      def blocked?
      end

    end

    class Out

      def initialize(target)
        @target = target
      end

    end
  end
end