# $Id: unameproc.rb 1299 2008-05-12 14:55:08Z admin $

# JJM 2006-11-30
# Return the generic processor type.
# I don't know any unix system this would fail on.
#

require 'thread'
Facter.add("processor") do
  setcode 'uname -p'
end
