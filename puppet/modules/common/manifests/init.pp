
class common {
	package { 'git': }
	package { 'pkg-config': }
	package { 'bison': }
	package { 'flex': }
	package { 'python': }
	package { 'libelf-dev': } # Needed for Virtualbox guest additions on kernels above 4.14
}

