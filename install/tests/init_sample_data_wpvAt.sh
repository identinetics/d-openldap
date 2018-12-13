#!/bin/sh

echo "loading /etc/openldap with sample data"

ldapadd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -c -f /opt/sample_data/etc/openldap/data/wpvAt_init.ldif


ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' \
    'uid=tester@testinetics.at, gln=9110017333914, dc=wpv, dc=at'

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' 'uid=test.user1234567, dc=wpv, dc=at'

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' 'uid=test.user2_adam, dc=wpv, dc=at'

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' 'uid=test.user3_eva, dc=wpv, dc=at'

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' 'uid=test.user4_berta, dc=wpv, dc=at'
