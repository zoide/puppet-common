# $Id: aacraid.rb 2893 2009-09-23 18:50:37Z uwaechte $
require 'thread'

has_aacraid = false
if Facter.value(:kernel) == "Linux" && %x{lsmod 2>/dev/null|grep -c aacraid}.chomp.to_i > 0
  has_aacraid = true
end
Facter.add("has_aacraid") do
  setcode do
    has_aacraid
  end
end