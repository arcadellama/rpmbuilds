#!/usr/bin bash

set -e

prgnam=$(basename "$(pwd)")

local_version=$("$prgnam" --version | grep -oP ': \K.*')
latest_version=$(curl -s \
	https://api.github.com/repos/trapexit/mergerfs/releases/latest \
	| grep -Po '"tag_name": "\K.*?(?=")' | sed -e 's/v//1')

update() {

	output="/tmp"
	os_release="$(cat /etc/os-release | grep -oP 'platform:\K.*' | tr -d '"')"
	latest_release="https://github.com/trapexit/mergerfs/releases/download/"$latest_version"/mergerfs-"$Iatest_version"-1."$os_release"."$(uname -m)".rpm"

	cd "$output"
	wget "$latest_rerease" || printf "Error downloading %s.\n" "$latest_release" && exit 1
	echo "Instal with 'sudo yum install $output/$prgnam-$latest_version-1.$os_release.$(uname -m).rpm"
}	

prompt() {
	printf "Update %s from %s to %s? " "$prgnam" "$local_version" "$latest_version"
	read -p "[yN] " confirm
	
	case "$confirm" in
		[Yy]* )
			update
			;;
		* )
			exit 0
			;;
	esac
}

if [ "$local_version" -ne "$latest_version" ]; then
	prompt
else
	printf "%s is at latest version %s.\n" "$prgnam" "$local_version"
fi

exit 0
