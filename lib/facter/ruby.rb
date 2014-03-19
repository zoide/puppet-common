# $Id: ruby.rb 3231 2010-03-16 14:24:17Z uwaechte $
require 'thread'

Facter.add(:ruby_version) do
    #confine :kernel => %w{Linux}
    setcode do
        %x{ruby --version}.chomp
    end # setcode
end
