#!/usr/bin/python3

import os
from ldap3 import Server, Connection, ALL, LDIF, MODIFY_REPLACE

# variables
rootpw = os.environ['ROOTPW'] if 'ROOTPW' in os.environ else 'changeit'
port = os.environ['SLAPDPORT'] if 'SLAPDPORT' in os.environ else '8389'
host = 'localhost:' + port
rootdn = 'dc=at'
admindn = 'cn=admin,dc=at'
userdn = 'uid=test.user1234567,dc=wpv,dc=at'
testpw = 'test'

print('connecting as ' + admindn)
s = Server(host, get_info=ALL)
conn1 = Connection(s, admindn, rootpw, auto_bind=True, raise_exceptions=True)

print('search testusers ')
conn1.search('dc=wpv,dc=at', '(uid=*)')
print(conn1.entries)

print('change password for ' + userdn)
conn1.modify(userdn, {'userPassword': [(MODIFY_REPLACE, ['newpass'])]})

print('connecting as ' + userdn)
conn2 = Connection(s, userdn, 'newpass', auto_bind=True, raise_exceptions=True)
conn2.search('dc=at', '(uid=tester@testinetics.at)')
assert len(conn2.entries) == 1
