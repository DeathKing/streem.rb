cached = {stringfy: stringfy, seq_100: seq(100)}

cached[:seq_100].| Component(-> x {x.even? ? skip : x}).| cached[:stringfy].| red.| STDOUT
cached[:seq_100].| Component(-> y {y.odd? ? skip : y}).| cached[:stringfy].| blue.| STDOUT