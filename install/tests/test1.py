import os
from ldap3 import Server, Connection, ALL, LDIF, MODIFY_REPLACE

# variables
rootpw = os.environ['ROOTPW'] if 'ROOTPW' in os.environ else 'changeit'
port = os.environ['SLAPDPORT'] if 'SLAPDPORT' in os.environ else '8389'
host = 'localhost:' + port
rootdn = 'dc=at'
admindn = 'cn=admin,dc=at'
userdn = 'cn=test.user1234567, o=ph-noe, dc=ac, dc=at'
testpw = 'test'

print('connecting as ' + admindn)
s = Server(host, get_info=ALL)
conn1 = Connection(s, admindn, rootpw, auto_bind=True, raise_exceptions=True)

print('dump_testuser search')
conn1.search('dc=at', '(objectclass=*)')
print(conn1.entries)

print('change password')
conn1.modify(userdn, {'userPassword': [(MODIFY_REPLACE, ['newpass'])]})

print('connecting as ' + userdn)
conn2 = Connection(s, userdn, 'newpass', auto_bind=True, raise_exceptions=True)
conn2.search('dc=at', '(cn=*)')
print(conn2.entries)
