# Build a counter closure
lineno_counter = lambda do |filename|
  lineno = 0
  lambda do |str|
    lineno += 1
    "[#{filename}:#{lineno}] #{str}"
  end
end

# find combinator
# find = λpattern.λcolor.λstr.
#          if pattern occurs in str
#          then
#              replace ∀pattern with color(str)
#              return str
#          else
#              return skip
def_combinator :find do |pattern, color|
  lambda do |str|
    if str.gsub!(pattern) {|match| match.send(color)}
      str
    else
      skip
    end
  end
end

Dir.glob("*.txt") do |filename|
  file(filename).
    | line_io.
    | chomps.
    | lineno_counter(filename).
    | find(ARGV[0], :red).
    | STDOUT
end