# The purpose of this puppet file is to install SRv6-compatible kernel and some SRv6 tools

$home_path="/home/nanonet/${::non_root_user}"
$default_path = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Package {
	allow_virtual => true,
	ensure => installed,
	require => Exec['apt-update'],
}
Exec { path => $default_path }

exec { 'apt-update':
  command => 'apt-get update',
}

class { 'common': }

class { 'srv6_kernel':
	package_path => $::kernel_path,
}

class { 'iproute2':
	require => Class['common'],
	temp_path => $::temp_path,
}

class { 'nanonet':
	require => Class['common'],
	clone_path => $::temp_path,
	install_path => $::home_path,
	user => $::non_root_user
}

