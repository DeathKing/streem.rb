module RbStreem

  # if a computation raise a fail, that means pipe have to drop the 
  # somebody may want to design the Fail as a pesudo keyword like
  # nil\true\false and the class name should change to FailClass etc
  class Fail; end

  class SkipClass; end
end