if Facter.value('kernel') == 'Darwin'
  basedir = '/etc'
else
  basedir = '/etc/ssh'
end
if File.exist?("#{basedir}/ssh_host_rsa_key.pub")
  keyinfo = %x{ssh-keygen -l -f #{basedir}/ssh_host_rsa_key.pub}.chomp.split(' ')
  Facter.add('ssh_rsa_bits') do
    setcode do
      keyinfo[0]
    end
  end
  Facter.add('ssh_rsa_fingerprint') do
    setcode do
      keyinfo[1]
    end
  end
end

if File.exist?("#{basedir}/ssh_host_dsa_key.pub")
  keyinfo2 = %x{ssh-keygen -l -f #{basedir}/ssh_host_dsa_key.pub}.chomp.split(' ')
  Facter.add('ssh_dsa_bits') do
    setcode do
      keyinfo2[0]
    end
  end
  Facter.add('ssh_dsa_fingerprint') do
    setcode do
      keyinfo2[1]
    end
  end
end
