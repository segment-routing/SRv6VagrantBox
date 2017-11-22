

class nanonet (
	String $clone_path = '/tmp',
	String $install_path = '/home/vagrant',
) {
	$git_repo = "https://github.com/segment-routing/nanonet.git"
	$nanonet_cwd = "${install_path}/nanonet"

	exec { 'nanonet-download':
		require => Class['common'],
		command => "git clone ${git_repo} ${nanonet_cwd} &&\
			    chown -R vagrant:vagrant ${nanonet_cwd}",
	}
}

