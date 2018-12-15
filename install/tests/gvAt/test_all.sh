#!/bin/bash

function exec_script() {
    printf "execute $1\n"
    $1
}


exec_script /tests/gvAt/load_data.sh
exec_script /tests/gvAt/test_search_user.sh
exec_script /tests/gvAt/test_authn.sh
exec_script /tests/gvAt/load_data_gvOrganisation.sh
exec_script /tests/gvAt/load_data_gvUserPortal.sh

