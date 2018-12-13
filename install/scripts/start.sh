#!/usr/bin/env bash

# add SLAPDHOST to /etc/hosts
[ -z $SLAPDHOST ] && echo 'SLAPDHOST not set' && exit 1
cp /etc/hosts /tmp/hosts
sed -e "s/$HOSTNAME\$/$HOSTNAME $SLAPDHOST/" /tmp/hosts > /etc/hosts

su - ldap -c "slapd -4 -h ldap://$SLAPDHOST:$SLAPDPORT/ -d conns,config,stats,shell,trace -f /etc/openldap/slapd.conf"
