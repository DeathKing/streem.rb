# Monkey patching
# Proc class should support |() call
#
# Proc in streem receives extractly one argument.
class Proc
  include Connectable
end

# Money patching
# Array class should support |() call
class Array
  include Connectable

  # Connectable Array should be blocked when it's empty
end
