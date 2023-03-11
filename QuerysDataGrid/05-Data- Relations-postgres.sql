CREATE DATABASE relations;

-- Las FoeringKey debe tener el mismo tipo de dato con la tabla con la que está relacionada

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(300) NOT NULL,
    last_name VARCHAR(300) NOT NULL,
    email VARCHAR(300) NOT NULL,
    address_id INT NOT NULL
);

CREATE TABLE addresses (
    id SERIAL PRIMARY KEY,
    street VARCHAR(300) NOT NULL,
    house_number VARCHAR(50) NOT NULL,
    city_id INT NOT NULL
);

CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(300) NOT NULL
);

INSERT INTO cities (name) VALUES ('Berlin'), ('New York'), ('London'), ('Medellín');

INSERT INTO addresses (street, house_number, city_id) VALUES
    ('Teststreet', '8A', 1),
    ('Some Street', '10', 1),
    ('Otra Street', '10D', 3),
    ('Calle 9', '85-43', 4),
    ('Calle Boyacá', 'Carrera 31', 4);

INSERT INTO users (first_name, last_name, email, address_id) VALUES
    ('Julián', 'Rodríguez', 'julian@google.com', 1),
    ('Margarita', 'Arboleda', 'margarita@google.com', 2),
    ('Migue', 'Rodríguez', 'migue@google.com', 3),
    ('Jhon', 'Guerra', 'jhon@google.com', 4);


-- Selección de Data mediante el uso del JOIN

SELECT u.id, first_name, last_name, street, house_number, c.name AS city_name
FROM users AS u
INNER JOIN addresses AS a ON u.address_id = a.id
INNER JOIN cities AS c On a.city_id = c.id
WHERE c.id = 1 OR c.id = 3
ORDER BY u.id DESC;

SELECT *
FROM addresses AS a
LEFT JOIN users AS u on u.address_id = a.id
INNER JOIN cities c on a.city_id = c.id;

SELECT c.name AS city_name, u.first_name, u.last_name
FROM cities AS c
LEFT JOIN addresses AS a on c.id = a.city_id
LEFT JOIN users u on a.id = u.address_id;

-- Método Join no tan usado. Genera todas las posibles combinaciones entre las tablas.
SELECT *
FROM users
CROSS JOIN addresses;

SELECT * FROM users
WHERE id < 2
UNION
SELECT * FROM users
WHERE id > 3;


-- Implementación de las Foreign key

DROP TABLE users;
DROP TABLE addresses;
DROP TABLE cities;

CREATE TABLE addresses (
    id SERIAL PRIMARY KEY,
    street VARCHAR(300) NOT NULL,
    house_number VARCHAR(50) NOT NULL,
    city_id INT NOT NULL
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(300) NOT NULL,
    last_name VARCHAR(300) NOT NULL,
    email VARCHAR(300) NOT NULL,
    -- address_id INT REFERENCES addresses (id) ON DELETE RESTRICT
    address_id INT REFERENCES addresses (id) ON DELETE CASCADE
);

CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(300) NOT NULL
);

-- Tratando de violar la foreign key
INSERT INTO users (first_name, last_name, email, address_id) VALUES
    ('Max', 'Canson', 'max@google.com', 100);

DELETE FROM addresses WHERE id = 2;

SELECT * FROM users;