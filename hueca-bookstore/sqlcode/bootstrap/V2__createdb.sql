-- Creates the hueca_bookstore database and makes the db_api login an owner of it.
-- Run against the flyway database as the RDS master login (db_sa), after V1 creates the db_api login.
--
-- db_sa owns the database (it creates it). RDS doesn't let the master login hand
-- ownership to another login (ALTER AUTHORIZATION), so db_api joins db_owner instead.
-- Safe to re-run: every step checks first.

IF DB_ID(N'hueca_bookstore') IS NULL
    CREATE DATABASE hueca_bookstore;

-- The connection is in the flyway database; USE inside EXEC switches to
-- hueca_bookstore for that batch only.
EXEC (N'
USE hueca_bookstore;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N''db_api'')
    CREATE USER db_api FOR LOGIN db_api;

ALTER ROLE db_owner ADD MEMBER db_api;
');
