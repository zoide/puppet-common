if Facter.value('kernel') == "Linux"
    kernver = %x{cat /proc/version|grep "gcc version"}.chomp
    Facter.add("gcc_kernel") do
	setcode do
	    kernver.gsub(/^.*gcc version ([0-9\.]*)\s.*$/, '\1')
	end # setcode
    end
    Facter.add("gcc_kernel_full") do
	setcode do
	    kernver.gsub(/^.*gcc version (.*)\).*/, '\1')
	end # setcode
    end
end

if gcc = %x{which gcc}.chomp and gcc != ""
    gccver=%x{#{gcc} -v 2>&1 | grep "gcc version"}.chomp.rstrip
    Facter.add("gcc") do
	setcode do
	    gccver.gsub(/gcc version ([0-9\.]*)\s.*$/, '\1')
	end # setcode
    end

    Facter.add("gcc_full") do
	setcode do
	    gccver.gsub(/gcc version (.*)$/, '\1')
	end # setcode
    end
end
