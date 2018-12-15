#!/bin/sh

ldapadd -h localhost -p $SLAPDPORT -c \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -f /tests/gvAt/data/gvUserportal.ldif
