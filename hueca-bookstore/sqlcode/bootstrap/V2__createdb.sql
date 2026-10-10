-- Creates the hueca_bookstore database and makes the db_api login its owner.
-- Run against the flyway database as the RDS master login (db_sa), after V1 creates the db_api login.

IF DB_ID(N'hueca_bookstore') IS NULL
    CREATE DATABASE hueca_bookstore;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'db_api')
    CREATE USER db_api FOR LOGIN db_api;

ALTER ROLE db_owner ADD MEMBER db_api;
