pipeline {
    agent any
    environment {
        compose_cfg='docker-compose.yaml'
        compose_f_opt=''
        container='openldap_pv'
        d_containers="${container} dc_${container}_run_1"
        d_volumes="${container}.etc_openldap ${container}.var_db"
        network='dfrontend'
        service='openldap_pv'
        projopt='-p jenkins'
    }
    options { disableConcurrentBuilds() }
    parameters {
        string(defaultValue: 'True', description: '"True": initial cleanup: remove container and volumes; otherwise leave empty', name: 'start_clean')
        string(defaultValue: '', description: '"True": "Set --nocache for docker build; otherwise leave empty', name: 'nocache')
        string(defaultValue: '', description: '"True": push docker image after build; otherwise leave empty', name: 'pushimage')
        string(defaultValue: '', description: '"True": keep running after test; otherwise leave empty to delete container and volumes', name: 'keep_running')
    }

    stages {
        stage('Config ') {
            steps {
                sh '''#!/bin/bash -e
                    echo "using ${compose_cfg} as docker-compose config file"
                    if [[ "$DOCKER_REGISTRY_USER" ]]; then
                        echo "  Docker registry user: $DOCKER_REGISTRY_USER"
                        ./dcshell/update_config.sh "${compose_cfg}.default" $compose_cfg
                    else
                        cp "${compose_cfg}.default" $compose_cfg
                    fi
                    egrep '( image:| container_name:)' $compose_cfg || echo "missing keys in ${compose_cfg}"
                '''
            }
        }
        stage('Cleanup ') {
            when {
                expression { params.$start_clean?.trim() != '' }
            }
            steps {
                sh '''#!/bin/bash -e
                    source ./jenkins_scripts.sh
                    remove_containers $d_containers && echo '.'
                    remove_volumes $d_volumes && echo '.'
                '''
            }
        }
        stage('Build') {
            steps {
                sh '''#!/bin/bash -e
                    source ./jenkins_scripts.sh
                    remove_container_if_not_running
                    if [[ "$nocache" ]]; then
                         nocacheopt='--no-cache'
                         echo 'build with option nocache'
                    fi
                    docker-compose build $nocacheopt
                '''
            }
        }
        stage('Test: setup') {
            steps {
                sh '''#!/bin/bash -e
                    source ./jenkins_scripts.sh
                    create_docker_network
                    echo "initialize persistent data"
                    nottyopt=''; [[ -t 0 ]] || nottyopt='-T'  # autodetect tty
                    docker-compose $projop run $nottyopt --rm $service /tests/init_rootpw.sh
                    echo "Starting $service"
                    export LOGLEVEL='conns,config,stats,shell'
                    docker-compose $projop --no-ansi up -d
                    wait_for_container_up && echo "$service started"
                '''
            }
        }
        stage('Test: run') {
            steps {
                sh '''#!/bin/bash +e
                    ttyopt=''; [[ -t 0 ]] && ttyopt='-t'  # autodetect tty
                    # docker-compose not working here:
                    docker exec $ttyopt $container /tests/gvAt/test_all.sh
                    echo "'docker exec /tests/gvAt/test_all.sh' returned code=${rc}"
                    docker exec $ttyopt $container /tests/wpvAt/test_all.sh
                    echo "'docker exec /tests/wpvAt/test_all.sh' returned code=${rc}"
               '''
            }
        }
        stage('Push ') {
            when {
                expression { params.pushimage?.trim() != '' }
            }
            steps {
                sh '''#!/bin/bash -e
                    default_registry=$(docker info 2> /dev/null |egrep '^Registry' | awk '{print $2}')
                    echo "  Docker default registry: $default_registry"
                    docker-compose $projop push
                    rc=$?
                    ((rc>0)) && echo "'docker-compose push' failed with code=${rc}"
                    exit $rc
                '''
            }
        }
    }
    post {
        always {
            sh '''#!/bin/bash -e
                if [[ "$keep_running" ]]; then
                    echo "Keep container running"
                else
                    source ./jenkins_scripts.sh
                    remove_containers $d_containers && echo 'containers removed'
                    remove_volumes $d_volumes && echo 'volumes removed'
                fi
            '''
        }
    }
}