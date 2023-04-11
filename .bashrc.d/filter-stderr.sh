
# Usage:
#   filter-stderr cmd_to_run arg1 arg2 ... --- stderr_filter_cmd arg1 arg2 ...
#
# If '---' somehow conflicts with an actual arg you need to pass to cmd_to_run or stderr_filter,
# then set $FILTER_STDERR_DELIM to the delimiter that you'd like to use.
#
# Simple test cases:
#   $ filter-stderr stdouterr-test --- sed 's/e/E/g' ; echo -ne '\n---\n\n' ; filter-stderr stdouterr-test --- sed 's/e/E/g' 2>/dev/null ; echo -ne '\n---\n\n' ; filter-stderr stdouterr-test --- sed 's/e/E/g' 1>/dev/null
#   $ ( FILTER_STDERR_DELIM='===' ; filter-stderr stdouterr-test === sed 's/e/E/g' ; echo -ne '\n---\n\n' ; filter-stderr stdouterr-test === sed 's/e/E/g' 2>/dev/null ; echo -ne '\n---\n\n' ; filter-stderr stdouterr-test === sed 's/e/E/g' 1>/dev/null ; )
#
# Expected output in both cases:
#
#   this is stdout
#   this is stdErr
#   
#   ---
#   
#   this is stdout
#   
#   ---
#   
#   this is stdErr


function filter-stderr {
	local delim="${FILTER_STDERR_DELIM:----}"
	local -a cmd
	local -a filter
	local i
	local target=cmd
	for i; do
		case "$i" in
			"$delim")
				target="filter"
				;;
			*)
				# FIXME: there's a better way to do this. oh well.
				eval local -a "$target"'+=("$i")'
				;;
		esac
	done
	#declare -p cmd filter
	# it might be possible to use just tmp, ie. not need both tmp and tmp2.
	# but having both doesn't hurt, and means i can avoid having to think about it.
	local tmp tmp2
	( "${cmd[@]}"  {tmp}>&1 1>&2 2>&$tmp {tmp}>&- | "${filter[@]}" ) {tmp2}>&1 >&2 2>&$tmp2 {tmp2}>&-
}
export -f filter-stderr

function stdouterr-test {
	echo this is stdout
	echo this is stderr 1>&2
}
export -f stdouterr-test

