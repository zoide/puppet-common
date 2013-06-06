require "resolv"

module Puppet::Parser::Functions
   newfunction(:getipaddress, :type => :rvalue) do |args|
      Resolv.getaddress(args[0]).to_s
   end
end
