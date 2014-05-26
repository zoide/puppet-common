uname = Facter.value('kernel')
smartctl = case uname
when "Darwin" then "/opt/local/sbin/smartctl"
when "FreeBSD" then "/usr/local/sbin/smartctl"
else "/usr/sbin/smartctl"
end

if File.exists?(smartctl)

  ignorelines = "=== START OF READ SMART DATA SECTION ===|SMART Attributes Data Structure revision number|Vendor Specific SMART Attributes with Thresholds:|ID#\s+ATTRIBUTE_NAME\s+FLAG"
  smart_drvs = []
  if Facter.value(:harddrives) && Facter.value(:harddrives) != ""
    Facter.value(:harddrives).split(",").each { |drive|
      next if drive =~ /^da/
      drvcaps = []
      %x{#{smartctl} -A /dev/#{drive} 2>/dev/null|sed 1,3d}.chomp.each_line { |line|
        next if line =~ /#{ignorelines}/
        vals = line.split(" ")
        if (Float(vals[0]) rescue false)
          drvcaps <<  vals[1]
        end
      }
      ## create the facts
      if drvcaps.length > 0
        smart_drvs << drive
        Facter.add("harddrives_smartcaps_#{drive}") do
          setcode do
            drvcaps.join(',')
          end
        end
      end
    }
  end

  #now for all 3ware drives
  if Facter.value(:harddrives_3ware) && Facter.value(:harddrives_3ware) != ""
    Facter.value(:harddrives_3ware).split(",").each { |drive|
      drvcaps = []
      cntdrv = drive.split("_")
      controller = cntdrv[1][1,cntdrv[1].length]
      drv = cntdrv[2][1,cntdrv[2].length]
      %x{#{smartctl} -d 3ware,#{drv} -A /dev/twa#{controller} 2>/dev/null|sed 1,3d}.chomp.each { |line|
        next if line =~ /#{ignorelines}/
        vals = line.split(" ")
        if (Float(vals[0]) rescue false)
          drvcaps <<  vals[1]
        end
      }
      ## create the facts
      if drvcaps.length > 0
        smart_drvs << drive
        Facter.add("harddrives_smartcaps_#{drive}") do
          setcode do
            drvcaps.join(',')
          end
        end
      end
    }
  end

  if Facter.value(:has_aacraid)
    Dir.glob("/dev/sg*").each{ |drive|
      %x{#{smartctl} -q silent -d sat -c #{drive} 2>/dev/null}
      if $?.exitstatus == 0
        drv = File.basename(drive)
        drvcaps = []
        %x{#{smartctl} -d sat -A #{drive} 2>/dev/null|sed 1,3d}.chomp.each { |line|
          next if line =~ /#{ignorelines}/
          vals = line.split(" ")
          if (Float(vals[0]) rescue false)
            drvcaps <<  vals[1]
          end
        }
        ## create the facts
        if drvcaps.length > 0
          smart_drvs << drv
          Facter.add("harddrives_smartcaps_#{drv}") do
            setcode do
              drvcaps.join(',')
            end
          end
        end
      end
    }
  end

  if smart_drvs.length > 0
    Facter.add("harddrives_smartcaps") do
      setcode do
        smart_drvs.join(",")
      end
    end
  end
end