require("dotenv").config();

const ldap = require("ldapjs");
const mysql = require("mysql2/promise");
const crypto = require("crypto");

// MySQL connection configuration
const dbConfig = {
  host: process.env.MYSQL_HOST || "mysql",
  port: process.env.MYSQL_PORT || 3306,
  user: process.env.MYSQL_USER || "root",
  password: process.env.MYSQL_PASSWORD || "",
  database: process.env.MYSQL_DATABASE || "ldap_user_db",
};

function hashPassword(password, salt) {
  return crypto.pbkdf2Sync(password, salt, 1000, 64, "sha512").toString("hex");
}

async function startLDAPServer() {
  try {
    const server = ldap.createServer();

    // Add POSIX schema definition
    server.use((req, res, next) => {
      if (req instanceof ldap.SearchRequest && req.baseObject === "cn=schema") {
        res.send({
          dn: "cn=schema",
          attributes: {
            objectClasses: [
              // Define posixAccount as STRUCTURAL (not AUXILIARY)
              "( 1.3.6.1.1.1.2.0 NAME 'posixAccount' SUP top STRUCTURAL MUST ( uid $ uidNumber $ gidNumber $ homeDirectory ) MAY ( cn $ loginShell ) )",
              "( 2.16.840.1.113730.3.2.2 NAME 'inetOrgPerson' SUP organizationalPerson STRUCTURAL MUST ( sn $ cn ) MAY ( userPassword $ telephoneNumber $ seeAlso $ description ) )",
            ],
          },
        });
        res.end();
        return;
      }
      next();
    });

    // Bind handler
    server.bind(process.env.LDAP_BASE_DN, async (req, res, next) => {
      const bindDN = req.dn.toString();
      const password = req.credentials;

      try {
        const username = bindDN.split(",")[0].split("=")[1];
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute(
          "SELECT username, password, salt FROM users WHERE username = ?",
          [username]
        );
        await connection.end();

        if (
          rows.length === 0 ||
          hashPassword(password, rows[0].salt) !== rows[0].password
        ) {
          return next(
            new ldap.InvalidCredentialsError("Authentication failed")
          );
        }

        res.end();
        next();
      } catch (error) {
        console.error("Bind error:", error);
        next(new ldap.OperationsError("Server error"));
      }
    });

    // Search handler
    server.search(process.env.LDAP_BASE_DN, async (req, res, next) => {
      console.log(
        `[SEARCH] Base: ${req.baseObject}, Scope: ${req.scope}, Filter: ${req.filter}`
      );
      // User search handling
      const match = req.filter.toString().match(/\(uid=([^)]*)\)/);
      const username = match ? match[1] : null;

      if (!username) return res.end();

      console.log(`[SEARCH] Username: ${username}`);

      try {
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute(
          `SELECT * FROM users WHERE username = ?`,
          [username]
        );
        console.log(`[SEARCH] Rows: ${rows}`);
        await connection.end();

        if (rows.length === 0) return res.end();

        const user = rows[0];
        console.log(`[SEARCH] User: ${user}`);
        const entry = {
          dn: `uid=${user.username},ou=users,${process.env.LDAP_BASE_DN}`,
          attributes: {
            objectClass: [
              "top",
              "posixAccount",
              "inetOrgPerson",
              "shadowAccount",
            ],
            uid: [user.username],
            uidNumber: [user.uid_number.toString()], // Lowercase
            gidNumber: [user.gid_number.toString()], // Lowercase
            cn: [user.full_name || user.username],
            sn: [user.full_name?.split(" ")[1] || "User"],
            homeDirectory: [user.home_directory], // Lowercase
            loginShell: [user.login_shell || "/bin/bash"], // Lowercase,
            userPassword: [user.password], // Lowercase
          },
        };
        console.log(entry);

        res.send(entry);
        res.end();
      } catch (error) {
        console.error("Search error:", error);
        res.end();
      }
    });
    // Use non-privileged port for development
    const PORT = process.env.LDAP_PORT || 389;
    server.listen(PORT, "0.0.0.0", () => {
      console.log(`LDAP server running on port ${PORT}`);
    });
  } catch (error) {
    console.error("Server startup failed:", error);
    process.exit(1);
  }
}

startLDAPServer();
