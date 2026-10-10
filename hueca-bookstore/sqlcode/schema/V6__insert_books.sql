-- Seeds the books that were hardcoded in be-inventory.
-- Rows whose id already exists in hueca_bookstore.books are skipped.

INSERT INTO hueca_bookstore.books (id, title, author, price, stock, available)
SELECT v.id, v.title, v.author, v.price, v.stock, v.available
FROM (VALUES
    (4, N'Encebollado',              N'Corozo',      30.00, 10, 2),
    (5, N'Cazuela',                            N'Tere', 20.00,  15, 5),
    (6, N'Bolón',                               N'Rosa',  15.00,  20, 10),
    (7, N'Bolón de verde con queso',            N'Rosa',  15.00,  20, 10),
    (8, N'Bolón de verde con chicharrón',       N'Rosa',  15.00,  20, 10),
    (9, N'Bolón de verde con camarón',          N'Rosa',  15.00,  20, 10),
    (10,N'Bolón de verde con atún',             N'Rosa',  15.00,  20, 10)
) AS v (id, title, author, price, stock, available)
WHERE NOT EXISTS (
    SELECT 1 FROM hueca_bookstore.books AS b WHERE b.id = v.id
);
