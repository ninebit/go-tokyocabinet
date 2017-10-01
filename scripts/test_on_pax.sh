#!/usr/bin/env bash
#TT:Sat 30 Sep 2017 10:49:52 PM PDT
# This script allows for testing on PaX enabled hardened systems
#

host_is_pax() {
	grep -qs ^PaX: /proc/self/status
}

getPaxctl() {
	local p

	# These are the paths on Gentoo systems
	for p in '/usr/sbin/paxctl-ng' '/sbin/paxctl'; do
		if [[ -x "${p}" ]]; then
			echo "${p}"
			return
		fi
	done

	echo "[FATAL] Could not determine paxctl binary"
	exit 1
}

main() {
	if host_is_pax; then
		local p=$(getPaxctl)
		if (( rc=$? )); then
			echo "${p}"
			exit ${rc}
		fi

		go test -exec 'sh -c "f=$0; sudo '"${p}"' -m $f; $f"'
	else
		go test
	fi
}

main
