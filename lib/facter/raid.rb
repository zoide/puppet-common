# $Id: raid.rb 2833 2009-09-05 08:35:47Z uwaechte $
#
require 'thread'

has_raid = "false"
raids = {}
i = 0
if FileTest.exists?("/proc/mdstat")
  File.open("/proc/mdstat").each_line { |line|
    if line =~ /^md/i
      curr = line.split(":")
      curr[0] = curr[0].lstrip.rstrip
      curr[1] = curr[1].lstrip.rstrip
      raid = {}
      has_raid = "true"
      raid["type"] = "software"
      raid["device"] = curr[0]
      raid["controller"] = curr[1]
      raids["#{i}"] = raid
      i += 1
    end
  }
end
# now check for hardware raids
%x{which lspci 2>/dev/null}
if $?.exitstatus == 0
  %x{lspci}.each_line { |line|
    if line =~ /RAID/i
      curr =  line.split(":")
      curr[2] = curr[2].rstrip.lstrip
      curr[1] = curr[1].rstrip.lstrip
      raid = {}
      has_raid = "true"
      raid["type"] = "hardware"
      raid["controller"] = curr[2]
      raids["#{i}"] = raid
      i += 1
    end
  }
end

raids.each_pair { |number,info|
  info.each_pair { |key,desc|
    Facter.add("raid#{key}_#{number}") do
      confine :kernel => :linux
      setcode do
        desc
      end
    end
  }
}

Facter.add("has_raid") do
  confine :kernel => :linux
  setcode do
    has_raid
  end
end
