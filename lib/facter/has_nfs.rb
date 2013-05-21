# check whether this machine is a nfs_client
require 'facter'

#get all nfs-mounts
nfs = Facter::Util::Resolution.exec('mount -t nfs|awk \'{print $3}\' |tr "\n", ","')
nf = nfs.nil? ? '' : nfs.gsub(/,$/, '')

Facter.add(:has_nfs) do
  setcode {
    nf.size > 0 ? "true" : "false"
  }
end

Facter.add(:nfs_mounts) do
  setcode {
    nf.size > 0 ? nf : "false"
  }
end
