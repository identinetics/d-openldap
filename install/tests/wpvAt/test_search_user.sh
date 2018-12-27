#!/bin/bash -e

echo 'searching user uid=test.user4_berta'

ldapsearch -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -b dc=at -L 'uid=test.user4_berta' >/dev/null  || rc=$?
    if ((rc != 0)) && ((rc != 68)); then
        echo "ldapsearch failed with code=${rc}"
        exit $rc
    fi
