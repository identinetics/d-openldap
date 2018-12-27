#!/usr/bin/env bash


set_docker_artifact_names() {
    container='openldap'
    network='dfrontend'
    service='openldap'
    echo "container=$container, network=$network, service=$service"
}


create_docker_network() {
    network_found=$(docker network ls  --format '{{.Name}}' --filter name=$network)
    if [[ ! "$network_found" ]]; then
        docker network create --driver bridge --subnet=10.1.2.0/24 \
            -o com.docker.network.bridge.name=br-$network $network
    fi
}


remove_containers() {
    for cont in $*; do
        container_found=$(docker container ls --format '{{.Names}}' --filter name=$cont$)
        if [[ "$container_found" ]]; then
            docker container rm -f $container_found -v |  perl -pe 'chomp; print " removed\n"'
        fi
    done
}


remove_volumes() {
    for vol in $*; do
        volume_found=$(docker volume ls --format '{{.Name}}' --filter name=^$vol$)
        if [[ "$volume_found" ]]; then
            docker volume rm $vol |  perl -pe 'chomp; print " removed\n"'
        fi
    done
}

