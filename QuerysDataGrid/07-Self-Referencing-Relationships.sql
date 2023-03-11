
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(300) NOT NULL,
    last_name VARCHAR(300) NOT NULL,
    supervisor_id INT REFERENCES employees(id) ON DELETE SET NULL
);

INSERT INTO employees (first_name, last_name, supervisor_id)
VALUES
    ('Julián', 'Rodríguez', 2),
    ('Margarita', 'Arboleda', NULL),
    ('Max', 'Rodríguez', 1),
    ('Coco', 'Rodríguez', 1);

SELECT * FROM employees AS e1
LEFT JOIN employees AS e2 ON e1.supervisor_id = e2.id;

DROP TABLE employees;

-- Otro ejemplo de Self Relationships pero con relación many to many

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(300) NOT NULL
    -- Other info...
);

CREATE TABLE users_friends (
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    friend_id INT REFERENCES users(id) ON DELETE CASCADE,
    CHECK ( user_id < friend_id ),
    PRIMARY KEY (user_id, friend_id)
);

INSERT INTO users (first_name)
VALUES ('Manuel'), ('Migue'), ('Jhon');

INSERT INTO users_friends (user_id, friend_id)
VALUES (1,2), (1,3);