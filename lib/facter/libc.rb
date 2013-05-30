# $Id: libc.rb 3913 2010-11-30 13:30:08Z uwaechte $

if Facter.value("kernel") == "Linux"
  Facter.add(:libc6_distversion) do
    confine :kernel => %w{Linux}
    setcode do
      %x{dpkg -l libc6|tail -1|awk '{print $3}'}.chomp
    end # setcode
  end

  if File.exists?("/usr/bin/pkg-config")
    Facter.add(:libc6_version) do
      confine :kernel => %w{Linux}
      out=%x{pkg-config --modversion glib-2.0 2>/dev/null}.chomp
      out = out == "" ? "unknown" : out
      setcode do
        out
      end # setcode
    end
  end
end