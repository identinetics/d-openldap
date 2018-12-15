pipeline {
    agent any
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
                sh '''
                   if [[ "$DOCKER_REGISTRY_USER" ]]; then
                       echo "  Docker registry user: $DOCKER_REGISTRY_USER"
                       ./dcshell/update_config.sh docker-compose.yaml.default > docker-compose.yaml
                   else
                       cp docker-compose.yaml.default docker-compose.yaml
                   fi
                   head -6 docker-compose.yaml | tail -1
                '''
            }
        }
        stage('Cleanup ') {
            when {
                expression { params.$start_clean?.trim() != '' }
            }
            steps {
                sh '''#!/bin/bash -xv
                    source ./jenkins_scripts.sh
                    remove_containers
                    remove_volumes
                '''
            }
        }
        stage('Build') {
            steps {
                sh '''#!/bin/bash
                    [[ "$nocache" ]] && nocacheopt='-c' && echo 'build with option nocache'
                    docker-compose build $nocacheopt
                '''
            }
        }
        stage('Setup and Start') {
            steps {
                sh '''#!/bin/bash
                    echo "initailize persistent data"
                    docker volume create --name=openldap_pv.etc_openldap
                    docker volume create --name=openldap_pv.var_db
                    docker-compose run -T --rm openldap_pv /tests/init_rootpw.sh
                    echo "start server"
                    export LOGLEVEL='conns,config,stats,shell'
                    docker-compose up -d openldap_pv
                    echo "server started"
                    sleep 2
                    docker container ls | grep openldap_pv | grep Restarting && \
                        echo "container restarting" && exit 1
                    docker container ls | grep openldap_pv
                '''
            }
        }
        stage('Test') {
            steps {
                sh '''#!/bin/bash
                    ttyopt=''; [[ -t 0 ]] && ttyopt='-t'  # autodetect tty
                    docker exec -i $ttyopt openldap_pv tests/gvAt/test_all.sh
                    docker exec -i $ttyopt openldap_pv tests/wpvAt/test_all.sh
               '''
            }
        }
        stage('Push ') {
            when {
                expression { params.pushimage?.trim() != '' }
            }
            steps {
                sh '''
                    default_registry=$(docker info 2> /dev/null |egrep '^Registry' | awk '{print $2}')
                    echo "  Docker default registry: $default_registry"
                    docker-compose push
                '''
            }
        }
    }
    post {
        always {
            sh '''#!/bin/bash
                if [[ "$keep_running" ]]; then
                    echo "Keep container running"
                else
                    echo 'Remove container & volumes'
                    source ./jenkins_scripts.sh
                    remove_containers
                    remove_volumes
                fi
            '''
        }
    }
}