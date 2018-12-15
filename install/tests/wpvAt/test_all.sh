#!/bin/bash

function exec_script() {
    printf "execute $1\n"
    $1
}


exec_script /tests/wpvAt/load_data.sh
exec_script /tests/wpvAt/test_search_user.sh
exec_script /tests/wpvAt/test_load_users2-4.py
exec_script /tests/wpvAt/test_authn_users1-4.sh
exec_script /tests/wpvAt/test_changepw.py
