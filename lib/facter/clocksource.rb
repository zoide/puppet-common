# $Id: clocksource.rb 3564 2010-07-21 09:40:41Z uwaechte $

require 'thread'
file="/sys/devices/system/clocksource/clocksource0/current_clocksource"
if File.exist?(file) and File.readable?(file)
  Facter.add("clocksource") do
    setcode do
      confine :kernel => %w{Linux}
      File.read(file).chomp
    end
  end
end
