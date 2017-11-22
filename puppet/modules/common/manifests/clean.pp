
class common::clean {
	package { 'git':
		ensure => absent,
	}
	package { 'pkg-config':
		ensure => absent,
	}
	package { 'bison':
		ensure => absent,
	}
	package { 'flex':
		ensure => absent,
	}
}

