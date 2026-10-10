-- Creates the db_api SQL login used by the bookstore API.
-- Run against the master database as sysadmin.
-- ${db_api_password} is supplied by Flyway (FLYWAY_PLACEHOLDERS_DB_API_PASSWORD).

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'db_api')
    CREATE LOGIN db_api WITH PASSWORD = N'${db_api_password}';
