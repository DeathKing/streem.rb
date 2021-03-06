# seq(100) return a stream of numbers from 1 to 100.
# A function object in pipeline works as a map function.
# STDOUT is an output destination.
seq(100).| Component(-> x {
  if x % 15 == 0 
    "FizzBuzz"
  elsif x % 3 == 0 
    "Fizz"
  elsif x % 5 == 0
    "Buzz"
  else 
    x
  end
}).| STDOUT