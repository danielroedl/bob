#!/bin/bash -e
. ../test-lib.sh 2>/dev/null || { echo "Must run in script directory!" ; exit 1 ; }

# Run a simple PowerShell recipe. It also uses a minimal sandbox that mounts
# the full host. Just see if exeuction works even if $PATH is empty in the
# sandbox.

cleanup
type -p pwsh >/dev/null || skip

run_bob dev root
RES=$(run_bob query-path -f '{dist}' --develop root)
diff -u "$RES/file.txt" recipes/file.txt

# Run the sandbox check only if namespace feature works on this host.
if "${BOB_ROOT}/bin/bob-namespace-sandbox" -C ; then
	run_bob build root
	RES=$(run_bob query-path -f '{dist}' --release root)
	diff -u "$RES/file.txt" recipes/file.txt
fi
