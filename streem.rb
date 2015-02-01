#!/usr/bin/env ruby
require_relative 'lib/rbstreem.rb'

chomps = -> x {x.chomps}

STDIN.
  | chomps.
  | (-> x {puts "Should be recerse as #{x.reverse}"; x.reverse}).
  | STDOUT

at_exit {Component.start_schedule}