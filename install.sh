#! /bin/bash
# vim: set tabstop=4 shiftwidth=4 noexpandtab filetype=sh:

# install.sh - a2cloud main installation script
#
# To the extent possible under law, T. Joseph Carter and Ivan Drucker have
# waived all copyright and related or neighboring rights to the a2cloud
# scripts themselves.  Software used or installed by these scripts is subject
# to other licenses.  This work is published from the United States.

a2cloudVersion="2.9.0"  # Leave this quoted!

noPicoPkg=

# Find the path of our source directory
a2cSource="$( dirname "${BASH_SOURCE[0]}" )"
pushd $a2cSource >/dev/null
a2cSource="$PWD"
popd >/dev/null
if [[ ! -f "$a2cSource/.a2cloud_source" ]]; then
	printf "\na2cloud: cannot find a2cloud source directory in $a2cSource.\n\n"
	exit 1
fi

process_args() {
	while [[ $1 ]]; do
		if [[ $1 == "-c" ]]; then
			shift
			noPicoPkg=1
		else
			shift
		fi
	done
}

process_args "$@"

# FIXME: Show version, changes, config, allow reconfig, etc…
"$a2cSource/scripts/show_changes"

# Run the legacy setup script for anything not yet ported
if [[ -e "${a2cSource}/setup/ivan.sh" ]]; then
	"${a2cSource}/setup/ivan.sh" "$@"
fi
