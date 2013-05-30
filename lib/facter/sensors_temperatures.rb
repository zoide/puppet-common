# $Id: sensors_temperatures.rb 3536 2010-07-08 12:43:38Z uwaechte $
#
# sensors_temperatures.rb - shows the temperature sensors of the machines
#
require 'thread'

temps=[]
statefile = "/var/lib/puppet/state/sensors_temps.fact"
if (! File.exist?(statefile)) || (File.mtime(statefile) < Time.now - 86400 )
  if ["physical", "xen0"].include? Facter.value("virtual")
    if Facter.value("has_ipmi")
      idx=0
      %x{ipmitool sdr type Temperature list 2>/dev/null | grep ok}.each_line do |line|
        vals = line.chomp.split('|')
        #if vals[0] =~ /[tT]emp/ and !vals[2].lstrip.rstrip.eql?("ns") and !vals[1].lstrip.rstrip.include?("0x")
        val = vals[0].lstrip.rstrip.gsub(/\//,"_")
        if temps.include? val
          val = "#{val}#{idx}"
          idx=idx.succ
        end
        temps << val
        #end
      end
    elsif %x{which sensors} and $? == 0
      require 'yaml'
      doc = %x{sensors -A -u 2>/dev/null | grep -ie ':' }
      doc.gsub!(/^\s+(.*:)$/, '\1')
      if doc != ""
        yaml = YAML.load(doc)
        yaml.each_key { |k|
          if ! yaml[k].nil?
            yaml[k].each_key { |v|
              if v =~ /temp.*input/
                temps << k.gsub(/\//,"_")
              end
            }
          end
        }
      end
    end

  elsif Facter.value("kernel") == "Darwin" and File.exist?("/usr/local/bin/tempmonitor")
    %x{/usr/local/bin/tempmonitor -a -l |grep -v SMART}.each_line do |line|
      vals = line.chomp.split(":")
      temps << vals[0]
    end
  end
  if Facter.value("kernel") == "FreeBSD"
    %x{sysctl dev.cpu |grep temperature |sed -e s/dev.//g -e s/.temperature.*$//g }.each {|line|
      temps << line.gsub(/cpu\./,"CPU ").chomp
    }
  end
  temps = temps.join(',')
  File.open(statefile,'w').puts("#{temps}")
elsif !File.zero?(statefile)
  temps = File.open(statefile).gets.chomp
end

if temps.length > 0
  Facter.add("sensors_temperatures") do
    confine :kernel => %w{Linux FreeBSD Darwin}
    setcode do
      temps
    end
  end
end
