#!/bin/sh

echo "loading /etc/openldap with sample data "

ldapadd -h localhost -p $SLAPDPORT \
    -x -D cn=admin,dc=at -w $ROOTPW \
    -f /opt/sample_data/etc/openldap/data/gvAt_init.ldif
