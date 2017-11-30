

class nanonet (
	String $clone_path = '/tmp',
	String $install_path = '/home/vagrant',
	String $user = 'vagrant'
) {
	$git_repo = "https://github.com/segment-routing/nanonet.git"
	$nanonet_cwd = "${install_path}/nanonet"

	exec { 'nanonet-download':
		require => Class['common'],
		creates => $nanonet_cwd,
		command => "git clone ${git_repo} ${nanonet_cwd} &&\
			    chown -R ${user}:${user} ${nanonet_cwd}",
	}
}
