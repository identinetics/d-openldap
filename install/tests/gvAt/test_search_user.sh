#!/bin/bash
#PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

echo 'searching gvOrgPerson entries'

ldapsearch -h localhost -p $SLAPDPORT -x -D cn=admin,dc=at -w $ROOTPW -b dc=at -L 'objectClass=gvOrgPerson' >/dev/null \
    || rc=$?

if ((rc != 0)); then
    echo "ldapsearch failed with code=${rc}"
    exit $rc
fi

