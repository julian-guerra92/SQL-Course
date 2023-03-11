
-- Creación de Tablas con sus respectivas relaciones 1:1 - 1:n  - n:n

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    title VARCHAR(300) NOT NULL,
    deadline DATE
);

CREATE TABLE company_buildings (
    id SERIAL PRIMARY KEY,
    name VARCHAR(300) NOT NULL
);

CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    building_id INT,
    FOREIGN KEY (building_id) REFERENCES company_buildings(id) ON DELETE SET NULL
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(300) NOT NULL,
    last_name VARCHAR(300) NOT NULL,
    birthdate DATE NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    team_id INT DEFAULT 1,
    FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET DEFAULT
    -- FOREIGN KEY (email) REFERENCES intranet_accounts(email) Es posible pero su relación debe ser en sentido contrario
);

CREATE TABLE intranet_accounts (
    id SERIAL PRIMARY KEY,
    email VARCHAR(200) NOT NULL,
    password VARCHAR(200) NOT NULL,
    FOREIGN KEY (email) REFERENCES employees(email) ON DELETE CASCADE
);

-- Intermediate Table for n:n relatioship
CREATE TABLE projects_employess (
    id SERIAL PRIMARY KEY,
    employee_id INT,
    project_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);

-- Intermediate Table for n:n relatioship (Ejemplo con Composite Primary Key)
CREATE TABLE projects_employess (
    employee_id INT,
    project_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    PRIMARY KEY (employee_id, project_id)
);


-- Creación de data para las tablas

INSERT INTO company_buildings (name) VALUES ('Main Building'), ('Research Lab'), ('Darkroom');

INSERT INTO teams ( name, building_id) VALUES ('Admin', 1), ('Data Analysts', 3), ('R&D', 1);

INSERT INTO employees (first_name, last_name, birthdate, email, team_id)
VALUES
    ('Julián', 'Rodrgíguez', '1922/11/08', 'julian@google.com', 1),
    ('Diana', 'Arboleda', '1983/11/25', 'diana@google.com', 2),
    ('Migue', 'Rodríguez', '1989/04/04', 'migue@google.com', 3);

INSERT INTO intranet_accounts (email, password)
VALUES
    ('julian@google.com', '123456'),
    ('diana@google.com', '123456'),
    ('migue@google.com', '12346');

INSERT INTO projects (title, deadline)
VALUES
    ('MAstering SQL', '2024-10-01'),
    ('New Hire Onboarding', '2022-02-28'),
    ('New Coruse Evaluation', '2022-01-01');

INSERT INTO projects_employess (employee_id, project_id)
VALUES
    (1, 2),
    (2, 2),
    (1, 2),
    (3, 1),
    (3, 3),
    (2, 3);

-- Posibles Querys hacia las tablas creadas

SELECT e.id AS employee_id, e.first_name, e.last_name, p.title FROM employees AS e
LEFT JOIN projects_employess AS pe ON e.id = pe.employee_id
LEFT JOIN projects AS p ON pe.project_id = p.id;

SELECT e.id, e.first_name, e.last_name, t.name FROM employees AS e
INNER JOIN teams As t ON e.team_id = t.id
WHERE t.id = 3;

SELECT e.id, e.first_name, e.last_name, t.name, cb.name FROM employees AS e
INNER JOIN teams As t ON e.team_id = t.id
LEFT JOIN company_buildings AS cb ON t.building_id = cb.id
WHERE t.building_id = 1
ORDER BY e.id;


-- Experimentando con la eliminación de data
DELETE FROM company_buildings
WHERE id = 3;

DELETE FROM teams
WHERE id = 3;

SELECT * FROM employees;


-- Consideraciones teóricas:

-- La relación 1 a 1 implica que que una fila de la tabla se relaciona con una única fila de la otra tabla.
    -- Ejemplo: email - empleado

-- La relación 1:n implica que una fila de la tabla se relaciona con muchas en la otra tabla
    -- Ejemplo: Centro de constos - Empleados
    -- En esta condición hay que tener en cuenta que el empleado sólo se relaciona directamente con un centro de costo

-- La relación n:n implica que varias filas de la primera tabla se relaciona con varias filas de la segunda tabla
    -- Ejemplo: Insumos - Proceso de producción
    -- Para este caso es importante tener en cuenta que se debe crear una tabla intermedia para dar manejo a esta relación


DROP TABLE projects_employess;
DROP TABLE intranet_accounts;
DROP TABLE projects;
DROP TABLE employees;
DROP TABLE teams;
DROP TABLE company_buildings;


