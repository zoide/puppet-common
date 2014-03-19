# $Id$
if !Facter.value("interfaces").nil?
  Facter.value("interfaces").split(",").each { |interface|
    ethstat = "/usr/sbin/ethtool #{interface} 2>/dev/null|grep Speed |cut -f 2 -d :"
    if Facter.value("kernel") == "Darwin"
      ethstat = "ifconfig #{interface} |grep -e 'media' |head -1 |awk '{print $3}' |sed s/\(//"
    end

    Facter.add("interface_speed_#{interface}") do
      confine :kernel => %w{:linux :darwin}
      setcode do
        %x{ethstat}.chomp.lstrip
      end
    end
  }
end