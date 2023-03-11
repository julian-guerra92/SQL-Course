-- La idea es que la transacción se realice completamente, de los contrario no se haga para garantizar
-- la integridad de la base de datos

-- START TRANSACTION; (Para mysql)
BEGIN; -- Inicia la sesión para el ingreso de datos. De manera predeterminada se gurdan los cambios de la sesion anterior si esta no fue cerrada.
ROLLBACK; -- Retorna al estado inicial de la db
ROLLBACK TO save_1; -- Retorna al estado inicial de la db en este punto específico
COMMIT; -- Guarda los cambios realizado en la sesion actual en la db

INSERT INTO customers(first_name,
                      last_name,
                      email)
VALUES ('Marry',
        'White',
        ',arry@test.com');

SAVEPOINT save_1; --Comando para guardar un Statement

INSERT INTO orders(amount_billed,
                   customer_id)
VALUES (103.12,
        10);

SELECT *
FROM customers;