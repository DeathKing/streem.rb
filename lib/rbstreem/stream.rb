class Stream

  def initialize
    @value = nil
  end

  def shift!
    ret = @value
    transform_to_next
    return ret
  end

end