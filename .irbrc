#! /usr/bin/env ruby
require 'irb/completion'
require 'irb/ext/save-history'

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:SAVE_HISTROY] = 1000

# Hirb
require 'hirb'
Hirb.enable
extend Hirb::Console

# Wirble
require 'wirble'
Wirble.init
Wirble.colorize†