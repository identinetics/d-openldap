pipeline {
    agent any
    options { disableConcurrentBuilds() }
    parameters {
        string(defaultValue: 'True', description: '"True": initial cleanup: remove container and volumes; otherwise leave empty', name: 'start_clean')
        string(description: '"True": "Set --nocache for docker build; otherwise leave empty', name: 'nocache')
        string(description: '"True": push docker image after build; otherwise leave empty', name: 'pushimage')
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
                   head docker-compose.yaml
                '''
            }
        }
        stage('Cleanup ') {
            when {
                expression { params.$start_clean?.trim() != '' }
            }
            steps {
                sh '''
                    docker-compose down -v 2>/dev/null | true
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
        stage('Setup and Test') {
            steps {
                sh '''#!/bin/bash
                    source ./dcshell/dcshell_lib.sh
                    echo "initailize persistent data"
                    docker volume create --name=openldap_pv.etc_openldap
                    docker volume create --name=openldap_pv.var_db
                    docker volume create --name=openldap_pv.var_log
                    docker-compose run -T --rm openldap_pv /tests/init_rootpw.sh
                    echo "start server"
                    docker-compose up -d openldap_pv
                    sleep 2
                    docker-compose logs openldap_pv
                    docker-compose exec -T openldap_pv /tests/init_sample_data_gvAt.sh
                    docker-compose exec -T openldap_pv /tests/init_sample_data_wpvAT.sh
                    docker-compose exec -T openldap_pv /tests/auth_testuser.sh
                    docker-compose exec -T openldap_pv /tests/dump_testuser.sh
                    docker-compose exec -T openldap_pv python /tests/test.py
                    docker-compose exec -T openldap_pv python /tests/test1.py
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
                    ./dcshell/build -f dc.yaml -P
                '''
            }
        }
    }
    post {
        always {
            sh '''
                echo 'Remove container, volumes'
                docker-compose -f dc.yaml rm --force -v 2>/dev/null || true
                docker rm --force -v shibsp 2>/dev/null || true  # in case docker-compose fails ..
            '''
        }
    }
}