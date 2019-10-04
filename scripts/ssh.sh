remotes=( cloud-master cloud-node1 cloud-node2 )
vol=/mnt/kube/hyperledger/shared

function ssh_copy() {
    i=0

    while [ "${remotes[$i]}" != "" ]
    do
        remote=${remotes[$i]}
        ssh $remote -C "rm -rf $vol && mkdir -p $vol"
        scp -r artifacts $remote:$vol/
        ((i++))
    done

}

function ssh_main() {
    ssh_cmd=ssh_$1
    $ssh_cmd
    status=`echo $?`

    if [ "$status" != "0" ]
    then
        ssh_usage
    fi
}

function ssh_usage() {
    echo "ssh usage"
}

