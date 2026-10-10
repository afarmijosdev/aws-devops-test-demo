-- Creates the hueca_bookstore database and makes the db_api login its owner.
-- Run against the flyway database as the RDS master login (db_sa), after V1 creates the db_api login.

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'db_api')
    THROW 50001, N'Login db_api does not exist. Create it before running this script.', 1;

IF DB_ID(N'hueca_bookstore') IS NULL
    CREATE DATABASE hueca_bookstore;

ALTER AUTHORIZATION ON DATABASE::hueca_bookstore TO db_api;
