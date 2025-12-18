INSERT INTO orders (order_code, comment, created_at)
VALUES
  ('O001', 'very first order!', NOW()),
  ('O002', 'second order', NOW()),
  ('N042', 'legacy order', '2024-12-12');

SELECT 'Querying 2023 partition...' AS message;
SELECT * FROM orders_y2023
ORDER BY created_at ASC;

SELECT 'Querying 2024 partition...' AS message;
SELECT * FROM orders_y2024
ORDER BY created_at ASC;

SELECT 'Querying 2025 partition...' AS message;
SELECT * FROM orders_y2025
ORDER BY created_at ASC;

SELECT 'Querying the whole table...' AS message;
SELECT * FROM orders
ORDER BY created_at ASC;
