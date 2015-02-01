class Array
  include Connectable

  def is_customer?
    false
  end

  def is_producer?
    true
  end

  def call(x)
    self
  end
end