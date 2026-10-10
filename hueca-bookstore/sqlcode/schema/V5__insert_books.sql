-- Seeds the books that were hardcoded in be-inventory.
-- Rows whose id already exists in hueca_bookstore.books are skipped.

INSERT INTO hueca_bookstore.books (id, title, author, price, stock, available)
SELECT v.id, v.title, v.author, v.price, v.stock, v.available
FROM (VALUES
    (1, N'The Pragmatic Programmer',              N'Andrew Hunt',      49.99, 12, 1),
    (2, N'Clean Code',                            N'Robert C. Martin', 39.99,  8, 1),
    (3, N'Automate the Boring Stuff with Python', N'Al Sweigart',      29.99,  0, 0)
) AS v (id, title, author, price, stock, available)
WHERE NOT EXISTS (
    SELECT 1 FROM hueca_bookstore.books AS b WHERE b.id = v.id
);
