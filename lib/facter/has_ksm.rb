# $Id: has_ksm.rb 3657 2010-08-11 12:56:14Z uwaechte $

Facter.add("has_ksm") do
  confine :kernel => %w{Linux}
  #ksm = %x{grep KSM /boot/config-#{Facter.value(:kernelrelease)} |grep "=y"}.chomp
  setcode do
    File.exist?("/sys/kernel/mm/ksm/run")
  end
end

if Facter.value(:has_ksm) == true
  Facter.add("ksm_running") do
    confine :kernel => %w{Linux}
    if File.exist?("/sys/kernel/mm/ksm/run")
      run = File.read("/sys/kernel/mm/ksm/run").chomp
      setcode do
        run.to_i == 0 ? false : true
      end
    end
  end
end
