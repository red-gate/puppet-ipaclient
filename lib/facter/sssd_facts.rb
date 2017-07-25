begin
  require 'facter'
  require 'augeas'

  Facter.add('sssd_version') do
    setcode do
      Facter::Util::Resolution.exec('sssd --version')
    end
  end

  Facter.add(:sssd_services) do
    setcode do
      if File.exist? '/etc/sssd/sssd.conf'
        Augeas::open do |aug|
          aug.load
          aug.get("/files/etc/sssd/sssd.conf/target[.='sssd']/services")
        end
      else
        'nss, pam, ssh'
      end
    end
  end
rescue LoadError
  # Do Nothing if augeas cannot be loaded. (may be resolving facts on Windows)
end
