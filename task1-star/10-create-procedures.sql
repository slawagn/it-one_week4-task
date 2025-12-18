CREATE OR REPLACE PROCEDURE add_customer(
  name TEXT,
  email TEXT,
  phone TEXT
)
LANGUAGE sql
BEGIN ATOMIC
  INSERT INTO customers_dim (name, email, phone, valid_until)
  VALUES 
    (name, email, phone, NULL);
END;

CREATE OR REPLACE PROCEDURE update_customer(
  id INTEGER,
  name TEXT,
  email TEXT,
  phone TEXT
)
LANGUAGE sql
BEGIN ATOMIC
  UPDATE customers_dim
  SET valid_until = NOW()
  WHERE customers_dim.customer_id = id AND customers_dim.valid_until IS NULL;

  INSERT INTO customers_dim (customer_id, name, email, phone, valid_until)
  VALUES 
    (id, name, email, phone, NULL);
END;

CREATE OR REPLACE FUNCTION view_actual_customer_data()
RETURNS TABLE (
  customer_id INTEGER,
  name VARCHAR,
  email VARCHAR,
  phone VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT
      customers_dim.customer_id,
      customers_dim.name,
      customers_dim.email,
      customers_dim.phone
    FROM customers_dim
    WHERE valid_until IS NULL
    ORDER BY customer_id;
END
$$;

CREATE OR REPLACE FUNCTION view_change_history_for_customer(
  id INTEGER
)
RETURNS TABLE (
  customer_id INTEGER,
  name VARCHAR,
  email VARCHAR,
  phone VARCHAR,
  valid_until DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT
      customers_dim.customer_id,
      customers_dim.name,
      customers_dim.email,
      customers_dim.phone,
      customers_dim.valid_until
    FROM customers_dim
    WHERE customers_dim.customer_id = id
    ORDER BY valid_until;
END
$$;



CREATE OR REPLACE PROCEDURE add_product(
  product_name TEXT,
  category TEXT
)
LANGUAGE sql
BEGIN ATOMIC
  INSERT INTO products_dim (product_name, category, valid_until)
  VALUES 
    (product_name, category, NULL);
END;

CREATE OR REPLACE PROCEDURE update_product(
  id INTEGER,
  product_name TEXT,
  category TEXT
)
LANGUAGE sql
BEGIN ATOMIC
  UPDATE products_dim
  SET valid_until = NOW()
  WHERE products_dim.product_id = id AND products_dim.valid_until IS NULL;

  INSERT INTO products_dim (product_id, product_name, category, valid_until)
  VALUES 
    (id, product_name, category, NULL);
END;

CREATE OR REPLACE FUNCTION view_actual_product_data()
RETURNS TABLE (
  product_id INTEGER,
  product_name VARCHAR,
  category VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT
      products_dim.product_id,
      products_dim.product_name,
      products_dim.category
    FROM products_dim
    WHERE valid_until IS NULL
    ORDER BY product_id;
END
$$;

CREATE OR REPLACE FUNCTION view_change_history_for_product(
  id INTEGER
)
RETURNS TABLE (
  product_id INTEGER,
  product_name VARCHAR,
  category VARCHAR,
  valid_until DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT
      products_dim.product_id,
      products_dim.product_name,
      products_dim.category,
      products_dim.valid_until
    FROM products_dim
    WHERE products_dim.product_id = id
    ORDER BY valid_until;
END
$$;


CREATE OR REPLACE PROCEDURE add_sale_fact(
  customer_id INTEGER,
  product_id INTEGER,
  amount DECIMAL,
  quantity INTEGER
)
LANGUAGE sql
BEGIN ATOMIC
  INSERT INTO sales_fact (
    customer_id,
    product_id,
    sale_date,
    amount,
    quantity
  )
  VALUES 
    (
      customer_id,
      product_id,
      NOW(),
      amount,
      quantity
    );
END;

CREATE OR REPLACE FUNCTION view_sales_data()
RETURNS TABLE (
  sale_id INTEGER,
  name VARCHAR,
  email VARCHAR,
  phone VARCHAR,
  product_name VARCHAR,
  category VARCHAR,
  sale_date DATE,
  amount DECIMAL,
  quantity INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT
      sales_fact.sale_id,
      customers_dim.name, customers_dim.email, customers_dim.phone,
      products_dim.product_name, products_dim.category,
      sales_fact.sale_date, sales_fact.amount, sales_fact.quantity
    FROM sales_fact
      INNER JOIN products_dim
        ON sales_fact.product_id = products_dim.product_id
        AND products_dim.valid_until IS NULL
      INNER JOIN customers_dim
        ON sales_fact.customer_id = customers_dim.customer_id
        AND customers_dim.valid_until IS NULL
    ORDER BY sale_id;
END
$$;
