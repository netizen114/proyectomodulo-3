-- ====================================
-- Crea la base de datos y las tablas
-- ====================================

CREATE DATABASE alkewallet;

USE alkewallet;

CREATE TABLE moneda(
currency_id INT AUTO_INCREMENT PRIMARY KEY,
currency_name VARCHAR(50) NOT NULL UNIQUE,
currency_symbol VARCHAR(5) NOT NULL UNIQUE
);

CREATE TABLE usuarios(
user_id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(30) NOT NULL,
apellido VARCHAR(30) NOT NULL,
correo VARCHAR(50) NOT NULL UNIQUE,
clave VARCHAR(30) NOT NULL,
saldo DECIMAL(30,2) NOT NULL CHECK (saldo >= 0),
currency_id INT,

FOREIGN KEY(currency_id) REFERENCES moneda(currency_id) ON DELETE SET NULL
);

CREATE TABLE transacciones(
transaction_id INT AUTO_INCREMENT PRIMARY KEY,
sender_user_id INT NOT NULL,
receiver_user_id INT NOT NULL,
importe DECIMAL(10,2) NOT NULL,
transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
currency_id INT NOT NULL,

FOREIGN KEY (sender_user_id) REFERENCES usuarios(user_id),
FOREIGN KEY(receiver_user_id) REFERENCES usuarios(user_id),
FOREIGN KEY(currency_id) REFERENCES moneda(currency_id)
);

-- ====================================
-- Insertar datos de prueba
-- ====================================

INSERT INTO moneda(currency_name,currency_symbol)
VALUES
("Peso Chileno","$"),
("Dólar","USD$"),
("Yuan","¥");

INSERT INTO usuarios(nombre,apellido,correo,clave,saldo,currency_id)
VALUES
("Juan","Pérez","juan_perez@gmail.com","1234",2500.33,2),
("María","Dolores","maria_dolores@gmail.com","432112,4",100000,2),
("Mario","Bros","mario_bros@gmail.com","88224466ab",60000.55,3),
("Hugo","Patiño","hugo_patiño@gmail.com","qwerty",55555,1),
("Paco","Patiño","paco_patiño@gmail.com","micontraseña123",8888.55,3),
("Luis","Patiño","luis_patiño@gmail.com","admin",888888.55,3);

INSERT INTO transacciones(sender_user_id,receiver_user_id,importe,currency_id)
VALUES
(1,4,55555,3),
(3,2,456489,1),
(6,5,1000,2),
(5,4,1000,3),
(4,6,1000,1);

-- ====================================
-- CONSULTAS
-- =====================================

-- 1) Nombre de la moneda elegida por un usuario especifico.

SELECT CONCAT(u.nombre," ",u.apellido) as Usuario, m.currency_name as "Moneda Favorita"
FROM usuarios u
JOIN moneda m ON
u.currency_id = m.currency_id
where u.user_id = 3;

-- 2) Todas las transacciones registradas.

SELECT * 
FROM transacciones;

-- o también de manera más visual...

SELECT 
t.transaction_id, 
CONCAT(sender.nombre," ",sender.apellido," (",t.sender_user_id,")") as Sender, 
CONCAT(receiver.nombre," ",receiver.apellido," (",t.receiver_user_id,")") as Receiver,
CONCAT(m.currency_symbol,t.importe) as Importe,
m.currency_name as Moneda,
t.transaction_date

FROM transacciones as t

JOIN usuarios sender ON 
t.sender_user_id = sender.user_id
JOIN usuarios receiver ON 
t.receiver_user_id = receiver.user_id
JOIN moneda m ON 
t.currency_id = m.currency_id;


-- 3) Todas las transacciones realizadas por un usuario especifico

SELECT * 
FROM transacciones
WHERE sender_user_id = 4 or receiver_user_id = 4;

-- o al igual que en el ejemplo anterior, de manera más visual...

SELECT 
t.transaction_id,
CONCAT(sender.nombre," ",sender.apellido," (",t.sender_user_id,")") as Sender, 
CONCAT(receiver.nombre," ",receiver.apellido," (",t.receiver_user_id,")") as Receiver,
CONCAT(m.currency_symbol,t.importe) as Importe,
m.currency_name as Moneda,
t.transaction_date

FROM transacciones as t

JOIN usuarios sender ON 
t.sender_user_id = sender.user_id
JOIN usuarios receiver ON 
t.receiver_user_id = receiver.user_id
JOIN moneda m ON 
t.currency_id = m.currency_id

WHERE t.sender_user_id = 4 or t.receiver_user_id = 4;

-- 4) DML: modificar el correo electronico de un usuario especifico.

UPDATE usuarios
SET correo = "juan_perez_123456@gmail.com"
WHERE user_id = 1;

SELECT nombre, correo
FROM usuarios
WHERE user_id = 1;

-- 5) DML: eliminar los datos de una transaccion (fila completa).

DELETE 
FROM transacciones
WHERE transaction_id = 1;

SELECT *
FROM transacciones;




