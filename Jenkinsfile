pipeline {
    agent any
    environment {
        compose_cfg='docker-compose.yaml'
        compose_f_opt=''
        d_containers='openldap dc_openldap_run_1'
        d_volumes='openldap_pv.etc_openldap openldap_pv.var_db'

    }
    options { disableConcurrentBuilds() }
    parameters {
        string(defaultValue: 'True', description: '"True": initial cleanup: remove container and volumes; otherwise leave empty', name: 'start_clean')
        string(description: '"True": "Set --nocache for docker build; otherwise leave empty', name: 'nocache')
        string(description: '"True": push docker image after build; otherwise leave empty', name: 'pushimage')
        string(description: '"True": keep running after test; otherwise leave empty to delete container and volumes', name: 'keep_running')
    }

    stages {
        stage('Config ') {
            steps {
                sh '''#!/bin/bash -e
                    echo "using ${compose_cfg} as docker-compose config file"
                    if [[ "$DOCKER_REGISTRY_USER" ]]; then
                        echo "  Docker registry user: $DOCKER_REGISTRY_USER"
                        ./dcshell/update_config.sh "${compose_cfg.default}" $compose_cfg
                    else
                        cp "${compose_cfg.default}" $compose_cfg
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
                    set_docker_artifact_names
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
                    [[ "$nocache" ]] && nocacheopt='-c' && echo 'build with option nocache'
                    docker-compose build $nocacheopt
                '''
            }
        }
        stage('Test: setup') {
            steps {
                sh '''#!/bin/bash -e
                    source ./jenkins_scripts.sh
                    set_docker_artifact_names
                    create_docker_network                
                    echo "initailize persistent data"
                    nottyopt=''; [[ -t 0 ]] || nottyopt='-T'  # autodetect tty
                    docker-compose run $nottyopt -p 'dc' --rm openldap_pv /tests/init_rootpw.sh
                    echo "start server"
                    export LOGLEVEL='conns,config,stats,shell'
                    docker-compose --no-ansi up -d openldap_pv
                    echo "server started"
                    sleep 2
                    docker container ls | grep openldap_pv | grep Restarting && \
                        echo "container restarting" && exit 1
                    docker container ls | grep openldap_pv
                '''
            }
        }
        stage('Test: run') {
            steps {
                sh '''#!/bin/bash -e
                    nottyopt=''; [[ -t 0 ]] || nottyopt='-T'  # autodetect tty
                    docker exec -i $nottyopt openldap_pv tests/gvAt/test_all.sh
                    docker exec -i $nottyopt openldap_pv tests/wpvAt/test_all.sh
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
                    docker-compose push
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