#!//bin/bash

set -e

prgnam=""
local_version=""
latest_version=""
latest_release=""
latest_release_url=""

dirname="$(basename "$(pwd)")"

output="$(pwd)"
#os_release="$(grep -oP 'platform:\K.*' < /etc/os-release | tr -d '"')"

source "$dirname".info && ret="$?"
if [ "$ret" -ne 0 ]; then
    printf "Error sourcing %s.\n" "$dirname"
    exit 1
fi

update() {

	cd "$output"
	wget "$latest_release_url" || printf "Error downloading %s.\n" "$latest_release" && exit 1
    printf "Done.\n"
}	

prompt() {
	printf "Update %s from %s to %s? " "$prgnam" "$local_version" "$latest_version"
	read -rp "[yN] " confirm
	
	case "$confirm" in
		[Yy]* )
			update
			;;
		* )
			exit 0
			;;
	esac
}
if [ "$local_version" -eq "$latest_version" ]; then
	prompt
else
	printf "%s is at latest version %s.\n" "$prgnam" "$local_version"
fi

exit 0
