-- 1. Ver todos los usuarios
SELECT * FROM Usuarios;

-- 2. Ver todos los roles
SELECT * FROM Roles;

-- 3. Ver empleados
SELECT * FROM Empleados;

-- 4. Ver productos
SELECT * FROM Productos;

-- 5. Ver clientes
SELECT * FROM Clientes;

-- 6. Ver proveedores
SELECT * FROM Proveedores;

-- 7. Ver categorías activas
SELECT * FROM Categorias WHERE activo = TRUE;

-- 8. Ver sucursales en Bogotá
SELECT * FROM Sucursales WHERE ciudad = 'Bogota';

-- 9. Ver métodos de pago
SELECT * FROM Metodos_Pago;

-- 10. Ver usuarios activos
SELECT * FROM Usuarios WHERE activo = TRUE;

-- 11. Ver empleados que son mecánicos
SELECT * FROM Empleados WHERE cargo = 'Mecanico';

-- 12. Ver productos con precio mayor a 100000
SELECT nombre_producto, precio_actual
FROM Productos
WHERE precio_actual > 100000;

-- 13. Ver clientes registrados hoy
SELECT * FROM Clientes
WHERE fecha_registro = CURRENT_DATE;

-- 14. Ver direcciones principales
SELECT * FROM Direcciones_Cliente
WHERE es_principal = TRUE;

-- 15. Ver proveedores con correo específico
SELECT nombre_proveedor, email
FROM Proveedores
WHERE email LIKE '%@test.com';

-- 16. Ver métodos de pago que permiten online
SELECT * FROM Metodos_Pago
WHERE permite_online = TRUE;

-- 17. Ver mantenimientos pendientes
SELECT * FROM Mantenimiento
WHERE estado = 'Pendiente';

-- 18. Ver productos ordenados por precio (de mayor a menor)
SELECT nombre_producto, precio_actual
FROM Productos
ORDER BY precio_actual DESC;

-- 19. Ver empleados ordenados por salario (de menor a mayor)
SELECT nombre_completo, salario
FROM Empleados
ORDER BY salario ASC;
-- 20. Ver mantenimientos completados
SELECT * FROM Mantenimiento WHERE estado = 'Completada';

