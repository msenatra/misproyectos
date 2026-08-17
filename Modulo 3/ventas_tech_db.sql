-- ══════════════════════════════════════════
-- Ventas_Tech_DB — Entregable 3
-- Autor: Marcos Senatra
-- ══════════════════════════════════════════

-- Paso 1: Creacion de la base de datos del proyecto
CREATE DATABASE Ventas_Tech_DB;
GO

-- Elegimos para trabajar la base de datos recién creada
USE Ventas_Tech_DB;
GO

-- ── SECCIÓN DDL (Data Definition Language) ──────────────────
-- Acá definimos la ESTRUCTURA: qué tablas existen y cómo son sus columnas

-- Paso 2: Eliminamos las tablas si ya existen, en orden INVERSO a las dependencias
DROP TABLE IF EXISTS ventas;      -- depende de clientes y productos → se borra primero
DROP TABLE IF EXISTS productos;   -- depende de categorias
DROP TABLE IF EXISTS clientes;    -- no tiene dependencias
DROP TABLE IF EXISTS categorias;  -- no tiene dependencias
DROP TABLE IF EXISTS territorios;  -- no tiene dependencias

-- Paso 3: Creamos las tablas SIN dependencias primero (categorias y clientes)

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,          -- Identificador único de cada categoría
    nombre_categoria VARCHAR(50) NOT NULL, -- Toda categoría necesita nombre
    descripcion VARCHAR(200)               -- Opcional: La descripcion puede quedar sin texto
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,          -- No puede haber un cliente sin nombre
    email VARCHAR(100) UNIQUE,             -- No puede haber dos clientes con el mismo email
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL           -- Necesitamos saber cuándo se registró
);
-- Paso 4: Creamos las tablas que SÍ dependen de otras (productos depende de categorias;
-- ventas depende de clientes y productos). Por eso van después, cuando sus referencias ya existen.

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT,                          -- FK: conecta cada producto con su categoría
    precio DECIMAL(10,2) NOT NULL,             -- DECIMAL(10,2), nunca FLOAT: evita errores de redondeo en dinero
    stock INT DEFAULT 0,                       -- DEFAULT 0: si no se especifica, arranca sin stock
    activo TINYINT DEFAULT 1,                  -- TINYINT (0/1) en vez de VARCHAR: más liviano, evita valores inválidos
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,                            -- FK: qué cliente hizo la compra
    id_producto INT,                           -- FK: qué producto se vendió
    cantidad INT NOT NULL,                     -- Toda venta tiene una cantidad
    precio_unitario DECIMAL(10,2) NOT NULL,    -- Precio al momento de la venta (puede diferir del precio actual del producto)
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ── SECCIÓN DML (Data Manipulation Language) ────────────────
-- Acá cargamos los DATOS dentro de la estructura que ya creamos

-- Paso 5: Insertamos las tablas SIN dependencias primero (categorias y clientes)

-- categorias (4 registros)
INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

-- clientes (5 registros)
INSERT INTO clientes VALUES (1, 'María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10');
INSERT INTO clientes VALUES (3, 'Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01');
INSERT INTO clientes VALUES (4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15');
INSERT INTO clientes VALUES (5, 'Laura Torres', 'laura@mail.com',  'Tucumán',      '2024-03-01');

-- Paso 6: Insertamos las tablas que dependen de las anteriores (productos y ventas)
-- Igual que con el CREATE TABLE: sin las categorías y clientes ya cargados, estas FK fallarían

-- productos (6 registros)
INSERT INTO productos VALUES (1, 'Laptop Pro 15',      1, 1200.00, 15, 1);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico',  2,   28.00, 80, 1);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',     1,  450.00, 12, 1);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro', 3,  120.00, 35, 1);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',    4,  130.00, 18, 1);
INSERT INTO productos VALUES (6, 'Teclado Mecánico',   2,   95.00, 40, 1);

-- ventas (10 registros) — la tabla de hechos, va al final porque depende de clientes Y productos
INSERT INTO ventas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO ventas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

-- Paso 7: Confirmamos que las 4 tablas se cargaron correctamente
SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;
-- (Más adelante, en el Módulo 5, vas a poder cruzar estas tablas con JOIN
--  para ver las ventas junto al nombre del cliente y del producto.
--  Por ahora alcanza con confirmar que las 4 tablas tienen sus datos.)