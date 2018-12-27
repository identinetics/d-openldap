#!/bin/bash -e
#PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

run_test() {
    local exec=$1
    echo "starting ${exec}"
    $exec || local rc=$?
    rc_sum=$((rc_sum=rc_sum+rc))
    echo "${exec} completed with ${rc}"
}


/tests/gvAt/load_data.sh
rc=$?
if ((rc != 0)); then
    echo "loading of initial data failed, test aborted"
    exit 1
fi

rc_sum=0

run_test /tests/gvAt/test_search_user.sh
run_test /tests/gvAt/test_authn.sh
run_test /tests/gvAt/load_data_gvOrganisation.sh
run_test /tests/gvAt/load_data_gvUserPortal.sh

exit $rc_sum