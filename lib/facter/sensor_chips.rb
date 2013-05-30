# $Id: sensor_chips.rb 3618 2010-07-27 12:56:44Z uwaechte $
require 'thread'

if File.exist?("/usr/bin/sensors")
    Facter.add(:sensors_chips) do
        confine :kernel => %w{Linux}
        setcode do
            %x{sensors -u 2>/dev/null|grep -v :}.split(/\n\n/).join(",")
        end # setcode
    end
end
