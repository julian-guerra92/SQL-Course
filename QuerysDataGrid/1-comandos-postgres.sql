-- Creación de Base de Datos:
CREATE DATABASE talently;

CREATE TYPE public.employment_status AS ENUM('employed', 'self-employed', 'unemployed');


-- Creación de Tablasa en la base de Datos e inserción de data:
CREATE TABLE users (
    full_name VARCHAR(200),
    yearly_salary INT,
    current_status employment_status
);

INSERT INTO users (yearly_salary, full_name, current_status) VALUES (19000, 'Julián Rodríguez', 'self-employed');
INSERT INTO users (yearly_salary, full_name, current_status) VALUES (0, 'Pepito Pérez', 'unemployed');
INSERT INTO users (yearly_salary, full_name, current_status) VALUES (45000, 'Margarita Arboleda', 'employed');

-- Visualizar toda la data de la tabla
SELECT * FROM users;


--Creación de Tablasa en la base de Datos e inserción de data
CREATE TABLE employers (
    company_name VARCHAR(250),
    company_address VARCHAR(300),
    -- yearly_revenue FLOAT(5,2) -- Aproximation Allowed: 123.12, 12.1, Not allowed: 1234.12, 1.123
    yearly_revenue NUMERIC(5,2),
    is_hiring BOOLEAN DEFAULT FALSE
);

CREATE TABLE convesation (
    user_name VARCHAR(200),
    employer_name VARCHAR(250),
    message TEXT,
    date_sent TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO employers (company_name, company_address, yearly_revenue, is_hiring)
VALUES ('Colanta', 'Carrera 50 # 30-41', 2.5, true);

INSERT INTO employers (company_name, company_address, yearly_revenue)
VALUES ('EPM', 'Carrera 30 # 28-41', 4.5);

-- Visualizar toda la data de la tabla
SELECT * FROM employers;

INSERT INTO convesation (user_name, employer_name, message, date_sent)
VALUES ('Julián Rodríguez', 'Colanta', 'Renuncio. Ya no quiero trabajar más...', '2022-06-01 07:00:00');

INSERT INTO convesation (user_name, employer_name, message)
VALUES ('Margarita Arboleda', 'Colanta', 'Debo ir al GYM Temprano. Juli me regaña');

-- Visualizar toda la data de la tabla
SELECT * FROM convesation;


-- Eliminación de tablas
DROP TABLE convesation;
DROP TABLE employers;


-- Modificación de tablas y adición de CONSTRAINT(Restricciones)
ALTER TABLE employers
ALTER COLUMN yearly_revenue SET DATA TYPE FLOAT;

ALTER TABLE users
ALTER COLUMN full_name SET DATA TYPE VARCHAR(300);

ALTER TABLE users
ALTER COLUMN full_name SET NOT NULL,
ALTER COLUMN  current_status SET NOT NULL;

ALTER TABLE users
ADD CONSTRAINT yearly_salary_positive CHECK ( yearly_salary > 0 );


-- Consulta promedio de una columna
SELECT AVG(yearly_salary) FROM users;


-- Actualización de un valor
UPDATE users
SET yearly_salary = NULL
WHERE full_name = 'Pepito Pérez';