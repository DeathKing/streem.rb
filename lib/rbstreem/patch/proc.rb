class Proc
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

  def producer?
    false
  end

  def customer?
    true
  end

end
