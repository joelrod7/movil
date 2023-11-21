-- Tabla Usuario
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    email VARCHAR(100),
    u_password VARCHAR(100),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla CarritoCompra
CREATE TABLE CarritoCompra (
    id_carrito INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo'), -- Suponiendo que el estado es 'activo' o 'inactivo'
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Tabla Producto
CREATE TABLE Producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100),
    precio DECIMAL(10, 2),
    descripción TEXT
);

-- Tabla DetalleCompra
CREATE TABLE DetalleCompra (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_carrito INT,
    id_producto INT,
    cantidad INT,
    subtotal DECIMAL(10, 2),
    FOREIGN KEY (id_carrito) REFERENCES CarritoCompra(id_carrito),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);
