#!/usr/bin/env ruby
require_relative 'lib/rbstreem'

# lineno_counter = lambda do |filename|
#   lineno = 0
#   lambda do |str|
#     lineno += 1
#     "[#{filename}:#{lineno}] #{str}"
#   end
# end

# find = lambda do |patten, color|
#   lambda do |str|
#     if str.gsub!(patten) {|match| match.send(color)}
#       str
#     else
#       skip
#     end
#   end
# end

# Dir.glob("*.txt") do |filename|
#   file(filename).
#     | line_io.
#     | chomps.
#     | lineno_counter(filename).
#     | find(ARGV[0], :red).
#     | STDOUT
# end

to_str = -> obj { String(obj) }

seq(20).
  | -> x { x % 2 == 0 ? skip : x }.
  | to_str.
  | red.
  #| wait(1).
  | STDOUT

seq(20).
  | -> x { x % 2 == 0 ? skip : x }.
  | to_str.
  | blue.
  #| wait(1).
  | STDOUT

at_exit { RbStreem::Component.start_schedule }
