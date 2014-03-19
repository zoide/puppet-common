# $Id: kernelpackageversion.rb 3913 2010-11-30 13:30:08Z uwaechte $

# Display the package version of the installed package
if Facter.value("kernel") == "Linux"
  Facter.add("kernelpackageversion") do
    confine :kernel => %w{Linux}
    kver=Facter.value(:kernelrelease)
    out = %x{dpkg -l linux-image-#{kver} 2>/dev/null|awk '/linux-image.*#{kver}/ {print $3}'}.chomp
    if out == ""
      out = "n/a"
    end
    setcode do
      out
    end
  end
end