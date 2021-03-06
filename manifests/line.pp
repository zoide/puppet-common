# common/manifests/defines/line.pp -- a trivial mechanism to ensure a line exists in a file
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

# Ensures that a specific line is present or absent in a file. This can
# be very brittle, since even small changes can throw this off.
#
# If the line is not present yet, it will be appended to the file.
# 
# The name of the define is not used. Just keep it (globally) unique and
# descriptive.
#
# Use this only for very trivial stuff. Usually replacing the whole file
# is a more stable solution with less maintenance headaches afterwards.
#
# Usage:
#  line {
#  	description:
# 			file => "filename",
#  		    line => "content", #defaults to $namevar
# 			ensure => {absent,*present*}
#  }
#
# Example:
# The following ensures that the line "allow ^$munin_host$" exists in
# /etc/munin/munin-node.conf, and if there are any changes notify the
# service for a restart
#
define common::line($file, $line=false, $ensure = 'present') {
	$line_r = $line ? {
	  false => $name,
	 default => $line,
	}
	case $ensure {
		default : { err ( "unknown ensure value '${ensure}'" ) }
		present: {
			exec { "echo '${line_r}' >> '${file}'":
				unless => "grep -qFx '${line_r}' '${file}'"
			}
		}
		absent: {
			exec { "perl -ni -e 'print if \$_ ne \"${line_r}\n\";' '${file}'":
				onlyif => "grep -qFx '${line_r}' '${file}'"
			}
		}
	}
}
