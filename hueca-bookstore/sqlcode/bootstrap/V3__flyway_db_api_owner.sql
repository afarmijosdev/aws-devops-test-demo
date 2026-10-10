-- Adds the db_api login as an owner of the flyway database (db_sa owns it
-- already, since it created it). Runs in the flyway database, after V1.

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'db_api')
    CREATE USER db_api FOR LOGIN db_api;

ALTER ROLE db_owner ADD MEMBER db_api;
