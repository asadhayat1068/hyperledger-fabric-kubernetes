k8s_config_dir=./k8s-config

function k8s_nfs() {
    kubectl apply -f $k8s_config_dir/nfs-server.yaml
}

function k8s_docker() {
    kubectl apply -f $k8s_config_dir/docker-volume.yaml
    kubectl apply -f $k8s_config_dir/docker.yaml
}

function k8s_volumes() {
    kubectl apply -f $k8s_config_dir/create-volumes.yaml
}

function k8s_artifacts() {
    kubectl apply -f $k8s_config_dir/copy-artifacts.yaml
    pod=$(kubectl get pods --selector=job-name=copyartifacts --output=jsonpath={.items..metadata.name})

    podSTATUS=$(kubectl get pods --selector=job-name=copyartifacts --output=jsonpath={.items..phase})

    while [ "${podSTATUS}" != "Running" ]; do
        sleep 5;
        if [ "${podSTATUS}" == "Error" ]; then
            echo "There is an error in copyartifacts job. Please check logs."
            exit 1
        fi
        podSTATUS=$(kubectl get pods --selector=job-name=copyartifacts --output=jsonpath={.items..phase})
    done

    kubectl cp ./artifacts $pod:/shared/
}

function k8s_usage() {
    echo "k8s_usage"
}

function k8s_delete() {
    kubectl delete -f $k8s_config_dir/copy-artifacts.yaml
    kubectl delete -f $k8s_config_dir/create-volumes.yaml
    kubectl delete -f $k8s_config_dir/nfs-server.yaml
    kubectl delete -f $k8s_config_dir/docker.yaml
    kubectl delete -f $k8s_config_dir/docker-volume.yaml
    kubectl delete -f $k8s_config_dir/nfs-server.yaml
}

function k8s_all() {
    k8s_nfs
    k8s_docker
    k8s_volume
    k8s_artifacts
}

function k8s_main() {
    k8s_cmd=k8s_$1
    $k8s_cmd
    status=`echo $?`

    if [ "$status" != "0" ]
    then
        k8s_usage
    fi
}
