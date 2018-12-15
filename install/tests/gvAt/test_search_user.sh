#!/bin/bash

ldapsearch -h localhost -p $SLAPDPORT -x -D cn=admin,dc=at -w $ROOTPW -b dc=at -L 'objectClass=gvOrgPerson'

# ldapmodify -h localhost -p $SLAPDPORT -x -D cn=admin,dc=at -w $ROOTPW -f /tmp/x.ldif

