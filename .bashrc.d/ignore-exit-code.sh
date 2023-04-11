
function ignore-exit-code {
    local ignore="$1"
    shift
    "$@" || { local rc=$?; if [ $rc -eq "$ignore" ]; then rc=0; fi; return $rc; }
}
export -f ignore-exit-code 

