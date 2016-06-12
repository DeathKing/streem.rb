STDIN.| Component(red).| STDOUT

seq(10).| stringfy.| Component(red).| STDOUT
seq(10).| Component(-> x {x % 2 == 0 ? skip : x}).
             | wait(1).| stringfy.| Component(blue) .| STDOUT