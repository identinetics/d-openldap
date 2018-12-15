#!/bin/bash -e

ldapsearch -h localhost -p $SLAPDPORT -x -D uid=tester@testinetics.at,gln=9110017333914,dc=wpv,dc=at \
    -w test -b dc=at -L 'uid=tester@testinetics.at'

ldapsearch -h localhost -p $SLAPDPORT -x -D uid=test.user2_adam,dc=wpv,dc=at \
    -w test -b dc=at -L 'uid=test.user2_adam'

ldapsearch -h localhost -p $SLAPDPORT -x -D uid=test.user3_eva,dc=wpv,dc=at \
    -w test -b dc=at -L 'uid=test.user3_eva'

ldapsearch -h localhost -p $SLAPDPORT -x -D uid=test.user4_berta,dc=wpv,dc=at \
    -w test -b dc=at -L 'uid=test.user4_berta'


