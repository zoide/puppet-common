# collect info about 3ware controllers
# loop through all controllers
require 'thread'

tw_cli = %x{which tw-cli 2>/dev/null}.chomp
has_3ware=false
all_drives = []
if tw_cli != ""
  %x{#{tw_cli} show |grep -e '^c.'}.each { |line|
    if line =~ /^c/
      has_3ware=true
      larr = line.split(' ')
      controller = larr[0]
      %x{#{tw_cli} /#{controller} show}.each { |device|
        if device =~ /^p/
          parr = device.split(' ')
          Facter.add("tw_#{controller}_#{parr[0]}_status") do
            setcode do
              parr[1].lstrip.rstrip
            end
          end
          if ! parr[1].eql?("NOT-PRESENT")
            #full=""
            all_drives << "tw_#{controller}_#{parr[0]}"
            ["model", "serial", "firmware", "capacity"].each { |type|
              %x{#{tw_cli} /#{controller}/#{parr[0]} show #{type}}.each { |info|
                #puts "#{type}  /#{controller}/#{parr[0]}  #{info}"
                desc = info.split('=')
                dsc = desc[1]
                #full = full << dsc.rstrip.lstrip << " "
                Facter.add("tw_#{controller}_#{parr[0]}_#{type}") do
                  setcode do
                    dsc.lstrip.rstrip
                  end
                end
              }
            }
          end
        end # end device info
      }
    end # end controller info
  }
end
if has_3ware
  Facter.add("harddrives_3ware") do
    setcode do
      all_drives.join(",")
    end
  end
end

Facter.add("has_3ware") do
  setcode do
    has_3ware
  end
end
