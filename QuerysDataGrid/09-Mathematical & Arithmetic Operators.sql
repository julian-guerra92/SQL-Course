CREATE DATABASE gym;

CREATE TABLE memberships
(
    -- for mysql use this code
    -- id INT PRIMARY KEY AUTO_INCREMENT,
    -- for postgresql use this code
    id                SERIAL PRIMARY KEY,
    membership_start  DATE,
    membership_end    DATE,
    last_checkin      TIMESTAMP,
    last_checkout     TIMESTAMP,
    consumption       NUMERIC(5, 2),
    first_name        VARCHAR(200),
    last_name         VARCHAR(200),
    price             NUMERIC(5, 2),
    billing_frequency INT,
    gender            VARCHAR(200)
);

CREATE TABLE customers
(
    -- for mysql use this code
    -- id INT PRIMARY KEY AUTO_INCREMENT,
    -- for postgresql use this code
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(200),
    last_name  VARCHAR(200),
    email      VARCHAR(200)
);

CREATE TABLE orders
(
    -- for mysql use this code
    -- id INT PRIMARY KEY AUTO_INCREMENT,
    -- for postgresql use this code
    id            SERIAL PRIMARY KEY,
    amount_billed NUMERIC(5, 2),
    customer_id   INT REFERENCES customers
);

INSERT INTO memberships (membership_start,
                         membership_end,
                         last_checkin,
                         last_checkout,
                         consumption,
                         first_name,
                         last_name,
                         price,
                         billing_frequency,
                         gender)
VALUES ('2021-10-01',
        NULL,
        '2021-10-01 05:17:36',
        '2021-10-01 06:20:45',
        26.49,
        'Max',
        'Schwarz',
        19.99,
        12,
        'male'),
       ('2020-05-10',
        '2022-05-09',
        '2021-11-03 10:01:56',
        '2021-11-03 14:30:00',
        100.26,
        'Manu',
        'Lorenz',
        199.99,
        1,
        'male'),
       ('2021-02-18',
        '2022-02-17',
        '2021-10-29 15:26:05',
        '2021-10-29 17:01:33',
        5.10,
        'Julie',
        'Barnes',
        199.99,
        1,
        'female');

SELECT SUM(price * memberships.billing_frequency) AS annual_revenue
FROM memberships;

-- CEIL(): Redondea hacia arriba
SELECT CEIL(consumption)
FROM memberships;

-- FLOOR(): Redondea hacia abajo
SELECT FLOOR(consumption)
FROM memberships;

--ROUND(): Redondea al valor más cercano y se puede agregar otros argumentos
SELECT ROUND(consumption, 1)
FROM memberships;

-- TRUNC(): En mysql TRUNCATE(). Corta en el número decimal definido al ejecutar el query
SELECT TRUNC(consumption, 1)
FROM memberships;

SELECT CONCAT(first_name, ' ', last_name)
FROM memberships;

-- Operación disponible sólo en Postgres
SELECT first_name || ' ' || last_name
FROM memberships;

SELECT CONCAT('$ ', price)
FROM memberships;

-- Uso de operadores en el momento de ingresar data a la DB
INSERT INTO memberships (membership_start,
                         membership_end,
                         last_checkin,
                         last_checkout,
                         consumption,
                         first_name,
                         last_name,
                         price,
                         billing_frequency,
                         gender)
VALUES ('2021-10-18',
        '2021-11-18',
        '2021-11-01 08:56:01',
        '2021-11-01 09:20:12',
        NULL,
        'John',
        'Doe',
        19.99,
        12,
        LOWER('DivErs')),
       ('2021-05-02',
        NULL,
        '2021-06-05 11:52:25',
        '2021-06-05 11:58:08',
        NULL,
        'Monti',
        'Durns',
        199.99,
        1,
        TRIM(TRAILING ' ' FROM 'male   '));

INSERT INTO customers(first_name,
                      last_name,
                      email)
VALUES ('Max',
        'Schwarz',
        'max@test.com'),
       ('Manu',
        'Lorenz',
        'manu@test.com'),
       ('Julia',
        'Meyers',
        'juli@test.com');

INSERT INTO orders(amount_billed,
                   customer_id)
VALUES (48.99,
        1),
       (27.45,
        2),
       (19.49,
        1),
       (8.49,
        3);

INSERT INTO customers(first_name,
                      last_name,
                      email)
VALUES ('Ken',
        'Brooks',
        'ken@test.com');

select *
FROM memberships
WHERE LENGTH(last_name) < 7;

-- Operadores con date y timestamps
SELECT EXTRACT(MONTH FROM last_checkin)
FROM memberships;

-- Número del día de la semana
--Para mysql se debe usar WEEKDAY(last_checkin)
SELECT EXTRACT(ISODOW FROM last_checkin), last_checkin
FROM memberships;

-- Operación sólo para mysql
SELECT CONVERT(last_checkin, DATE), CONVERT(last_checkin, TIME)
FROM memberships;

-- Operación para postgress
SELECT last_checkin::TIMESTAMP::DATE, last_checkin::TIMESTAMP::TIME
FROM memberships;

SELECT last_checkout - last_checkin
FROM memberships;
SELECT membership_end - membership_start
FROM memberships;
SELECT NOW() - membership_start
FROM memberships;

-- Operación sólo en mysql
SELECT TIMESTAMPDIFF(MINUTE, last_checkin, last_checkout)
FROM memberships;
SELECT DATEDIFF(membership_end, membership_start)
FROM memberships;

SELECT membership_start + INTERVAL '7 MONTHS', membership_start
FROM memberships;

--mysql only
SELECT DATE_ADD(membership_start, INTERVAL 7 DAY), membership_start
FROM memberships;

-- Operador Like y coincidencia de patrones (operador LIKE es case sensitive, ILIKE no sólo en postgres)
SELECT first_name LIKE '%Ma%', first_name
FROM memberships;

SELECT first_name LIKE '_o%', first_name
FROM memberships;

SELECT first_name
FROM memberships
WHERE first_name LIKE 'Ma%';


-- Operdador EXISTS
SELECT EXISTS(
               SELECT first_name, last_name
               FROM customers
               WHERE email = 'manu@test.com'
           );

SELECT o.id
FROM orders AS o
WHERE EXISTS(
              SELECT c.email
              FROM customers AS c
              WHERE o.customer_id = c.id
                AND c.email = 'max@test.com'
          );

-- Operador IN
SELECT email
FROM customers;

SELECT c.email
FROM customers AS c
         INNER JOIN orders o on c.id = o.customer_id;

SELECT id, first_name
FROM customers
WHERE first_name IN ('Max', 'Manu');

SELECT email
FROM customers
WHERE id IN (SELECT customer_id
             FROM orders);


--Operadores Condicionales
SELECT amount_billed,
       CASE
           WHEN amount_billed > 30 THEN 'Good Day'
           WHEN amount_billed > 15 THEN 'Normal Day'
           ELSE 'Bad Day'
           END
FROM orders;

SELECT weekday_nr,
       CASE
           WHEN weekday_nr = 1 THEN 'Monday'
           WHEN weekday_nr = 2 THEN 'Tuesday'
           WHEN weekday_nr = 3 THEN 'Wednesday'
           WHEN weekday_nr = 4 THEN 'Thursday'
           WHEN weekday_nr = 5 THEN 'Friday'
           WHEN weekday_nr = 6 THEN 'Saturday'
           WHEN weekday_nr = 7 THEN 'Sunday'
           END
FROM (SELECT EXTRACT(ISODOW FROM last_checkin) AS weekday_nr
      FROM memberships) AS weekday_numbers;
