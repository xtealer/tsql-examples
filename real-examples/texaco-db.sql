-- Create a new database called 'DB-TEXACO'

-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT name
FROM sys.databases
WHERE name = N'DB-TEXACO'
)
	CREATE DATABASE DB_TEXACO
GO

USE DB_TEXACO;

-- Create a new table called 'T_Combustible' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('T_Combustible', 'U') IS NOT NULL
DROP TABLE T_Combustible
GO
-- Create the table in the specified schema
CREATE TABLE T_Combustible
(
    Com_CombustibleId INT NOT NULL PRIMARY KEY,
    -- primary key column
    Com_Nombre [NVARCHAR](5) NOT NULL,
    Com_Litros DECIMAL(8,3) NOT NULL,
    Com_Valor DECIMAL(5,3) NOT NULL,
    -- specify more columns here
);
GO

-- Create a new table called 'T_Maquina' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('T_Maquina', 'U') IS NOT NULL
DROP TABLE T_Maquina
GO
-- Create the table in the specified schema
CREATE TABLE T_Maquina
(
    Maq_MaquinaId INT NOT NULL PRIMARY KEY,
    -- primary key column
    Maq_Acumulador DECIMAL(10,3) NOT NULL,
    Maq_CombustibleId INT NOT NULL,
    FOREIGN KEY (Maq_CombustibleId) REFERENCES T_Combustible(Com_CombustibleId)
    -- specify more columns here
);
GO

-- Create a new table called 'T_Trabajador' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('T_Trabajador', 'U') IS NOT NULL
DROP TABLE T_Trabajador
GO
-- Create the table in the specified schema
CREATE TABLE T_Trabajador
(
    Tra_TrabajadorId INT NOT NULL PRIMARY KEY,
    -- primary key column
    Tra_Nombre [NVARCHAR](50) NOT NULL,
    Tra_DNI [NVARCHAR](50) NOT NULL,
    Tra_Edad INT NOT NULL,
    -- specify more columns here
);
GO

-- Create a new table called 'T_Turnos' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('T_Turnos', 'U') IS NOT NULL
DROP TABLE T_Turnos
GO
-- Create the table in the specified schema
CREATE TABLE T_Turnos
(
    Tur_TurnosId INT NOT NULL,
    -- primary key column
    Tur_Fecha DATE NOT NULL,
    Tur_TrabajadorId INT NOT NULL,
    Tur_Nombre [NVARCHAR](10) NOT NULL,
    PRIMARY KEY (Tur_TurnosId,Tur_Fecha),
    FOREIGN KEY (Tur_TrabajadorId) REFERENCES T_Trabajador(Tra_TrabajadorId)
    -- specify more columns here
);
GO

-- Create a new table called 'T_Articulos' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('T_Articulos', 'U') IS NOT NULL
DROP TABLE T_Articulos
GO
-- Create the table in the specified schema
CREATE TABLE T_Articulos
(
    Art_ArticulosId INT NOT NULL PRIMARY KEY,
    -- primary key column
    Art_Nombre [NVARCHAR](50) NOT NULL,
    Art_Precio SMALLMONEY NOT NULL,
    Art_Stock INT NOT NULL
    -- specify more columns here
);
GO

-- Create a new table called 'T_Ventas_Art' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('T_Ventas_Art', 'U') IS NOT NULL
DROP TABLE T_Ventas_Art
GO
-- Create the table in the specified schema
CREATE TABLE T_Ventas_Art
(
    VenArt_Ventas_ArtId INT NOT NULL PRIMARY KEY,
    -- primary key column
    VenArt_ArticulosId INT NOT NULL,
    VenArt_Cantidad INT NOT NULL,
    VenArt_Total SMALLMONEY NOT NULL,
    VenArt_TurnoId INT NOT NULL,
    VenArt_Fecha DATE NOT NULL,
    FOREIGN KEY (VenArt_ArticulosId) REFERENCES T_Articulos (Art_ArticulosId),
    FOREIGN KEY (VenArt_TurnoId,VenArt_Fecha) REFERENCES T_Turnos (Tur_TurnosId,Tur_Fecha)
    -- specify more columns here
);
GO

-- Create a new table called 'T_Ventas_Com' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('T_Ventas_Com', 'U') IS NOT NULL
DROP TABLE T_Ventas_Com
GO
-- Create the table in the specified schema
CREATE TABLE T_Ventas_Com
(
    VenCom_Ventas_ComId INT NOT NULL PRIMARY KEY,
    -- primary key column
    VenCom_Litros DECIMAL(8,3) NOT NULL,
    VenCom_Maquina INT NOT NULL,
    VenCom_Total SMALLMONEY NOT NULL,
    VenCom_TurnoId INT NOT NULL,
    VenCom_Fecha DATE NOT NULL,
    FOREIGN KEY (VenCom_Maquina) REFERENCES T_Maquina (Maq_MaquinaId),
    FOREIGN KEY (VenCom_TurnoId,VenCom_Fecha) REFERENCES T_Turnos (Tur_TurnosId,Tur_Fecha)
    -- specify more columns here
);
GO

SELECT 'sqlserver' dbms, t.TABLE_CATALOG, t.TABLE_SCHEMA, t.TABLE_NAME, c.COLUMN_NAME, c.ORDINAL_POSITION, c.DATA_TYPE, c.CHARACTER_MAXIMUM_LENGTH, n.CONSTRAINT_TYPE, k2.TABLE_SCHEMA, k2.TABLE_NAME, k2.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLES t LEFT JOIN INFORMATION_SCHEMA.COLUMNS c ON t.TABLE_CATALOG=c.TABLE_CATALOG AND t.TABLE_SCHEMA=c.TABLE_SCHEMA AND t.TABLE_NAME=c.TABLE_NAME LEFT JOIN(INFORMATION_SCHEMA.KEY_COLUMN_USAGE k JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS n ON k.CONSTRAINT_CATALOG=n.CONSTRAINT_CATALOG AND k.CONSTRAINT_SCHEMA=n.CONSTRAINT_SCHEMA AND k.CONSTRAINT_NAME=n.CONSTRAINT_NAME LEFT JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS r ON k.CONSTRAINT_CATALOG=r.CONSTRAINT_CATALOG AND k.CONSTRAINT_SCHEMA=r.CONSTRAINT_SCHEMA AND k.CONSTRAINT_NAME=r.CONSTRAINT_NAME)ON c.TABLE_CATALOG=k.TABLE_CATALOG AND c.TABLE_SCHEMA=k.TABLE_SCHEMA AND c.TABLE_NAME=k.TABLE_NAME AND c.COLUMN_NAME=k.COLUMN_NAME LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE k2 ON k.ORDINAL_POSITION=k2.ORDINAL_POSITION AND r.UNIQUE_CONSTRAINT_CATALOG=k2.CONSTRAINT_CATALOG AND r.UNIQUE_CONSTRAINT_SCHEMA=k2.CONSTRAINT_SCHEMA AND r.UNIQUE_CONSTRAINT_NAME=k2.CONSTRAINT_NAME
WHERE t.TABLE_TYPE='BASE TABLE';
GO

-- Logins
-- Arthurs -> system admin -> super user
USE [master]
GO
CREATE LOGIN [arthurs] WITH PASSWORD=N'arthur123' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [arthurs]
GO
use [DB_TEXACO];
GO
CREATE USER [arthurs] FOR LOGIN [arthurs]
GO
USE [DB_TEXACO]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [arthurs]
GO
USE [DB_TEXACO]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [arthurs]
GO
USE [DB_TEXACO]
GO
ALTER ROLE [db_datareader] ADD MEMBER [arthurs]
GO
USE [DB_TEXACO]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [arthurs]
GO
USE [DB_TEXACO]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [arthurs]
GO
USE [DB_TEXACO]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [arthurs]
GO
USE [DB_TEXACO]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [arthurs]
GO
USE [DB_TEXACO]
GO
ALTER ROLE [db_owner] ADD MEMBER [arthurs]
GO
USE [DB_TEXACO]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [arthurs]
GO

-- Brytany -> Permisos Globales -> tabla sin permisos
USE [master]
GO
CREATE LOGIN [britany] WITH PASSWORD=N'britany123' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [britany]
GO
USE [DB_TEXACO]
GO
CREATE USER [britany] FOR LOGIN [britany]
GO
use [DB_TEXACO]
GO
GRANT ALTER ON [dbo].[T_Articulos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT CONTROL ON [dbo].[T_Articulos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT DELETE ON [dbo].[T_Articulos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT INSERT ON [dbo].[T_Articulos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT REFERENCES ON [dbo].[T_Articulos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT SELECT ON [dbo].[T_Articulos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT TAKE OWNERSHIP ON [dbo].[T_Articulos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT UPDATE ON [dbo].[T_Articulos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW CHANGE TRACKING ON [dbo].[T_Articulos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW DEFINITION ON [dbo].[T_Articulos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT ALTER ON [dbo].[T_Ventas_Com] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT CONTROL ON [dbo].[T_Ventas_Com] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT DELETE ON [dbo].[T_Ventas_Com] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT INSERT ON [dbo].[T_Ventas_Com] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT REFERENCES ON [dbo].[T_Ventas_Com] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT SELECT ON [dbo].[T_Ventas_Com] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT TAKE OWNERSHIP ON [dbo].[T_Ventas_Com] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT UPDATE ON [dbo].[T_Ventas_Com] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW CHANGE TRACKING ON [dbo].[T_Ventas_Com] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW DEFINITION ON [dbo].[T_Ventas_Com] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT ALTER ON [dbo].[T_Ventas_Art] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT CONTROL ON [dbo].[T_Ventas_Art] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT DELETE ON [dbo].[T_Ventas_Art] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT INSERT ON [dbo].[T_Ventas_Art] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT REFERENCES ON [dbo].[T_Ventas_Art] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT SELECT ON [dbo].[T_Ventas_Art] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT TAKE OWNERSHIP ON [dbo].[T_Ventas_Art] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT UPDATE ON [dbo].[T_Ventas_Art] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW CHANGE TRACKING ON [dbo].[T_Ventas_Art] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW DEFINITION ON [dbo].[T_Ventas_Art] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT ALTER ON [dbo].[T_Turnos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT CONTROL ON [dbo].[T_Turnos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT DELETE ON [dbo].[T_Turnos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT INSERT ON [dbo].[T_Turnos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT REFERENCES ON [dbo].[T_Turnos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT SELECT ON [dbo].[T_Turnos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT TAKE OWNERSHIP ON [dbo].[T_Turnos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT UPDATE ON [dbo].[T_Turnos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW CHANGE TRACKING ON [dbo].[T_Turnos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW DEFINITION ON [dbo].[T_Turnos] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT ALTER ON [dbo].[T_Trabajador] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT CONTROL ON [dbo].[T_Trabajador] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT DELETE ON [dbo].[T_Trabajador] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT INSERT ON [dbo].[T_Trabajador] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT REFERENCES ON [dbo].[T_Trabajador] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT SELECT ON [dbo].[T_Trabajador] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT TAKE OWNERSHIP ON [dbo].[T_Trabajador] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT UPDATE ON [dbo].[T_Trabajador] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW CHANGE TRACKING ON [dbo].[T_Trabajador] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW DEFINITION ON [dbo].[T_Trabajador] TO [britany]
GO
use [DB_TEXACO]
GO
DENY ALTER ON [dbo].[T_Combustible] TO [britany]
GO
use [DB_TEXACO]
GO
DENY CONTROL ON [dbo].[T_Combustible] TO [britany]
GO
use [DB_TEXACO]
GO
DENY DELETE ON [dbo].[T_Combustible] TO [britany]
GO
use [DB_TEXACO]
GO
DENY INSERT ON [dbo].[T_Combustible] TO [britany]
GO
use [DB_TEXACO]
GO
DENY REFERENCES ON [dbo].[T_Combustible] TO [britany]
GO
use [DB_TEXACO]
GO
DENY SELECT ON [dbo].[T_Combustible] TO [britany]
GO
use [DB_TEXACO]
GO
DENY TAKE OWNERSHIP ON [dbo].[T_Combustible] TO [britany]
GO
use [DB_TEXACO]
GO
DENY UPDATE ON [dbo].[T_Combustible] TO [britany]
GO
use [DB_TEXACO]
GO
DENY VIEW CHANGE TRACKING ON [dbo].[T_Combustible] TO [britany]
GO
use [DB_TEXACO]
GO
DENY VIEW DEFINITION ON [dbo].[T_Combustible] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT ALTER ON [dbo].[T_Maquina] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT CONTROL ON [dbo].[T_Maquina] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT DELETE ON [dbo].[T_Maquina] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT INSERT ON [dbo].[T_Maquina] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT REFERENCES ON [dbo].[T_Maquina] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT SELECT ON [dbo].[T_Maquina] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT TAKE OWNERSHIP ON [dbo].[T_Maquina] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT UPDATE ON [dbo].[T_Maquina] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW CHANGE TRACKING ON [dbo].[T_Maquina] TO [britany]
GO
use [DB_TEXACO]
GO
GRANT VIEW DEFINITION ON [dbo].[T_Maquina] TO [britany]
GO

-- Rodfox -> lectura y escritura en una sola DB
USE [master]
GO
CREATE LOGIN [rodfox] WITH PASSWORD=N'rodfox123' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
USE [DB_TEXACO]
GO
CREATE USER [rodfox] FOR LOGIN [rodfox]
GO
ALTER ROLE [db_datareader] ADD MEMBER [rodfox]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [rodfox]
GO
GRANT INSERT ON [dbo].[T_Articulos] TO [rodfox]
GO
GRANT SELECT ON [dbo].[T_Articulos] TO [rodfox]
GO
DENY ALTER ON [dbo].[T_Articulos] TO [rodfox]
GO
DENY UPDATE ON [dbo].[T_Articulos] TO [rodfox]
GO
GRANT INSERT ON [dbo].[T_Trabajador] TO [rodfox]
GO
GRANT SELECT ON [dbo].[T_Trabajador] TO [rodfox]
GO
DENY ALTER ON [dbo].[T_Trabajador] TO [rodfox]
GO
DENY CONTROL ON [dbo].[T_Trabajador] TO [rodfox]
GO
DENY DELETE ON [dbo].[T_Trabajador] TO [rodfox]
GO
DENY REFERENCES ON [dbo].[T_Trabajador] TO [rodfox]
GO
DENY TAKE OWNERSHIP ON [dbo].[T_Trabajador] TO [rodfox]
GO
DENY UPDATE ON [dbo].[T_Trabajador] TO [rodfox]
GO
DENY VIEW CHANGE TRACKING ON [dbo].[T_Trabajador] TO [rodfox]
GO
DENY VIEW DEFINITION ON [dbo].[T_Trabajador] TO [rodfox]
GO
GRANT INSERT ON [dbo].[T_Combustible] TO [rodfox]
GO
GRANT SELECT ON [dbo].[T_Combustible] TO [rodfox]
GO
DENY ALTER ON [dbo].[T_Combustible] TO [rodfox]
GO
DENY CONTROL ON [dbo].[T_Combustible] TO [rodfox]
GO
DENY DELETE ON [dbo].[T_Combustible] TO [rodfox]
GO
DENY REFERENCES ON [dbo].[T_Combustible] TO [rodfox]
GO
DENY TAKE OWNERSHIP ON [dbo].[T_Combustible] TO [rodfox]
GO
DENY UPDATE ON [dbo].[T_Combustible] TO [rodfox]
GO
DENY VIEW CHANGE TRACKING ON [dbo].[T_Combustible] TO [rodfox]
GO
DENY VIEW DEFINITION ON [dbo].[T_Combustible] TO [rodfox]
GO
GRANT INSERT ON [dbo].[T_Maquina] TO [rodfox]
GO
GRANT SELECT ON [dbo].[T_Maquina] TO [rodfox]
GO
DENY ALTER ON [dbo].[T_Maquina] TO [rodfox]
GO
DENY CONTROL ON [dbo].[T_Maquina] TO [rodfox]
GO
DENY DELETE ON [dbo].[T_Maquina] TO [rodfox]
GO
DENY REFERENCES ON [dbo].[T_Maquina] TO [rodfox]
GO
DENY TAKE OWNERSHIP ON [dbo].[T_Maquina] TO [rodfox]
GO
DENY UPDATE ON [dbo].[T_Maquina] TO [rodfox]
GO
DENY VIEW CHANGE TRACKING ON [dbo].[T_Maquina] TO [rodfox]
GO
DENY VIEW DEFINITION ON [dbo].[T_Maquina] TO [rodfox]
GO
GRANT INSERT ON [dbo].[T_Turnos] TO [rodfox]
GO
GRANT SELECT ON [dbo].[T_Turnos] TO [rodfox]
GO
DENY ALTER ON [dbo].[T_Turnos] TO [rodfox]
GO
DENY CONTROL ON [dbo].[T_Turnos] TO [rodfox]
GO
DENY DELETE ON [dbo].[T_Turnos] TO [rodfox]
GO
DENY REFERENCES ON [dbo].[T_Turnos] TO [rodfox]
GO
DENY TAKE OWNERSHIP ON [dbo].[T_Turnos] TO [rodfox]
GO
DENY UPDATE ON [dbo].[T_Turnos] TO [rodfox]
GO
DENY VIEW CHANGE TRACKING ON [dbo].[T_Turnos] TO [rodfox]
GO
DENY VIEW DEFINITION ON [dbo].[T_Turnos] TO [rodfox]
GO
GRANT INSERT ON [dbo].[T_Ventas_Art] TO [rodfox]
GO
GRANT SELECT ON [dbo].[T_Ventas_Art] TO [rodfox]
GO
DENY ALTER ON [dbo].[T_Ventas_Art] TO [rodfox]
GO
DENY CONTROL ON [dbo].[T_Ventas_Art] TO [rodfox]
GO
DENY DELETE ON [dbo].[T_Ventas_Art] TO [rodfox]
GO
DENY REFERENCES ON [dbo].[T_Ventas_Art] TO [rodfox]
GO
DENY TAKE OWNERSHIP ON [dbo].[T_Ventas_Art] TO [rodfox]
GO
DENY UPDATE ON [dbo].[T_Ventas_Art] TO [rodfox]
GO
DENY VIEW CHANGE TRACKING ON [dbo].[T_Ventas_Art] TO [rodfox]
GO
DENY VIEW DEFINITION ON [dbo].[T_Ventas_Art] TO [rodfox]
GO
GRANT INSERT ON [dbo].[T_Ventas_Com] TO [rodfox]
GO
GRANT SELECT ON [dbo].[T_Ventas_Com] TO [rodfox]
GO
DENY ALTER ON [dbo].[T_Ventas_Com] TO [rodfox]
GO
DENY CONTROL ON [dbo].[T_Ventas_Com] TO [rodfox]
GO
DENY DELETE ON [dbo].[T_Ventas_Com] TO [rodfox]
GO
DENY REFERENCES ON [dbo].[T_Ventas_Com] TO [rodfox]
GO
DENY TAKE OWNERSHIP ON [dbo].[T_Ventas_Com] TO [rodfox]
GO
DENY UPDATE ON [dbo].[T_Ventas_Com] TO [rodfox]
GO
DENY VIEW CHANGE TRACKING ON [dbo].[T_Ventas_Com] TO [rodfox]
GO
DENY VIEW DEFINITION ON [dbo].[T_Ventas_Com] TO [rodfox]
GO


-- Insert data into tables
INSERT INTO T_Articulos (Art_ArticulosId, Art_Nombre, Art_Precio, Art_Stock) VALUES(7, 'Liquido de freno', 5.25, 7)
GO

-- Cursor Procedure
 
DECLARE c_reporte_articulos CURSOR FOR  
SELECT Art_ArticulosId, Art_Nombre, Art_Stock
FROM T_Articulos;
OPEN c_reporte_articulos;
FETCH NEXT FROM c_reporte_articulos;  
WHILE @@FETCH_STATUS = 0  
   BEGIN  
      FETCH NEXT FROM c_reporte_articulos;  
   END;  
CLOSE c_reporte_articulos;  
DEALLOCATE c_reporte_articulos;  
GO
