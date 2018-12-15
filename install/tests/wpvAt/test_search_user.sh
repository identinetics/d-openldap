#!/bin/bash

ldapsearch -h localhost -p $SLAPDPORT -x -D cn=admin,dc=at -w $ROOTPW -b dc=at -L 'uid=test.user4_berta,dc=wpv,dc=at'

#ldapsearch -h localhost -p $SLAPDPORT -x -D cn=admin,dc=at -w $ROOTPW -b dc=at -L 'uid=test.user1234567'
# ldapmodify -h localhost -p $SLAPDPORT -x -D cn=admin,dc=at -w $ROOTPW -f /tmp/x.ldif

