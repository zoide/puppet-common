# $Id: macosx_productcode.rb 2835 2009-09-05 10:42:28Z uwaechte $

require 'thread'

# get the operatingsystem name i.e. productcode of mac os x
if Facter.kernel == "Darwin"
	Facter.add("macosx_productcode") do
	setcode do
    if(Facter.macosx_productversion.match /10.6/)
      "Snow Leopard"
		elsif(Facter.macosx_productversion.match /10.5/)
		  "Leopard" 
		elsif (Facter.macosx_productversion.match /10.4/)
		  "Tiger"
		elsif (Facter.macosx_productversion.match /10.3/)
		  "Panther"
		elsif (Facter.macosx_productversion.match /10.2/)
		  "Jaguar"
		elsif (Facter.macosx_productversion.match /10.1/)
		  "Puma"
		else
		  "unknown"
		end
	end
	end
end
