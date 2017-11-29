
class iproute2 (
	String $version = 'v4.14.0',
	String $temp_path = '/tmp',
) {
	$git_repo = "git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git"
	$iproute2_cwd = "${temp_path}/iproute2"

	exec { 'iproute2-download':
		require => Exec['apt-update'],
		creates => $iproute2_cwd,
		command => "git clone ${git_repo} ${iproute2_cwd}",
	}
	# Somehow using TMPDIR as bash variable is a problem in the vagrant box
	exec { 'iproute2':
		require => Exec['iproute2-download'],
		cwd => $iproute2_cwd,
		path => "${default_path}:${iproute2_cwd}",
		command => "git checkout ${version} &&\
			    sed -i -e 's/TMPDIR/TEMPDIR/g' ${iproute2_cwd}/configure &&\
			    configure &&\
			    make &&\
			    make install;",
	}
}

