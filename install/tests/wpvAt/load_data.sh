#!/bin/sh -e

echo "load initial data (wpv)"

ldapadd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -f /tests/data/initial_data_dcat.ldif \
    || true  # may be added by gvAt tests


ldapadd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -f /tests/wpvAt/data/initial_data.ldif  -c || rc=$?
    if ((rc != 0)) && ((rc != 68)); then
        echo "ldapadd failed with code=${rc}"
        exit $rc
    fi



