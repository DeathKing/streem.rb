class ArrayContainer < Array

  def customer?
    false
  end

  def producer?
    true
  end

  def dead?
    false
  end

  def ready?
    true
  end

  def call(_)
    self
  end
end