#!/bin/bash -e
#PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

run_test() {
    local exec=$1
    echo "starting ${exec}"
    $exec || local rc=$?
    rc_sum=$((rc_sum=rc_sum+rc))
    ((rc > 0)) && echo "${exec} failed"
}


/tests/wpvAt/load_data.sh
rc=$?
if ((rc != 0)); then
    echo "loading of wpv data failed, test aborted"
    exit 1
else
    echo "loading of wpv data completed"
fi

rc_sum=0

run_test "python3 /tests/wpvAt/test_load_users2-4.py"
run_test /tests/wpvAt/test_search_user.sh
run_test /tests/wpvAt/test_setpasswd.sh
run_test /tests/wpvAt/test_authn_user1-4.sh
run_test "python3 /tests/wpvAt/test_changepw.py"

exit $rc_sum
