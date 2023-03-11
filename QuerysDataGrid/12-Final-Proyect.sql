-- Creación de base de datos
CREATE DATABASE app_events;


-- Creación de tablas
CREATE TABLE cities
(
    name VARCHAR(300) PRIMARY KEY
);

CREATE TABLE locations
(
    id           SERIAL PRIMARY KEY,
    title        VARCHAR(300),
    street       VARCHAR(300) NOT NULL,
    house_number VARCHAR(50)  NOT NULL,
    postal_code  VARCHAR(50)  NOT NULL,
    city_name    VARCHAR(200) REFERENCES cities (name) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE users
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(300) NOT NULL,
    last_name  VARCHAR(300) NOT NULL,
    birthdate  DATE         NOT NULL,
    email      VARCHAR(300) NOT NULL
);

CREATE TABLE organizers
(
    password VARCHAR(300) NOT NULL,
    user_id  INT PRIMARY KEY REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE tags
(
    name VARCHAR(100) PRIMARY KEY
);

CREATE TABLE events
(
    -- id INT PRIMARY KEY AUTO_INCREMENT, -- Only in mysql
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(300) NOT NULL CHECK ( LENGTH(name) > 5 ),
    date_planned     TIMESTAMP    NOT NULL,
    image            VARCHAR(300),
    description      TEXT         NOT NULL,
    max_participants INT CHECK ( max_participants > 0 ),
    min_age          INT CHECK ( min_age > 0 ),
    location_id      INT REFERENCES locations (id) ON DELETE CASCADE,
    organizer_id     INT REFERENCES organizers (user_id) ON DELETE CASCADE
);

CREATE TABLE events_users -- Necesario para la relación n:n
(
    event_id INT REFERENCES events (id) ON DELETE CASCADE,
    user_id  INT REFERENCES users (id) ON DELETE CASCADE,
    PRIMARY KEY (event_id, user_id) -- Primary Key compuesta
);

CREATE TABLE events_tags -- Necesario para la relación n:n
(
    event_id INT REFERENCES events (id) ON DELETE CASCADE,
    tag_name VARCHAR(100) REFERENCES tags (name) ON DELETE CASCADE,
    PRIMARY KEY (event_id, tag_name) -- Primary Key compuesta
);


-- Insertar Data a las tablas
INSERT INTO events (name, date_planned, description, max_participants, min_age)
VALUES ('A first event', '2023-03-15 16:30:00', 'This is the description of this first event', 20, 18),
       ('A second event', '2023-03-18 12:30:00', 'This is the description of this second event', 45, 18);


-- Manipulación de data y consulta de datos
UPDATE events
SET min_age = 16
WHERE id = 1;

DELETE
FROM events
WHERE id = 1;

DROP TABLE cities;

SELECT *
FROM events;


-- Tipos de filtro en el query
SELECT *
FROM events
-- WHERE date_planned > '2023-03-16' AND min_age >= 18;
ORDER BY id DESC;


-- Inner Join
SELECT e.id AS event_id,
       e.name,
       e.date_planned,
       l.street,
       l.house_number,
       l.city_name,
       u.first_name,
       u.last_name
FROM events AS e
         INNER JOIN locations AS l ON l.id = e.location_id
         INNER JOIN events_users AS eu ON eu.event_id = e.id
         INNER JOIN users AS u ON u.id = eu.user_id;


-- Left Join
SELECT *
FROM locations AS l
         LEFT JOIN events AS e on l.id = e.location_id;

SELECT *
FROM cities AS c
         LEFT JOIN locations AS l on c.name = l.city_name
         LEFT JOIN events AS e on l.id = e.location_id
WHERE e.date_planned > '2020-01-01';


-- Agregation Functions
SELECT *
FROM users
-- WHERE first_name LIKE 'Ma%';
WHERE first_name LIKE 'Ma_';

SELECT COUNT(id)
FROM locations;

SELECT SUM(id)
FROM locations;

SELECT c.name, l.street, COUNT(l.id) AS num_locations
FROM cities AS c
         LEFT JOIN locations AS l on c.name = l.city_name
GROUP BY c.name, l.street;

SELECT c.name, COUNT(l.id) AS num_locations
FROM cities AS c
         LEFT JOIN locations AS l on c.name = l.city_name
--WHERE l.city_name = 'Munich'
GROUP BY c.name
HAVING COUNT(l.id) > 1; -- Se usa después de hacer la agrupación de los resultados.








