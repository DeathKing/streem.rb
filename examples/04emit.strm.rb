# repeat twice
seq(100).| Component(-> x { emit x, x }).| STDOUT
# output:
#  1
#  1
#  2
#  2
#  :
