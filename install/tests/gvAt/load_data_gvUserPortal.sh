#!/bin/sh -e

ldapadd -h localhost -p $SLAPDPORT -c \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -f /tests/gvAt/data/gvUserportal.ldif -c || rc=$?
    if ((rc != 0)) && ((rc != 68)); then
        echo "ldapadd failed with code=${rc}"
        exit $rc
    fi
