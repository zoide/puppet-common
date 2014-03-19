# $Id: sensors_fans.rb 3536 2010-07-08 12:43:38Z uwaechte $
#
# sensors_fans.rb - shows the fans of the machines
#
require 'thread'

if ["physical", "xen0"].include? Facter.value("virtual")
  statefile = "/var/lib/puppet/state/sensors_fans.fact"
  fans=[]
  if (! File.exist?(statefile)) ||
  (File.mtime(statefile) < Time.now - 86400 )
    if Facter.value("has_ipmi")
      %x{ipmitool sdr type Fan list 2>/dev/null | grep -i ok | grep -e 'RPM$' }.each_line do |line|
        vals = line.chomp.split('|')
        if vals[0] =~ /fan/i and !vals[2].lstrip.rstrip.eql?("nr")
          fans << vals[0].lstrip.rstrip.gsub(/\//,"_")
        end
      end
    elsif %x{which sensors 2>/dev/null} != ""
      require 'yaml'
      doc = %x{sensors -A -u 2>/dev/null |grep -ie ':'}
      doc.gsub!(/^\s+(.*:)$/, '\1')
      if doc != ""
        yaml = YAML.load(doc)
        yaml.each_key { |k|
          if ! yaml[k].nil?
            yaml[k].each_key { |v|
              if v =~ /fan.*input/
                fans << k.gsub(/\//,"_")
              end
            }
          end
        }
      end
    end
    fans = fans.join(',')
    File.open(statefile,'w').puts("#{fans}")
  elsif !File.zero?(statefile)
    fans = File.open(statefile).gets.chomp
  end
  if fans.length > 0
    Facter.add("sensors_fans") do
      confine :kernel => %w{Linux FreeBSD}
      setcode do
        fans
      end
    end
  end
end
