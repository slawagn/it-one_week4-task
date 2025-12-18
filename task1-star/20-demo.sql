SELECT 'Populating db...' AS message;

CALL add_customer('John Smith', 'johnsmith@mail.com', '555-555-555');
CALL add_customer('Jane Smith', 'janesmith@mail.com', '555-555-666');

CALL add_product('QWERTY', 'Keyboards');
CALL add_product('dvorak', 'Keyboards');

CALL add_sale_fact(1, 1, 100.00, 1);
CALL add_sale_fact(2, 2, 100.00, 1);

SELECT * FROM view_actual_customer_data();
SELECT * FROM view_actual_product_data();
SELECT * FROM view_sales_data();



SELECT 'Making updates...' AS message;

CALL update_customer(1, 'John Doe', 'johnsmith@mail.com', '555-555-555');
CALL update_product(2, 'DVORAK', 'Keyboards');

SELECT * FROM view_sales_data();



SELECT 'Viewing actual data...' AS message;
SELECT * FROM view_actual_customer_data();
SELECT * FROM view_actual_product_data();
SELECT * FROM view_sales_data();



SELECT 'Viewing historic data...' AS message;

SELECT * FROM view_change_history_for_customer(1);
SELECT * FROM view_change_history_for_product(2);
