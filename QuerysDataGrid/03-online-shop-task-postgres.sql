
-- CREATE DATABASE online_shop;

DROp TABLE products;

CREATE TABLE products (
    product_name VARCHAR(300) NOT NULL,
    price NUMERIC NOT NULL,
    description TEXT,
    amount_in_stock INT CHECK ( amount_in_stock >= 0 ),
    image VARCHAR(500)
);

INSERT INTO products (product_name, price, description, amount_in_stock, image)
VALUES ('Leche Colanta', 3900, 'Leche Colanta por litro', 0, 'http://urlimage.com/25');

ALTER TABLE products
ADD CONSTRAINT price_is_positive check ( price > 0 );

ALTER TABLE  products
ADD COLUMN id SERIAL PRIMARY KEY;

ALTER TABLE  products
RENAME COLUMN image TO image_path;

SELECT * FROM products;