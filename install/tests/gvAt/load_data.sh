#!/bin/sh -e

echo "load initial data (gvAt)"

ldapadd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -f /tests/data/initial_data_dcat.ldif \
    || true  # may be added by gvAt tests

ldapadd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -f /tests/gvAt/data/initial_data.ldif -c || rc=$?
    if ((rc != 0)) && ((rc != 68)); then
        echo "ldapadd failed with code=${rc}"
        exit $rc
    fi

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' \
    'gvGid=AT:B:1:12345,ou=people,gvOuId=AT:TEST:1,dc=gv,dc=at' || rc=$?
if ((rc != 0)); then
    echo "ldappasswd failed with code=${rc}"
    exit $rc
fi


