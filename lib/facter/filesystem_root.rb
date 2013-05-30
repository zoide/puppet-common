# $Id: filesystem_root.rb 4539 2011-07-22 17:45:18Z uwaechte $

#puppet's vardir
require 'thread'

fs_info = %x{mount |grep -e ' / '}.chomp.split(" ")

Facter.add("filesystem_root_device") do
  setcode do
   fs_info[0]
  end
end

Facter.add("filesystem_root_fstype") do
  setcode do
   Facter.value(:kernel) == "Linux" ? fs_info[4] : fs_info[3]
  end
end

df=%x{df -k /|tail -n +2|tr -d "\n"}.chomp.split(" ")
#df=%x{df -k /|tail -1}.chomp.split(" ")

Facter.add("filesystem_root_size") do
  setcode do
    df[1].to_i / 1024
  end
end

Facter.add("filesystem_root_used") do
  setcode do
    df[2].to_i / 1024
  end
end

Facter.add("filesystem_root_free") do
  setcode do
    df[3].to_i / 1024
  end
end
