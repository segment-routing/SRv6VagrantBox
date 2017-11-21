
class srv6_kernel (
	String $kernel_version = '4.14.0',
	String $local_version = '-srv6',
	String $kdeb_version = '4.14.0-1',
	String $package_path = '/home/vagrant/kernel',
) {
	package { 'linux-headers':
		provider => dpkg,
		ensure => installed,
		source => "${package_path}/linux-headers-${kernel_version}${local_version}_${kdeb_version}_amd64.deb",
	}
	package { 'linux-libc':
		provider => dpkg,
		ensure => installed,
		source => "${package_path}/linux-libc-dev_${kdeb_version}_amd64.deb",
		require => Package['linux-headers'],
	}
	package { 'linux-image':
		provider => dpkg,
		ensure => installed,
		source => "${package_path}/linux-image-${kernel_version}${local_version}_${kdeb_version}_amd64.deb",
		require => Package['linux-headers', 'linux-libc'],
	}
}

