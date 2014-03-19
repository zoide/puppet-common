# $Id: lvm.rb 4849 2011-11-30 13:10:39Z uwaechte $

if File.exists?("/sbin/lvm")
  vgs=[]
  %x{/sbin/lvm vgdisplay -s 2>/dev/null}.chomp.strip.each_line do |line|
    arr = line.gsub(/[\["\/]/, "").split(" ")
    vgs << arr[0]
    Facter.add("lvm_#{arr[0]}_size") do
      setcode do
        arr[1].strip + " " +arr[2]
      end
    end
    Facter.add("lvm_#{arr[0]}_used") do
      setcode do
        arr[3].strip + " " +arr[4]
      end
    end
    Facter.add("lvm_#{arr[0]}_free") do
      setcode do
        arr[6].strip + " " +arr[7]
      end
    end
  end

  if vgs.size > 0
    Facter.add("lvm_volumegroups") do
      setcode do
        vgs.join(" ")
      end
    end
  end
end
