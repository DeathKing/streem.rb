# Monkey patching
# Proc class should support |() call
#
# Proc in streem receives extractly one argument.
class Proc
  include Connectable

  # Proc always ready because it just wait on the argument
  # to call him.
  def ready?
    true
  end

  # Proc always not blocked, because it always ready.
  def blocked?
    false
  end

  # Proc never dead, because it always ready.
  def dead?
    false
  end

  def require_argument
    true
  end
end

# Money patching
# Array class should support |() call
class Array
  include Connectable

  def call(x)
    self
  end
end

