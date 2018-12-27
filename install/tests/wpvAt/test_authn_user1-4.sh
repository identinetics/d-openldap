#!/bin/bash -e

echo "authenticate users"

ldapsearch -h localhost -p $SLAPDPORT -x -D uid=tester@testinetics.at,gln=9110017333914,dc=wpv,dc=at \
    -w test -b dc=at -L 'uid=tester@testinetics.at'  >/dev/null

ldapsearch -h localhost -p $SLAPDPORT -x -D uid=test.user2_adam,dc=wpv,dc=at \
    -w test -b dc=at -L 'uid=test.user2_adam'  >/dev/null

ldapsearch -h localhost -p $SLAPDPORT -x -D uid=test.user3_eva,dc=wpv,dc=at \
    -w test -b dc=at -L 'uid=test.user3_eva'  >/dev/null

ldapsearch -h localhost -p $SLAPDPORT -x -D uid=test.user4_berta,dc=wpv,dc=at \
    -w test -b dc=at -L 'uid=test.user4_berta'  >/dev/null


