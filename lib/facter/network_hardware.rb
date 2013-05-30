# $Id: network_hardware.rb 3733 2010-09-24 11:21:10Z uwaechte $
# has_nvidia_graphics.rb
#

if Facter.kernel == "Linux"
  lspci = %x{which lspci}.chomp
  network = "false"
  if lspci.length > 0 and lspci = %x{#{lspci}} and lspci.match(/.*Network.*Wireless.*/)
    if network_full = lspci.match(/.*Network.*Wireless.*/)[0].split(/controller:/)[1].lstrip
      Facter.add("network_wireless_full") do
        setcode do
          network_full
        end # setcode
      end # Facter.add
    end
  end
end
