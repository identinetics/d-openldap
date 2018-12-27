#!/usr/bin/env bash


create_docker_network() {
    network_found=$(docker network ls  --format '{{.Name}}' --filter name=$network)
    if [[ ! "$network_found" ]]; then
        docker network create --driver bridge --subnet=10.1.2.0/24 \
            -o com.docker.network.bridge.name=br-$network $network
    fi
}


remove_container_if_not_running() {
    local status=$(docker container inspect -f '{{.State.Status}}' $container 2>/dev/null || echo '')
    if [[ "$status" ]]; then
        docker container rm -f $container >/dev/null 2>&1 || true # remove any stopped container
    fi
}


remove_containers() {
    for cont in $*; do
        container_found=$(docker container inspect -f '{{.Name}}' $cont || true)
        if [[ "$container_found" ]]; then
            docker container rm -f $container_found -v |  perl -pe 'chomp; print " removed\n"'
        fi
    done
}


remove_volumes() {
    for vol in $*; do
        volume_found=$(docker volume ls --format '{{.Name}}' --filter name=^$vol$)
        if [[ "$volume_found" ]]; then
            docker volume rm $vol && perl -pe 'chomp; print " removed\n"'
        fi
    done
}


wait_for_container_up() {
    [[ "$1" ]] && wait_max_seconds=$1 || wait_max_seconds=10
    local status=''
    until [[ "${status}" == 'running' ]] || (( wait_max_seconds == 0 )); do
        wait_max_seconds=$((wait_max_seconds-=1))
        printf '.'
        sleep 1
        status=$(docker container inspect -f '{{.State.Status}}' $container 2>/dev/null || echo '')
    done
    if [[ "${status}" == 'running' ]]; then
        echo "Container up"
        return 0
    else
        echo "Container not running, status=${status}\n"
        return 1
    fi
}


