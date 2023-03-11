-- CREATE DATABASE sales;

CREATE TABLE  sales (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date_created DATE DEFAULT (CURRENT_DATE),
    date_fulfilled DATE,
    customer_name VARCHAR(300) NOT NULL,
    product_name VARCHAR(300) NOT NULL,
    volume NUMERIC(10,3) NOT NULL CHECK ( volume > 0 ),
    is_recurring BOOLEAN DEFAULT FALSE,
    is_disputed BOOLEAN DEFAULT FALSE
);

-- Insertar único registro
INSERT INTO sales (customer_name, product_name, volume, is_recurring)
VALUES ('Julián Rodríguez', 'Leche Colanta', 5000, true);

-- Insertar múltiples registros
INSERT INTO sales (date_fulfilled, customer_name, product_name, volume, is_recurring, is_disputed)
VALUES (NULL,'Colanta', 'Queso Colanta', 4500, false, false),
       ('2022-04-10', 'Aapina', 'Yogurt Alpina', 1500.10, false, true);

-- Actualización de información
UPDATE sales
SET
    product_name = 'A Truck',
    volume = volume * 1000
WHERE id = 13;

-- Eliminar data
DELETE FROM sales
WHERE id = 13;

-- Selecionar o consultar data
SELECT * FROM sales;

SELECT 'Hello Wolrd', date_created, customer_name, product_name, volume/1000 AS total_Sales
FROM sales;

SELECT * FROM sales
WHERE volume >= 1000;

SELECT * FROM sales
WHERE is_recurring IS true;

SELECT * FROM  sales
WHERE (is_disputed IS true) AND (volume > 4000);

SELECT * FROM  sales
WHERE (is_disputed IS true) OR (volume > 4000);

SELECT * FROM sales
WHERE date_created > '2021-11-01' AND date_created < '2022-11-01';

SELECT * FROM sales
WHERE date_created BETWEEN '2021-11-01' AND '2022-11-01';

SELECT * FROM sales
WHERE volume > 3000 AND volume < 100000;

SELECT * FROM sales
WHERE customer_name = 'Max Schwarz';

SELECT * FROM  sales
WHERE date_fulfilled IS NOT NULL;

SELECT * FROM  sales
WHERE date_fulfilled - sales.date_created <= 5;

-- Método usado en caso que se tenga la fecha en formato que ingcluye tiempo (horas, minutos)
SELECT * FROM  sales
WHERE EXTRACT(DAY FROM date_fulfilled - sales.date_created) <= 5;

-- Selección, búsqueda y ordenamiento de data
SELECT * FROM sales
ORDER BY volume;

SELECT * FROM sales
ORDER BY volume DESC;

SELECT * FROM sales
ORDER BY volume
LIMIT 10;

SELECT * FROM sales
WHERE is_disputed IS false
ORDER BY volume DESC
LIMIT 3;

SELECT * FROM sales
ORDER BY volume
LIMIT 5
OFFSET 5;

SELECT DISTINCT customer_name FROM sales
ORDER BY customer_name;

-- Subqueries
SELECT customer_name, product_name
FROM (SELECT * FROM sales
WHERE volume > 1000 ) AS  base_result;

CREATE VIEW base_result AS SELECT * FROM sales
WHERE volume > 1000;

SELECT customer_name, product_name
FROM (base_result);