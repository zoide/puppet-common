#
# run pystone benchmark
#
require 'thread'

statefile = "/var/lib/puppet/state/pystone.fact"
statefile_avg = "#{statefile}.avg"
python = %x{/usr/bin/which python}.chomp
if File.exist?(python)
  if (! File.exist?(statefile)) || 
    (File.mtime(statefile) < Time.now - (86400 * (rand(10)+1)))
    system "#{python} -c \"from test import pystone; print ':'.join(map(str,pystone.pystones(1000000)))\">#{statefile}"
  end
  if File.exist?(statefile)
    if ! File.exist?(statefile_avg)
      FileUtils.cp(statefile,statefile_avg)
    end
    contents = File.read(statefile)
    stones = contents.chomp.split(":")
    Facter.add("pystone_runtime") do
      setcode do
	stones[0]
      end
    end
    Facter.add("pystone_stones") do
      setcode do
	stones[1]
      end
    end
    contents_avg = File.read(statefile_avg).chomp
    stones_avg = contents_avg.split(":")
    Facter.add("pystone_runtime_avg") do
      setcode do
	stones_avg[0]
      end
    end
    Facter.add("pystone_stones_avg") do
      setcode do
	stones_avg[1]
      end
    end
    if File.mtime(statefile) > File.mtime(statefile_avg)
	    stones_avg[0] = (stones[0].to_f + stones_avg[0].to_f) / 2
	    stones_avg[1] = (stones[1].to_f + stones_avg[1].to_f) / 2
	    stf = File.new(statefile_avg,"w")
	    stf.puts "#{stones_avg[0]}:#{stones_avg[1]}"
	    stf.close
    end
  end
end
