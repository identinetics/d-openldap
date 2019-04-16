#!/bin/sh -e

echo "set user passwords (wpv)"

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' \
    'uid=tester@testinetics.at,gln=9110017333914,dc=wpv,dc=at' \
    || (echo 'ldappasswd failed'; exit 2)

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' 'uid=test.user1234567,dc=wpv,dc=at' \
    || (echo 'ldappasswd failed'; exit 3)

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' 'uid=test.user2_adam,dc=wpv,dc=at' \
    || (echo 'ldappasswd failed'; exit 4)

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' 'uid=test.user3_eva,dc=wpv,dc=at' \
    || (echo 'ldappasswd failed'; exit 5)

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' 'uid=test.user4_berta,dc=wpv,dc=at' \
    || (echo 'ldappasswd failed'; exit 6)

ldappasswd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -s 'test' 'uid=wkisredirect@testinetics.at,gln=9110017333914,dc=wpv,dc=at' \
    || (echo 'ldappasswd failed'; exit 6)
