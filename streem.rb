#!/usr/bin/env ruby
require_relative 'lib/rbstreem.rb'

at_exit { RbStreem::Component.start_schedule }
