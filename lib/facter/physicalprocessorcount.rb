require 'thread'

Facter.add("physicalprocessorcount") do
  confine :kernel => :darwin
  setcode do
    ppcount = Facter::Util::Resolution.exec('/usr/sbin/system_profiler SPHardwareDataType |grep "Number Of CPU"|awk -F ": " \'{print $2}\'')
  end
end

Facter.add("processorcount") do
  confine :kernel => :darwin
  setcode do
    ppcount = Facter::Util::Resolution.exec('/usr/sbin/system_profiler SPHardwareDataType |grep "Number Of CPU"|awk -F ": " \'{print $2}\'')
  end
end

