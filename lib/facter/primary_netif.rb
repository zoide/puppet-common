# $Id: primary_netif.rb 4823 2011-11-23 11:48:16Z uwaechte $
#
require 'thread'

Facter.add(:primary_netif) do
  confine :kernel => %w{Darwin FreeBSD}
  setcode do
    iface = ""
    netstat = %x{which netstat 2>/dev/null}.chomp
    if netstat != ""
      output = %x{#{netstat} -rn}
    else
      output = ""
    end
    if output =~ /^default\s*\S*\s*\S*\s*\S*\s*\S*\s*(\S*).*/
      $1
    else
      false
    end
  end
end
Facter.add(:primary_netif) do
  confine :kernel => %w{Linux}
  setcode do
    iface = ""
    ip = Facter.value("ipaddress")
    output = %x{/sbin/ifconfig  |grep -1 #{ip} |head -1 |awk '{print $1}'}.chomp
    if output != ""
      output
    else
      false
    end
  end
end

Facter.add(:internal_netif) do
  confine :kernel => %w{Linux}
  setcode do
    iface = ""
    output = %x{/sbin/ip a s to '10.0.0.0/8' |head -1 |awk '/:/ {print $2}' |sed s/://}.chomp
    if output != ""
      output
    else
      false
    end
  end
end

if Facter.value(:internal_netif) != false
  Facter.add(:ipaddress_intern) do
    confine :kernel => %w{Linux}
    setcode do
      iface = Facter.value(:internal_netif)
      output = %x{/sbin/ifconfig #{iface} |head -n 2 |grep inet |awk '/:/ {print $2}' |cut -f 2 -d :}.chomp
      if output != ""
        output
      else
        false
      end
    end
  end
  Facter.add(:internal_macaddress) do
     confine :kernel => %w{Linux}
     setcode do
       iface = Facter.value(:internal_netif)
       output = %x{/sbin/ip a s #{iface} |awk '/link\\/ether/ {print $2}'}.chomp
       if output != ""
         output
       else
         false
       end
     end
   end
end

