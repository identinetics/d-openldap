#!/bin/sh

ldapadd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -f /tests/gvAt/data/initial_data.ldif

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' \
    'gvGid=AT:B:1:12345,ou=people,gvOuId=AT:TEST:1,dc=gv,dc=at'

