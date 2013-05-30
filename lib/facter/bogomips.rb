# $Id: bogomips.rb 3914 2010-11-30 13:33:49Z uwaechte $
require 'thread'

if Facter.value("kernel") == "Linux"
  processor_num = -1
  processor_list = []
  Thread::exclusive do
    File.readlines("/proc/cpuinfo").each do |l|
      if l =~ /processor\s+:\s+(\d+)/
        processor_num = $1.to_i
      elsif l =~ /^bogomips\s+:\s+(\d+\.\d+)/
        processor_list[processor_num] = $1 unless processor_num == -1
        processor_num = -1
      end
    end
  end
  processor_list.each_with_index do |desc, i|
    Facter.add("Processor#{i}_bogomips") do
      confine :kernel => :linux
      setcode do
        desc
      end
    end
  end

  Facter.add("Bogomips_sum") do
    confine :kernel => :linux
    result = 0
    processor_list.each do |b|
      result += b.to_f
    end
    setcode do
      result
    end
  end
end