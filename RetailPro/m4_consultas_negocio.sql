-- ══════════════════════════════════════════
-- RetailPro — Consultas SQL de negocio (M4)
-- Autor: Marcos Senatra
-- Fecha: 17/08/2026
-- ══════════════════════════════════════════

-- Nos ubicamos en la base de datos creada en el ejercico entregable anterior M3
USE Ventas_Tech_DB;
GO

-- Consulta 1: Resumen ejecutivo mensual
-- Por cada mes: total facturado, cantidad de pedidos y ticket promedio
-- El total de cada pedido se calcula como cantidad * precio_unitario
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- Consulta 2: Ranking de productos
-- Top 5 productos por total facturado, mostrando también las unidades vendidas
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- Consulta 3: Clientes recurrentes
-- Clientes que hicieron MÁS de un pedido, con la cantidad de pedidos y el total gastado
-- HAVING filtra los grupos (clientes) cuyo conteo de pedidos supera 1
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;

-- Consulta 4: Meses por encima/por debajo del promedio
-- Paso A: armamos una "subconsulta" (una consulta dentro de otra, le damos el nombre
-- FacturacionMensual) que calcula el total facturado de cada mes.
-- Paso B: sobre esa subconsulta, comparamos cada mes contra el promedio de TODOS
-- los meses usando CASE WHEN, que funciona como un "si... entonces... sino".
WITH FacturacionMensual AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM FacturacionMensual) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM FacturacionMensual
ORDER BY mes;

-- ══════════════════════════════════════════
-- Hallazgos
-- ══════════════════════════════════════════
-- 1. El producto 1 (Laptop Pro 15) concentra el 56% de la facturación total
--    ($3600 de $6444), muy por encima del resto — sugiere alta dependencia
--    de un solo producto del catálogo, un riesgo si ese producto se queda sin stock.
--
-- 2. Los 5 clientes cargados hicieron exactamente 2 pedidos cada uno, por lo que
--    el 100% de la base resultó "recurrente" según la Consulta 3. Esto es
--    consecuencia del tamaño chico del dataset de prueba (Checkpoint de M3),
--    no necesariamente un patrón esperado en datos reales de producción.
--
-- 3. Todos los registros de ventas caen en un único mes (marzo 2024), por lo que
--    la Consulta 4 no puede mostrar variación real entre meses todavía — el
--    análisis de "por encima/por debajo del promedio" va a ser útil recién
--    cuando la base tenga ventas de varios períodos distintos.