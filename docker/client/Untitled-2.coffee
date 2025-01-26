
[DEBUG] Incoming search request:
server.js:74 Filter: (&(cn=ssh)(ipServiceProtocol=tcp)(objectclass=ipService))
server.js:75 Attributes Requested: (5) ['objectClass', 'cn', 'ipServicePort', 'ipServiceProtocol', 'modifyTimestamp']
server.js:76 [DEBUG] Connection Bind DN: cn=anonymous
server.js:80 [DEBUG] Request Log ID: 127.0.0.1:61892::3
server.js:86 [ERROR] Invalid filter for extracting username
(anonymous) @ server.js:86
messageIIFE @ server.js:432
(anonymous) @ server.js:455
emit @ node:events:517
Parser.write @ parser.js:135
(anonymous) @ server.js:474
emit @ node:events:517
addChunk @ node:internal/streams/readable:335
readableAddChunk @ node:internal/streams/readable:308
Readable.push @ node:internal/streams/readable:245
onStreamRead @ node:internal/stream_base_commons:190
callbackTrampoline @ node:internal/async_hooks:130
TCPWRAP
init @ node:internal/inspector_async_hook:25
emitInitNative @ node:internal/async_hooks:202Understand this errorAI
server.js:73 
[DEBUG] Incoming search request:
server.js:74 Filter: (&(uid=ann)(objectclass=posixAccount)(uid=*)(&(uidNumber=*)(!(uidNumber=0))))
server.js:75 Attributes Requested: (34) ['objectClass', 'uid', 'userPassword', 'uidNumber', 'gidNumber', 'gecos', 'homeDirectory', 'loginShell', 'krbPrincipalName', 'cn', 'modifyTimestamp', 'modifyTimestamp', 'shadowLastChange', 'shadowMin', 'shadowMax', 'shadowWarning', 'shadowInactive', 'shadowExpire', 'shadowFlag', 'krbLastPwdChange', 'krbPasswordExpiration', 'pwdAttribute', 'authorizedService', 'accountExpires', 'userAccountControl', 'nsAccountLock', 'host', 'rhost', 'loginDisabled', 'loginExpirationTime', 'loginAllowedTimeMap', 'sshPublicKey', 'userCertificate;binary', 'mail']0: "objectClass"1: "uid"2: "userPassword"3: "uidNumber"4: "gidNumber"5: "gecos"6: "homeDirectory"7: "loginShell"8: "krbPrincipalName"9: "cn"10: "modifyTimestamp"11: "modifyTimestamp"12: "shadowLastChange"13: "shadowMin"14: "shadowMax"15: "shadowWarning"16: "shadowInactive"17: "shadowExpire"18: "shadowFlag"19: "krbLastPwdChange"20: "krbPasswordExpiration"21: "pwdAttribute"22: "authorizedService"23: "accountExpires"24: "userAccountControl"25: "nsAccountLock"26: "host"27: "rhost"28: "loginDisabled"29: "loginExpirationTime"30: "loginAllowedTimeMap"31: "sshPublicKey"32: "userCertificate;binary"33: "mail"length: 34[[Prototype]]: Array(0)
server.js:76 [DEBUG] Connection Bind DN: cn=anonymous
server.js:80 [DEBUG] Request Log ID: 127.0.0.1:61892::4
server.js:135 
[DEBUG] Responding with entry:
server.js:136 {
  "dn": "cn=ann,dc=mieweb,dc=com",
  "attributes": {
    "objectClass": [
      "posixAccount",
      "posixGroup",
      "inetOrgPerson",
      "shadowAccount"
    ],
    "test": "test",
    "uid": "ann",
    "uidNumber": "1001",
    "gidNumber": "1001",
    "cn": "Ann",
    "gecos": "Ann",
    "homeDirectory": "/home/ann",
    "loginShell": "/bin/bash",
    "shadowLastChange": "0",
    "userpassword": "{CRYPT}21c4474515c9869005f9de3f75c083eaf092bd9f8d5461c7c617f88a3fa32253e2abfbeda31a80b34fa38e374e4602d8b04db55f6e52e84c4bcf59fe9a585eb1"
  }
}