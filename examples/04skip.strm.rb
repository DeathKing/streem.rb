# pick even numbers
seq(100).| Component(-> x {if x % 2 == 1 then skip end; x}).| STDOUT
# output:
#  1
#  3
#  5
#  :
