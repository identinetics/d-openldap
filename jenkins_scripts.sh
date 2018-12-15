#!/usr/bin/env bash -xv


remove_containers() {
    for cont in 'openldap_pv'; do
        container_found=$(docker container ls --format '{{.Names}} {{.Status}}' | grep $cont)
        if [[ "$container_found" ]]; then
            docker container rm -f $cont -v
        fi
    done
}


remove_volumes() {
    for vol in 'openldap_pv.etc_openldap' 'openldap_pv.var_db'; do
        volume_found=$(docker volume ls --format '{{.Name}}' | grep $vol)
        if [[ "$volume_found" ]]; then
            docker volume rm $vol
        fi
    done
}


create_network_dfrontend() {
    nw='dfrontend'
    network_found=$(docker network ls | grep $nw)
    if [[ ! "$network_found" ]]; then
        docker network create --driver bridge --subnet=10.1.2.0/24 \
            -o com.docker.network.bridge.name=br-$nw $nw
    fi
}
