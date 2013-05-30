# $Id: macports_version.rb 3070 2009-12-29 11:06:26Z uwaechte $
# The version of macports which is installed
if File.exists?("/opt/local/bin/port") && Facter.value(:kernel) == "Darwin"
    version = %x{/opt/local/bin/port version |cut -f 2 -d ' '}.chomp
    Facter.add(:macports_version) do
        confine :kernel => :darwin
        setcode do
            version
        end
    end
end