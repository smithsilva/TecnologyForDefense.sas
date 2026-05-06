-- 1. Usuarios con rol Administrador
SELECT * FROM Usuarios 
WHERE id_rol = (SELECT id_rol FROM Roles WHERE nombre_rol = 'Administrador');

-- 2. Empleados que ganan más que el promedio
SELECT * FROM Empleados 
WHERE salario > (SELECT AVG(salario) FROM Empleados);

-- 3. Productos con precio mayor al promedio
SELECT * FROM Productos 
WHERE precio_actual > (SELECT AVG(precio_actual) FROM Productos);

-- 4. Clientes que tienen mantenimiento registrado
SELECT * FROM Clientes 
WHERE id_cliente IN (SELECT id_cliente FROM Mantenimiento);

-- 5. Clientes sin mantenimiento
SELECT * FROM Clientes 
WHERE id_cliente NOT IN (SELECT id_cliente FROM Mantenimiento);

-- 6. Productos con stock menor al promedio
SELECT * FROM Productos 
WHERE stock_actual < (SELECT AVG(stock_actual) FROM Productos);

-- 7. Mantenimientos con total mayor al promedio
SELECT * FROM Mantenimiento 
WHERE total_del_mantenimiento > (SELECT AVG(total_del_mantenimiento) FROM Mantenimiento);

-- 8. Empleados que son mecánicos
SELECT * FROM Empleados 
WHERE id_usuario IN (
    SELECT id_usuario FROM Usuarios 
    WHERE id_rol = (SELECT id_rol FROM Roles WHERE nombre_rol = 'Mecanico')
);

-- 9. Productos de la categoría Aceites
SELECT * FROM Productos 
WHERE id_categoria = (
    SELECT id_categoria FROM Categorias WHERE nombre_categoria = 'Aceites'
);

-- 10. Proveedores que tienen productos
SELECT * FROM Proveedores 
WHERE id_proveedor IN (SELECT id_proveedor FROM Productos);

-- 11. Productos con precio máximo
SELECT * FROM Productos 
WHERE precio_actual = (SELECT MAX(precio_actual) FROM Productos);

-- 12. Productos con precio mínimo
SELECT * FROM Productos 
WHERE precio_actual = (SELECT MIN(precio_actual) FROM Productos);

-- 13. Empleado con mayor salario
SELECT * FROM Empleados 
WHERE salario = (SELECT MAX(salario) FROM Empleados);

-- 14. Mantenimiento más caro
SELECT * FROM Mantenimiento 
WHERE total_del_mantenimiento = (
    SELECT MAX(total_del_mantenimiento) FROM Mantenimiento
);

-- 15. Clientes con dirección en Bogotá
SELECT * FROM Clientes 
WHERE id_cliente IN (
    SELECT id_cliente FROM Direcciones_Cliente WHERE ciudad = 'Bogota'
);

-- 16. Usuarios activos con rol Gerente
SELECT * FROM Usuarios 
WHERE activo = TRUE 
AND id_rol = (SELECT id_rol FROM Roles WHERE nombre_rol = 'Gerente');

-- 17. Productos que nunca han sido usados en mantenimiento
SELECT * FROM Productos 
WHERE id_producto NOT IN (
    SELECT id_producto FROM Detalle_del_mantenimiento
);

-- 18. Métodos de pago usados en mantenimientos
SELECT * FROM Metodos_Pago 
WHERE id_metodo_pago IN (SELECT id_metodo_pago FROM Mantenimiento);

-- 19. Movimientos contables mayores al promedio
SELECT * FROM Movimientos_Contables 
WHERE valor > (SELECT AVG(valor) FROM Movimientos_Contables);

-- 20. Categorías que tienen productos
SELECT * FROM Categorias 
WHERE id_categoria IN (SELECT id_categoria FROM Productos);