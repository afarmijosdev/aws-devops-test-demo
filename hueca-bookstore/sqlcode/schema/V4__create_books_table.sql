-- Creates the hueca_bookstore schema and the books table (same fields as the
-- Book model in be-inventory). Runs in the hueca_bookstore database as db_api.

IF SCHEMA_ID(N'hueca_bookstore') IS NULL
    EXEC (N'CREATE SCHEMA hueca_bookstore AUTHORIZATION dbo;');
GO

IF OBJECT_ID(N'hueca_bookstore.books', N'U') IS NULL
    CREATE TABLE hueca_bookstore.books (
        id        INT            NOT NULL CONSTRAINT PK_books PRIMARY KEY,
        title     NVARCHAR(255)  NOT NULL,
        author    NVARCHAR(255)  NOT NULL,
        price     DECIMAL(10, 2) NOT NULL,
        stock     INT            NOT NULL,
        available BIT            NOT NULL
    );
GO
