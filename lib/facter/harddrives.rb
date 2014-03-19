  # $Id: harddrives.rb 2890 2009-09-23 17:22:29Z uwaechte $
require 'thread'

$removable=[]
$static=[]

def init_drives
  if Facter.value(:kernel) == "Darwin"
    drvs = Dir.glob("/dev/disk?")
    drvs.each { |drv|
      if %x{diskutil info #{drv} |grep Ejectable}.chomp =~ /Ejectable.*No/
        $static << File.basename(drv)
      else
        $removable << File.basename(drv)
      end
    }
  elsif Facter.value(:kernel) == "FreeBSD"
    $static = %x{sysctl kern.disks |cut -f 2 -d :}.chomp.split(" ")
  else
    drives = Dir.glob("/sys/block/[hs]d?")
    drives.each do |drive|
      drp = "#{drive}/removable"
      if File.exist?(drp) and %x{grep 1 #{drp}}.chomp == "1"
        $removable << File.basename(drive)
      else
        $static << File.basename(drive)
      end
    end
  end
end

init_drives

if $removable.length > 0
  Facter.add("blockdevice_removable") do
    setcode do
      $removable.join(",")
    end
  end
end
drives = $static
Facter.add("harddrives") do
  setcode do
    drives.join(",")
  end
end

#if Facter.value("kernel") == "Linux"
#  drives_info = {}
#  drives.each { |drive|
#    cdrive = {}
#    drive = File.basename(drive)
#    dpath = "/sys/block/#{drive}/device"
#    ["model", "vendor", "rev"].each { |key|
#      if File.exists?("#{dpath}/#{key}")
#        fcont = File.open("#{dpath}/#{key}","r")
#        cdrive[key] = fcont.gets.chomp.rstrip
#        fcont.close
#      end
#    }
#    cdrive["full"] = "#{cdrive['vendor']} #{cdrive['model']} #{cdrive['rev']}"
#    drives_info[drive] = cdrive
#  }
#  drives_info.each_pair { |drive, info|
#    info.each { |key, value|
#      Facter.add("Harddrive_#{drive}_#{key}") do
#        confine :kernel => :linux
#        setcode do
#          value
#        end
#      end
#    }
#  }
#end
