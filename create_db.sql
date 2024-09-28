-- Crear el procedimiento almacenado
CREATE PROCEDURE CrearKentFoodsDB
AS
BEGIN
    -- Verificar si la base de datos ya existe
    IF EXISTS (SELECT * FROM sys.databases WHERE name = 'KentFoodsDB')
    BEGIN
        -- Si existe, eliminar la base de datos
        PRINT 'Eliminando la base de datos existente...';
        ALTER DATABASE KentFoodsDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE KentFoodsDB;
    END

    -- Crear la nueva base de datos
    PRINT 'Creando una nueva base de datos...';
    CREATE DATABASE KentFoodsDB;

    -- Crear las tablas dentro de la base de datos recién creada
    PRINT 'Creando tablas en KentFoodsDB...';

    -- Crear tabla de Clientes
    EXEC('
    CREATE TABLE KentFoodsDB.dbo.Clientes (
        ClienteID INT PRIMARY KEY,
        Empresa VARCHAR(100),
        Contacto VARCHAR(100),
        Pais VARCHAR(50),
        Ciudad VARCHAR(50)
    );');

    -- Crear tabla de Productos
    EXEC('
    CREATE TABLE KentFoodsDB.dbo.Productos (
        ProductoID INT PRIMARY KEY,
        Producto VARCHAR(100),
        Categoria VARCHAR(50),
        PrecioUnitario DECIMAL(10, 2)
    );');

    -- Crear tabla de Territorios
    EXEC('
    CREATE TABLE KentFoodsDB.dbo.Territorios (
        TerritorioID INT PRIMARY KEY,
        Region VARCHAR(50),
        Ciudad VARCHAR(50)
    );');

    -- Crear tabla de hechos: VentasFact
    EXEC('
    CREATE TABLE KentFoodsDB.dbo.VentasFact (
        OrdenID INT PRIMARY KEY,
        ClienteID INT,
        ProductoID INT,
        TerritorioID INT,
        Cantidad INT,
        Descuento NCHAR(10),
        TotalVenta DECIMAL(10, 2),
        FechaOrden DATE,
        FechaEnvio DATE,
        
        -- Llaves foráneas para las dimensiones
        FOREIGN KEY (ClienteID) REFERENCES KentFoodsDB.dbo.Clientes(ClienteID),
        FOREIGN KEY (ProductoID) REFERENCES KentFoodsDB.dbo.Productos(ProductoID),
        FOREIGN KEY (TerritorioID) REFERENCES KentFoodsDB.dbo.Territorios(TerritorioID)
    );');

    PRINT 'Base de datos y tablas creadas exitosamente.';
END;

	---Ejecución del procedimiento

EXEC CrearKentFoodsDB;
