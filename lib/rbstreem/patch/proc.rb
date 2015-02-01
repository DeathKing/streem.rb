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