-- Creation of DB, Tables and Data
CREATE DATABASE restaurants;

CREATE TABLE payment_methods
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(200)
);

CREATE TABLE tables
(
    id        SERIAL PRIMARY KEY,
    num_seats INT,
    category  VARCHAR(200)
);

CREATE TABLE bookings
(
    id            SERIAL PRIMARY KEY,
    booking_date  DATE          NOT NULL,
    num_guests    INT           NOT NULL,
    amount_billed NUMERIC(6, 2) NOT NULL,
    amount_tipped NUMERIC(6, 2),
    payment_id    INT,
    table_id      INT,
    FOREIGN KEY (payment_id) REFERENCES payment_methods (id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES tables (id) ON DELETE CASCADE
);

INSERT INTO payment_methods (name)
VALUES ('Cash'),
       ('Credit Card');

INSERT INTO tables (num_seats, category)
VALUES (2, 'small'),
       (2, 'small'),
       (4, 'medium'),
       (6, 'large'),
       (8, 'large');

INSERT INTO bookings (booking_date, num_guests, amount_billed, amount_tipped, payment_id, table_id)
VALUES ('2021-11-04', 2, 19.90, 0.10, 2, 1),
       ('2021-11-04', 1, 12.90, 0.00, 2, 2),
       ('2021-11-05', 2, 15.50, NULL, 1, 1),
       ('2021-11-05', 7, 113.40, 6.60, 1, 5),
       ('2021-11-05', 6, 140.90, 10.10, 1, 4),
       ('2021-11-05', 7, 98.60, 1.40, 1, 5),
       ('2021-11-05', 4, 60.50, 4.50, 2, 3),
       ('2021-11-06', 5, 86.10, 4.90, 2, 4),
       ('2021-11-06', 3, 49.70, 5.30, 2, 4),
       ('2021-11-06', 1, 15.90, 2.10, 1, 2),
       ('2021-11-06', 7, 242.60, 12.40, 1, 5),
       ('2021-11-06', 6, 180.00, 20.00, 1, 5),
       ('2021-11-06', 3, 38.70, 11.30, 2, 3),
       ('2021-11-06', 2, 25.60, 9.40, 1, 1),
       ('2021-11-06', 3, 60.50, 14.50, 1, 4),
       ('2021-11-07', 2, 26.40, 1.60, 2, 1),
       ('2021-11-07', 2, 35.50, 4.50, 2, 2),
       ('2021-11-07', 5, 101.90, NULL, 1, 4),
       ('2021-11-07', 6, 130.10, 10, 1, 5),
       ('2021-11-08', 2, 38.60, 0.40, 2, 2);

-- Aggregations functions
-- Aggregations functions
SELECT * FROM bookings;

SELECT COUNT(*) FROM bookings;
SELECT COUNT(booking_date) FROM bookings;
SELECT COUNT(amount_tipped) FROM bookings;
SELECT COUNT(DISTINCT booking_date) FROM bookings;

SELECT MAX(num_seats) FROM tables;
SELECT MIN(num_seats) FROM tables;
SELECT MAX(amount_billed) AS max_billed, MAX(amount_tipped) AS max_tipped FROM bookings;
SELECT MIN(booking_date), MAX(booking_date) FROM bookings;

SELECT SUM(amount_billed) FROM bookings;
SELECT ROUND(AVG(amount_tipped), 2) FROM bookings;

SELECT ROUND(AVG(amount_tipped), 2) FROM bookings
WHERE amount_billed > 20 AND num_guests > 2;

SELECT MAX(num_guests), MAX(num_seats) FROM bookings AS b
INNER JOIN tables t on b.table_id = t.id;

SELECT MAX(num_guests), MAX(num_seats) FROM bookings AS b
INNER JOIN tables t on b.table_id = t.id
INNER JOIN payment_methods pm on b.payment_id = pm.id
WHERE t.num_seats < 5 AND pm.name = 'Cash';

-- Uso de agrupadores para los resultados de los AggregateFunctions
SELECT booking_date AS date, SUM(num_guests)
FROM bookings
GROUP BY booking_date;

SELECT name, SUM(num_guests)
FROM payment_methods AS p
INNER JOIN bookings b on p.id = b.payment_id
GROUP BY name;

SELECT name, booking_date, SUM(num_guests), ROUND(AVG(amount_tipped), 2)
FROM payment_methods AS p
INNER JOIN bookings b on p.id = b.payment_id
GROUP BY name, booking_date;

SELECT booking_date, COUNT(booking_date)
FROM bookings
WHERE amount_billed > 30 -- Se puede aplicar antes de del GROUP BY (Filtra la data antes de agruparla)
GROUP BY booking_date;

SELECT booking_date, COUNT(booking_date)
FROM bookings
GROUP BY booking_date
HAVING SUM(amount_billed) > 30; -- Este keyword se usa despues del GROUP BY (Filtra el resultado después de agruparlo)

-- Implementación de subqueries
SELECT MIN(daily_sum)
FROM (
    SELECT booking_date, SUM(amount_billed) AS daily_sum
    FROM bookings
    GROUP BY booking_date
) AS daily_table;

SELECT booking_date
FROM bookings
GROUP BY booking_date
HAVING SUM(amount_billed) = (
    SELECT MIN(daily_sum)
    FROM (
        SELECT booking_date, SUM(amount_billed) AS daily_sum
        FROM bookings
        GROUP BY booking_date
    ) AS daily_table
);

SELECT booking_date, amount_tipped, SUM(amount_tipped) OVER()
FROM bookings;

SELECT booking_date, amount_tipped, SUM(amount_tipped) OVER(PARTITION BY booking_date)
FROM bookings;

SELECT booking_date, amount_tipped, SUM(amount_tipped)
OVER(PARTITION BY booking_date ORDER BY amount_billed)
FROM bookings;

SELECT booking_date, amount_tipped, RANK()
OVER(PARTITION BY booking_date ORDER BY amount_tipped DESC)
FROM bookings;