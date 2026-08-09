-- ══════════════════════════════════════════
-- BodegaTech — Script de Inventario (DDL + DML)
-- Autor: Marcos
-- Fecha: 2026-08-09
-- ══════════════════════════════════════════

-- Creamos la base de datos
CREATE DATABASE BD_BodegaTech;
GO

USE BD_BodegaTech;
GO

-- ── SECCIÓN DDL ──────────────────────────

-- DROP TABLE (permite re-ejecutar el script sin error si la tabla ya existe)
DROP TABLE IF EXISTS Inventario;

-- CREATE TABLE
CREATE TABLE Inventario (
    id_producto INT PRIMARY KEY,           -- INT: identificador entero sin decimales; PRIMARY KEY porque debe ser único y NOT NULL para cada producto
    nombre_producto VARCHAR(100),          -- VARCHAR(100): texto de longitud variable; 100 caracteres cubre nombres de producto sin reservar espacio fijo de más
    categoria VARCHAR(50),                 -- VARCHAR(50): categorías son textos cortos y variables (Computación, Accesorios, Audio, Almacenamiento)
    precio_unitario DECIMAL(10,2),         -- DECIMAL(10,2): valor monetario exacto, 10 dígitos totales y 2 decimales; nunca FLOAT porque introduce errores de redondeo en cálculos financieros
    stock_actual INT,                      -- INT: cantidad de unidades disponibles, siempre un número entero, no requiere decimales
    stock_minimo INT,                      -- INT: mismo criterio que stock_actual, es un conteo de unidades usado como umbral de reposición
    fecha_ingreso DATE,                    -- DATE: solo se necesita el día de ingreso, no la hora; usar DATE en vez de DATETIME ahorra espacio y evita ambigüedad horaria
    activo TINYINT                         -- TINYINT: estado binario (0 = inactivo, 1 = activo) representado con el entero más liviano disponible en SQL Server; se prefiere sobre VARCHAR porque evita valores inválidos como "si"/"tal vez", y es más portable que BIT si en el futuro se necesitan más de 2 estados
);

-- ── SECCIÓN DML ──────────────────────────

-- INSERT INTO: carga de los 10 productos iniciales
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

-- UPDATE: ventas del día (restan unidades del stock_actual). Cada uno con WHERE para no afectar al resto de la tabla
UPDATE Inventario SET stock_actual = stock_actual - 3  WHERE id_producto = 1; -- Laptop Pro 15: 15 - 3 = 12
UPDATE Inventario SET stock_actual = stock_actual - 12 WHERE id_producto = 2; -- Mouse Inalámbrico: 80 - 12 = 68
UPDATE Inventario SET stock_actual = stock_actual - 5  WHERE id_producto = 6; -- Auriculares BT Pro: 35 - 5 = 30

-- UPDATE: producto descontinuado por el proveedor
UPDATE Inventario SET activo = 0 WHERE id_producto = 8; -- Webcam HD 1080p

-- SELECT de validación: confirma que la carga y las actualizaciones quedaron correctas
SELECT * FROM Inventario;
