-- ══════════════════════════════════════════
-- BodegaTech — Script de Inventario
-- Autor: MARCOS LUIS SENATRA
-- Fecha: 09/08/2026
-- ══════════════════════════════════════════

-- ── SECCIÓN DDL ──────────────────────────

DROP TABLE IF EXISTS inventario; -- EliminA la tabla si ya existe para poder re-ejecutar el script sin errores

-- Creamos la Base de Datos llamada BD_BodegaTech

CREATE DATABASE BD_BodegaTech;
GO

USE BD_BodegaTech;
GO

-- Creamos la Tabla llamada Inventario

CREATE TABLE Inventario (
	id_producto INT PRIMARY KEY,                -- Identificador único (PK)
	nombre_producto VARCHAR(100),				-- Nombre del producto
	categoria VARCHAR(50),						-- Categoría del producto
	precio_unitario DECIMAL(10,2),				-- Precio de venta en USD
	stock_actual INT,							-- Unidades disponibles
    stock_minimo INT,							-- Umbral mínimo de reposición
    fecha_ingreso DATE,							-- Solo fecha (sin hora), Fecha de ingreso al inventario
    activo TINYINT								-- 1 = disponible, 0 = descontinuado
);

SELECT * From Inventario

-- ── SECCIÓN DML ──────────────────────────
-- Vamos a cargar los datos con la función INSERT INTO

INSERT INTO Inventario (id_producto, nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES
    (1,  'Laptop Pro 15',        'Computación',     1200.00, 15, 3,  '2024-01-10', 1),
    (2,  'Mouse Inalámbrico',    'Accesorios',       28.00, 80, 10, '2024-01-10', 1),
    (3,  'Monitor 4K 27"',       'Computación',      450.00, 12, 2,  '2024-01-15', 1),
    (4,  'Teclado Mecánico',     'Accesorios',        95.00, 40, 5,  '2024-01-15', 1),
    (5,  'Laptop Basic 14',      'Computación',      650.00, 20, 3,  '2024-02-01', 1),
    (6,  'Auriculares BT Pro',   'Audio',            120.00, 35, 5,  '2024-02-01', 1),
    (7,  'Hub USB-C 7 puertos',  'Accesorios',        45.00, 60, 10, '2024-02-10', 1),
    (8,  'Webcam HD 1080p',      'Accesorios',        85.00, 25, 5,  '2024-02-10', 1),
    (9,  'SSD Externo 1TB',      'Almacenamiento',   130.00, 18, 3,  '2024-03-01', 1),
    (10, 'Parlante Bluetooth',   'Audio',             60.00, 45, 8,  '2024-03-01', 1);

SELECT * From Inventario

-- UPDATE con WHERE Vamos a actualizar las ventas del día (restan unidades del stock_actual):
UPDATE Inventario SET stock_actual = stock_actual - 3 WHERE id_producto = 1;     -- resta 3 unidades de la Laptop Pro 15: 15-3=12
UPDATE Inventario SET stock_actual = stock_actual - 12 WHERE id_producto = 2;    -- resta 12 unidades del Mouse Inalámbrico 80-12=68
UPDATE Inventario SET stock_actual = stock_actual - 5 WHERE id_producto = 6;     -- resta 5 unidades del Auricular BT Pro 35-5=30

SELECT * From Inventario

-- UPDATE adicional (producto discontinuado) Vamos a actualizar el producto descontinuado por el proveedor
UPDATE Inventario SET activo = 0 WHERE id_producto = 8;             -- Webcam HD 1080p discontinuada por proveedor

SELECT * From Inventario
