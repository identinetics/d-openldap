#!/bin/sh

echo 'initialize slapd.conf with edushareAt schema'

mv /etc/openldap/slapd.conf /etc/openldap/slapd.conf.default
mv /etc/openldap/slapd_edushareAt_example.conf /etc/openldap/slapd.conf


if [ $(grep -q '^rootpw' /etc/openldap/slapd.conf) ]; then
    echo "rootpw directive already set in slapd.conf"
else
    slappasswd -s $ROOTPW > /tmp/rootpw
    printf "\nrootpw $(cat /tmp/rootpw)" >> /etc/openldap/slapd.conf
    rm -f /tmp/rootpw
    echo "rootpw directive added to slapd.conf"
fi

