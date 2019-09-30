source scripts/*.sh

function usage() {
    echo "usage"
}



function all_main() {
    k8s_all
}

function main() {
    cmd=$1_main
    shift

    $cmd $@
    status=`echo $?`

    if [ "$status" != "0" ]
    then
        usage
    fi
}

main $@
