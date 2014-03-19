# $Id: python_version.rb 3564 2010-07-21 09:40:41Z uwaechte $
ver = %x{python --version 2>&1}.chomp
Facter.add(:python_version) do
  setcode do
    ver.split(" ")[1]
  end
end