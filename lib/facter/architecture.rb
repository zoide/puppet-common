# $Id: architecture.rb 3636 2010-08-03 10:28:08Z uwaechte $

Facter.add(:architecture) do
  confine :kernel => :linux
  setcode do
    model = Facter.value(:hardwaremodel)
    case model
    # most linuxen use "x86_64"
    when 'x86_64'
      Facter.value(:operatingsystem) == "Debian" ? "amd64" : model;
    when /(i[3456]86|pentium)/; "i386"
    else
      model
    end
  end
end

Facter.add(:architecture) do
  confine :kernel => :darwin
  setcode do
    model = Facter.value(:hardwaremodel)
    if model == "Power Macintosh"
      "ppc"
    else
      model
    end
  end
end
