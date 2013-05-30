# $Id: ssetype.rb 3913 2010-11-30 13:30:08Z uwaechte $
require 'thread'

if Facter.value("kernel") == "Linux"
  Facter.add("ssetype") do
    confine :kernel => :linux
    result = "none"
    setcode do
      str = IO.read('/proc/cpuinfo')
      if str =~ /sse2/
        result = "sse2"
      elsif str =~ /sse/
        result = "sse"
      end
      result
    end
  end
end