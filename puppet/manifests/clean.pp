# The purpose of this puppet file is to clean no longer needed packages in the VM

$default_path = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Package {
	allow_virtual => true,
	ensure => absent,
}
Exec { path => $default_path }

class { 'common::clean': }

exec { 'old-kernels':
	command => "sudo apt-get purge $(dpkg -l linux-{image,headers}-[0-9]*.* | awk '/ii/{print $2}' | grep -ve -$(uname -r))",
	require => Class['common::clean'],
}

exec { 'apt-autoremove':
	command => "apt auto-remove --assume-yes &&\
		    apt clean --assume-yes",
	require => [Class['common::clean'], Exec['old-kernels']],
}

exec { 'compress':
	command => "/vagrant/compress.sh",
	require => Exec['apt-autoremove'],
}

