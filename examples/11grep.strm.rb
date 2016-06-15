# Build a counter closure
def lineno_counter(filename)
  lineno = 0
  Component(-> str do
    lineno += 1
    "[#{filename}:#{lineno}] #{str}"
  end)
end

# find combinator
# find = λpattern.λcolor.λstr.
#          if pattern occurs in str
#          then
#              replace ∀pattern with color(str)
#              return str
#          else
#              return skip
def find(pattern, color)
  Component(-> str do
    if str.gsub!(pattern) {|match| match.send(color)}
      str
    else
      skip
    end
  end)
end

cached = {chomps: chomps,
          find: find(strm_arg[0], :red)}

Dir.glob("./**/*.rb") do |filename|
  line_io(filename).
    | cached[:chomps].
    | lineno_counter(filename).
    | cached[:find].
    | STDOUT
end