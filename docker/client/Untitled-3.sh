docker exec -it ldap_client /bin/bash



# Schema and Attribute Mapping (Directly from your LDAP JSON)
ldap_schema = rfc2307
ldap_user_object_class = inetOrgPerson
ldap_group_search_base = dc=mieweb,dc=com

# Attribute Mappings
ldap_user_name = uid               # Maps to "uid" in your JSON
ldap_user_uid_number = uidNumber   # Matches "uidNumber" in JSON
ldap_user_gid_number = gidNumber   # Matches "gidNumber" in JSON
ldap_user_home_directory = homeDirectory  # Matches "homeDirectory"
ldap_user_shell = loginShell       # Matches "loginShell"
ldap_user_password = userPassword  # Matches "userPassword"

# Required for posixAccount/SSSD
ldap_user_fullname = cn            # Maps to "cn" (Ann)
ldap_user_surname = sn             # Maps to "sn" (User)

# Performance
cache_credentials = true