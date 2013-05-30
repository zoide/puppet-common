# $Id: processor_vendorid.rb 4204 2011-04-12 13:50:13Z uwaechte $

if File.exists?("/proc/cpuinfo")
  Facter.add("processor_vendorid") do
    confine :kernel => %w{Linux}
    id = %x{grep vendor_id /proc/cpuinfo |uniq|awk '{print $3}'}.chomp
    setcode do
      id.strip
    end
  end
end