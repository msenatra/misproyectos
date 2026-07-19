-- ============================================================
-- Práctica: Diseño de esquemas con DDL y Tipos de Datos
-- Sistema de gestión de ventas - Tablas Clientes y Productos
-- ============================================================

-- Tabla: clientes
CREATE TABLE clientes (
    id_cliente INT,              -- Número entero: identificador único, no necesita decimales
    nombre VARCHAR(100),         -- Texto de longitud variable, 100 caracteres alcanza para un nombre completo
    perfil_bio TEXT,             -- Texto largo sin límite fijo, adecuado para una biografía o notas extensas
    fecha_registro DATE          -- Solo fecha (sin hora), suficiente para saber cuándo se registró el cliente
);

-- Tabla: productos
CREATE TABLE productos (
    id_producto INT,             -- Número entero: identificador único del producto
    descripcion VARCHAR(255),    -- Texto de hasta 255 caracteres para describir el producto
    precio DECIMAL(10, 2),       -- Decimal exacto para dinero (hasta 10 dígitos, 2 decimales). Nunca FLOAT para precios
    esta_activo SMALLINT         -- Número pequeño (0 = inactivo, 1 = activo), más portable entre PostgreSQL y SQL Server que BOOLEAN
);
