-- =============================================
-- Usuarios y empleados
-- ============================================= 

-- 1. Obtener usuarios junto con su información de empleado
-- FUNCIÓN: Relaciona cuentas del sistema con datos laborales

SELECT u.username, u.email, e.nombre_completo, e.cargo
FROM Usuarios u
JOIN Empleados e ON u.id_usuario = e.id_usuario;

-- 2. Ver empleados que tienen acceso al sistema
-- FUNCIÓN: Saber qué empleados tienen usuario activo en la plataforma

SELECT e.nombre_completo, e.cargo, u.username, u.activo
FROM Empleados e
JOIN Usuarios u ON e.id_usuario = u.id_usuario;

-- 3. Empleados que NO tienen usuario
-- FUNCIÓN: Detectar empleados sin acceso al sistema (útil para control interno)

SELECT e.nombre_completo
FROM Empleados e
LEFT JOIN Usuarios u ON e.id_usuario = u.id_usuario
WHERE u.id_usuario IS NULL;

-- =============================================
-- Productos, categorías y proveedores
-- ============================================= 

-- 4. Listar productos con su categoría y proveedor
-- FUNCIÓN: Mostrar información completa de inventario

SELECT p.nombre_producto, c.nombre_categoria, pr.nombre_proveedor
FROM Productos p
JOIN Categorias c ON p.id_categoria = c.id_categoria
JOIN Proveedores pr ON p.id_proveedor = pr.id_proveedor;

-- 5. Productos con bajo stock
-- FUNCIÓN: Identificar productos que necesitan reposición

SELECT p.nombre_producto, p.stock_actual, p.stock_minimo, c.nombre_categoria
FROM Productos p
JOIN Categorias c ON p.id_categoria = c.id_categoria
WHERE p.stock_actual <= p.stock_minimo;

-- 6. Productos sin proveedor
-- FUNCIÓN: Detectar productos mal registrados o incompletos

SELECT p.nombre_producto
FROM Productos p
LEFT JOIN Proveedores pr ON p.id_proveedor = pr.id_proveedor
WHERE pr.id_proveedor IS NULL;

-- 7. Subcategorías con su categoría padre
-- FUNCIÓN: Mostrar jerarquía de categorías (estructura tipo árbol)

SELECT c1.nombre_categoria AS subcategoria, c2.nombre_categoria AS categoria_padre
FROM Categorias c1
JOIN Categorias c2 ON c1.categoria_padre = c2.id_categoria;

-- =============================================
-- Historial de precios
-- ============================================= 

-- 8. Ver cambios de precio con el usuario que los realizó
-- FUNCIÓN: Auditoría de modificaciones de precios

SELECT p.nombre_producto, h.precio_anterior, h.precio_nuevo, u.username, h.fecha_cambio
FROM Historial_Precios h
JOIN Productos p ON h.id_producto = p.id_producto
JOIN Usuarios u ON h.id_usuario_modifico = u.id_usuario;

-- =============================================
-- Clientes y direcciones
-- =============================================  	

-- 9. Clientes con su departamento
-- FUNCIÓN: Clasificar clientes por área o dependencia

SELECT c.nombre_completo, d.nombre_departamento
FROM Clientes c
JOIN Departamentos d ON c.id_departamento = d.id_departamento;

-- 10. Clientes con todas sus direcciones
-- FUNCIÓN: Mostrar ubicaciones registradas de cada cliente

SELECT c.nombre_completo, dc.direccion, dc.ciudad
FROM Clientes c
JOIN Direcciones_Cliente dc ON c.id_cliente = dc.id_cliente;

-- 11. Dirección principal de cada cliente
-- FUNCIÓN: Obtener la dirección principal para envíos

SELECT c.nombre_completo, dc.direccion
FROM Clientes c
JOIN Direcciones_Cliente dc ON c.id_cliente = dc.id_cliente
WHERE dc.es_principal = TRUE;

-- 12. Clientes con cuenta de usuario
-- FUNCIÓN: Saber qué clientes pueden iniciar sesión en el sistema

SELECT c.nombre_completo, u.username
FROM Clientes c
JOIN Usuarios u ON c.id_usuario = u.id_usuario;

-- =============================================
-- Mantenimiento (ventas)
-- ============================================= 

-- 13. Mantenimientos con cliente y empleado
-- FUNCIÓN: Ver quién compró y quién atendió la operación

SELECT m.id_mantenimiento, c.nombre_completo AS cliente, e.nombre_completo AS empleado
FROM Mantenimiento m
LEFT JOIN Clientes c ON m.id_cliente = c.id_cliente
LEFT JOIN Empleados e ON m.id_empleado_cajero = e.id_empleado;

-- 14. Mantenimientos por sucursal
-- FUNCIÓN: Analizar ventas por sede

SELECT m.id_mantenimiento, s.nombre_sucursal, m.total_del_mantenimiento
FROM Mantenimiento m
JOIN Sucursales s ON m.id_sucursal = s.id_sucursal;

-- 15. Mantenimientos con método de pago
-- FUNCIÓN: Analizar cómo pagan los clientes

SELECT m.id_mantenimiento, mp.nombre_metodo, m.total_del_mantenimiento
FROM Mantenimiento m
JOIN Metodos_Pago mp ON m.id_metodo_pago = mp.id_metodo_pago;

-- =============================================
-- Detalle de mantenimiento
-- ============================================= 

-- 16. Detalle de productos por mantenimiento
-- FUNCIÓN: Ver qué productos se vendieron en cada operación

SELECT m.id_mantenimiento, p.nombre_producto, d.cantidad
FROM Detalle_del_mantenimiento d
JOIN Mantenimiento m ON d.id_mantenimiento = m.id_mantenimiento
JOIN Productos p ON d.id_producto = p.id_producto;

-- 17. Total vendido por producto
-- FUNCIÓN: Identificar productos más vendidos

SELECT p.nombre_producto, SUM(d.cantidad) AS total_vendido
FROM Detalle_del_mantenimiento d
JOIN Productos p ON d.id_producto = p.id_producto
GROUP BY p.nombre_producto;

-- 18. Productos comprados por cliente
-- FUNCIÓN: Analizar comportamiento de compra de clientes

SELECT c.nombre_completo, p.nombre_producto, d.cantidad
FROM Detalle_del_mantenimiento d
JOIN Mantenimiento m ON d.id_mantenimiento = m.id_mantenimiento
JOIN Clientes c ON m.id_cliente = c.id_cliente
JOIN Productos p ON d.id_producto = p.id_producto;

-- =============================================
-- Contabilidad
-- ============================================= 

-- 19. Movimientos contables relacionados con mantenimientos
-- FUNCIÓN: Relacionar ingresos/egresos con ventas reales

SELECT mc.tipo_movimiento, mc.valor, m.total_del_mantenimiento
FROM Movimientos_Contables mc
JOIN Mantenimiento m ON mc.id_mantenimiento = m.id_mantenimiento;

-- 20. Movimientos contables con usuario
-- FUNCIÓN: Saber quién registró cada movimiento financiero

SELECT mc.tipo_movimiento, mc.valor, u.username
FROM Movimientos_Contables mc
JOIN Usuarios u ON mc.id_usuario_registro = u.id_usuario;

-- =============================================
-- Consultas avanzadas (multi-join)
-- ============================================= 

-- 21. Vista completa de mantenimiento
-- FUNCIÓN: Reporte general (cliente + empleado + sucursal + pago)

SELECT 
    m.id_mantenimiento,
    c.nombre_completo AS cliente,
    e.nombre_completo AS empleado,
    s.nombre_sucursal,
    mp.nombre_metodo,
    m.total_del_mantenimiento
FROM Mantenimiento m
LEFT JOIN Clientes c ON m.id_cliente = c.id_cliente
LEFT JOIN Empleados e ON m.id_empleado_cajero = e.id_empleado
LEFT JOIN Sucursales s ON m.id_sucursal = s.id_sucursal
LEFT JOIN Metodos_Pago mp ON m.id_metodo_pago = mp.id_metodo_pago;

-- 22. Factura detallada
-- FUNCIÓN: Simular una factura con cálculo de subtotales

SELECT 
    m.id_mantenimiento,
    c.nombre_completo,
    p.nombre_producto,
    d.cantidad,
    p.precio_actual,
    (d.cantidad * p.precio_actual) AS subtotal
FROM Mantenimiento m
JOIN Clientes c ON m.id_cliente = c.id_cliente
JOIN Detalle_del_mantenimiento d ON m.id_mantenimiento = d.id_mantenimiento
JOIN Productos p ON d.id_producto = p.id_producto;