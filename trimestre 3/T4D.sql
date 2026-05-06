CREATE DATABASE Final_T4D;
USE Final_T4D;
-- =============================================
-- TABLAS DE SEGURIDAD Y AUTENTICACIÓN
-- =============================================

-- Tabla: Roles de usuario
CREATE TABLE Roles (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    nivel_acceso INT CHECK (nivel_acceso BETWEEN 1 AND 10)
);

CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Almacena contraseña encriptada
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso DATETIME,
    activo BOOLEAN DEFAULT TRUE,
    id_rol INT,
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol),
    INDEX idx_email (email),
    INDEX idx_username (username)
);

-- =============================================
-- TABLAS DE RECURSOS HUMANOS (ADMINISTRACIÓN)
-- =============================================

CREATE TABLE Empleados (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    cargo VARCHAR(100),
    salario DECIMAL(10, 2),
    fecha_contratacion DATE,
    fecha_terminacion DATE,
    tipo_contrato ENUM('Indefinido', 'Temporal', 'Practicante') DEFAULT 'Indefinido',
    id_usuario INT UNIQUE, -- Relación con usuario del sistema
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    CONSTRAINT chk_fechas CHECK (fecha_terminacion IS NULL OR fecha_terminacion > fecha_contratacion)
);

-- =============================================
-- TABLAS DE PRODUCTOS E INVENTARIO
-- =============================================

CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion TEXT,
    categoria_padre INT NULL, -- Para subcategorías
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_padre) REFERENCES Categorias(id_categoria)
);

CREATE TABLE Proveedores (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nit VARCHAR(20) UNIQUE NOT NULL,
    nombre_proveedor VARCHAR(150) NOT NULL,
    contacto_principal VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(255)
);

CREATE TABLE Productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    codigo_barras VARCHAR(50) UNIQUE NOT NULL,
    nombre_producto VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio_actual DECIMAL(10, 2) NOT NULL,
    stock_actual INT DEFAULT 0,
    stock_minimo INT DEFAULT 10,
    unidad_medida VARCHAR(20),
    id_categoria INT,
    id_proveedor INT,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor),
    CONSTRAINT chk_stock CHECK (stock_actual >= 0),
    CONSTRAINT chk_precio CHECK (precio_actual > 0)
);

-- Tabla del para el (contador)
CREATE TABLE Historial_Precios (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    precio_anterior DECIMAL(10, 2),
    precio_nuevo DECIMAL(10, 2),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(255),
    id_usuario_modifico INT,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_usuario_modifico) REFERENCES Usuarios(id_usuario)
);

-- =============================================
-- TABLAS DE CLIENTES 
-- =============================================

CREATE TABLE Departamentos (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre_departamento VARCHAR(100) NOT NULL,
    presupuesto_anual DECIMAL(15, 2),
    fecha_creacion DATE,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    tipo_documento ENUM('CC', 'CE', 'NIT', 'Pasaporte') DEFAULT 'CC',
    numero_documento VARCHAR(20) UNIQUE NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    id_usuario INT UNIQUE, -- Relación con usuario del sistema
    id_departamento INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_departamento) REFERENCES Departamentos(id_departamento)
);

CREATE TABLE Direcciones_Cliente (
    id_direccion INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    direccion VARCHAR(255) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    barrio VARCHAR(100),
    indicaciones_entrega TEXT,
    es_principal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente) ON DELETE CASCADE
);

CREATE TABLE Sucursales (
    id_sucursal INT PRIMARY KEY AUTO_INCREMENT,
    nombre_sucursal VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    ciudad VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    horario_apertura TIME,
    horario_cierre TIME,
    activo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- TABLAS DE VENTAS Y MOVIMIENTOS 
-- =============================================

CREATE TABLE Metodos_Pago (
    id_metodo_pago INT PRIMARY KEY AUTO_INCREMENT,
    nombre_metodo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100),
    permite_online BOOLEAN DEFAULT TRUE
);

CREATE TABLE Mantenimiento (
    id_mantenimiento INT PRIMARY KEY AUTO_INCREMENT,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_de_mantenimiento ENUM('Fisica', 'Online') NOT NULL,
    estado ENUM('Pendiente', 'Completada', 'Cancelada', 'Enviada', 'Entregada') DEFAULT 'Pendiente',
    id_sucursal INT NULL, -- NULL para ventas online
    id_cliente INT NULL, -- NULL para ventas sin registro
    id_empleado_cajero INT NULL, -- NULL para ventas online
    subtotal DECIMAL(10, 2),
    iva DECIMAL(10, 2),
    total_del_mantenimiento DECIMAL(10, 2),
    id_metodo_pago INT,
    FOREIGN KEY (id_sucursal) REFERENCES Sucursales(id_sucursal),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_empleado_cajero) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_metodo_pago) REFERENCES Metodos_Pago(id_metodo_pago),
    INDEX idx_fecha (fecha_hora),
    INDEX idx_estado (estado)
);

CREATE TABLE Detalle_del_mantenimiento (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_mantenimiento INT,
    id_producto INT,
    cantidad INT NOT NULL,
    FOREIGN KEY ( id_mantenimiento) REFERENCES Mantenimiento( id_mantenimiento),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    CONSTRAINT chk_cantidad CHECK (cantidad > 0)
);

-- =============================================
-- TABLAS DE CONTABILIDAD (CONTADOR)
-- =============================================

CREATE TABLE Movimientos_Contables (
    id_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    fecha_movimiento DATE NOT NULL,
    tipo_movimiento ENUM('Ingreso', 'Egreso', 'Ajuste') NOT NULL,
    concepto VARCHAR(255),
    id_Mantenimiento INT NULL,
    valor DECIMAL(15,2) NOT NULL,
    id_usuario_registro INT,
    FOREIGN KEY (id_mantenimiento) REFERENCES Mantenimiento(id_mantenimiento),
    FOREIGN KEY (id_usuario_registro) REFERENCES Usuarios(id_usuario)
);