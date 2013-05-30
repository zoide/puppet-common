# $Id: package_repositories.rb 2813 2009-09-02 14:58:40Z uwaechte $
# Shows available package repositories
require 'thread'

if Facter.value(:kernel) == "Darwin"
  Facter.add(:package_repositories) do
  confine :kernel => :darwin
  repo = "MacOSX"
  if File.exist?("/opt/local/bin/port") 
    repo = repo+",MacPorts"
  end
  setcode do
    repo 
  end
  end
end

if Facter.value(:kernel) == "Linux"
  Facter.add(:package_repositories) do
  confine :kernel => :linux
  repo = %x{apt-cache policy |awk -F ',' '/c=/ {print substr($5,3)}' |sort |uniq}.lstrip.rstrip.gsub(/\n/,',')
  setcode do
    repo    
  end
  end
end
