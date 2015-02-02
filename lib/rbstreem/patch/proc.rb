class Proc
  include RbStreem::Connectable

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

  def is_producer?
    true
  end

  def is_customer?
    true
  end

end