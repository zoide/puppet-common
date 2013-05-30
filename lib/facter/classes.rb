# classes fact: Adds all classes as csv string the host's facts
#
# 2007 - Udo Waechter (c) Public Domain
#
require 'thread'

Facter.add('classes') do
	setcode do 
		begin 
			#classes = File.new("/var/lib/puppet/state/classes.txt")
			classes = "/var/lib/puppet/state/classes.txt"
			csv = ""
			if File.exists?(classes)
				clas = File.new(classes)
				while (line = clas.gets)
					csv += line.chomp+","
				end
				clas.close
				csv.gsub(/,$/,'')
			end
		rescue => err
		"File read error on: %s" % classes 
		end
	end
end
