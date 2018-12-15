#!/bin/bash

# add SLAPDHOST to /etc/hosts
#[ -z $SLAPDHOST ] && echo 'SLAPDHOST not set' && exit 1
#cp /etc/hosts /tmp/hosts
#sed -e "s/$HOSTNAME\$/$HOSTNAME $SLAPDHOST/" /tmp/hosts > /etc/hosts

[[ $LOGLEVEL ]] && override_loglevel="-d $LOGLEVEL"
# override_loglevel='-d conns,config,stats,shell,trace'

cmd="slapd -4 -h ldap://$SLAPDHOST:$SLAPDPORT/ $override_loglevel -u ldap  -u ldap -f /etc/openldap/slapd.conf"
echo $cmd
$cmd
