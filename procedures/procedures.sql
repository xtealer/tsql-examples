-- Check tables available
SELECT TABLE_NAME 
FROM taller_1.INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'

-- Crea database y seleccionarla
CREATE DATABASE taller_1;
USE taller_1;

-- Crea tabla clientes
CREATE TABLE Clientes (
DNI VARCHAR(20) NOT NULL,
Apellidos VARCHAR(20) NOT NULL,
Nombre VARCHAR(20) NOT NULL,
Direccion VARCHAR(50) NOT NULL,
Telefono VARCHAR(20) NOT NULL,
Telefono2 VARCHAR(20) NOT NULL,
PRIMARY KEY (DNI)
);

-- Crea tabla coches
CREATE TABLE Coches (
	Matricula VARCHAR(20) NOT NULL,
	DNIPropietario VARCHAR(20) NOT NULL,
	Marca VARCHAR(20) NOT NULL,
	Modelo VARCHAR(15) NOT NULL,
	Color VARCHAR(15) NOT NULL,
	Km INT NOT NULL,
	PRIMARY KEY (Matricula),
	FOREIGN KEY (DNIPropietario) REFERENCES Clientes (DNI)
);

-- crea tabla reparaciones
CREATE TABLE Reparaciones (
	NumReparacion INT NOT NULL,
	Matricula VARCHAR(20) NOT NULL,
	Descripcion VARCHAR(100) NOT NULL,
	FechaEntrada DATETIME NOT NULL,
	FechaSalida DATETIME NOT NULL,
	Horas INT NOT NULL,
	PRIMARY KEY (NumReparacion),
	FOREIGN KEY (Matricula) REFERENCES Coches (Matricula)
);

-- crea tabla piezas
CREATE TABLE Piezas (
	Referencia INT NOT NULL,
	Descripcion VARCHAR(100) NOT NULL,
	Precio MONEY NOT NULL,
	Stock INT NOT NULL,
	PRIMARY KEY (Referencia)
);

-- crea tabla detalles reparacion
CREATE TABLE DetallesReparacion (
	NumReparacion INT NOT NULL,
	Referencia INT NOT NULL,
	Unidades INT NOT NULL,
	FOREIGN KEY (NumReparacion) REFERENCES Reparaciones (NumReparacion),
	FOREIGN KEY (Referencia) REFERENCES Piezas (Referencia)
);

GO
-- 1.Procedimiento para guardar una reparación a traves del detalle
CREATE PROCEDURE spI_DetallesReparacion (
    @NumReparacion INT,
    @Referencia INT,
	@Unidades INT
) AS
BEGIN
	INSERT INTO DetallesReparacion VALUES (@NumReparacion, @Referencia, @Unidades);
END;
GO

-- 2.Procedimiento para mostrar detalles del coche con el número de reparación
CREATE PROCEDURE spF_CocheNumReparacion (
	@NumReparacion INT
) AS
BEGIN
	SELECT
		c.Matricula AS Matricula,
		c.DNIPropietario AS DNI,
		c.Marca AS Marca,
		c.Modelo AS Modelo,
		c.Color AS Color,
		c.Km AS Km
	FROM
		Coches AS c INNER JOIN
		Reparaciones AS r ON c.Matricula = r.Matricula
	WHERE
		r.NumReparacion = @NumReparacion
END;
GO

-- 3. Procedimiento para obtener la descripcion completa de una reparacion
CREATE PROCEDURE spF_DescripcionReparacion (
	@NumReparacion INT
) AS
BEGIN
	SELECT 
		d.Referencia,
		p.Descripcion,
		d.Unidades,
		p.Precio
	FROM
		DetallesReparacion AS d RIGHT JOIN
		Piezas AS p ON d.Referencia = p.Referencia
	WHERE
		d.NumReparacion = @NumReparacion
END;
GO

-- Trigger para insertar reparaciones cuando se inserta un coche
CREATE TRIGGER Insertar_Reparaciones ON Coches FOR INSERT AS
BEGIN
	DECLARE @NumReparacion INT
	IF(SELECT MAX(NumReparacion) FROM Reparaciones) IS NOT NULL
		SELECT @NumReparacion = ((SELECT MAX(NumReparacion)+1 FROM Reparaciones))
	ELSE
		SELECT @NumReparacion = 1
    BEGIN
		INSERT Reparaciones
		SELECT @NumReparacion, INSERTED.Matricula, '', GETDATE(), GETDATE(), 0 FROM INSERTED
    END
END
GO

INSERT Clientes Values ('1-222-3333', 'VILLA', 'ALEXANDER', 'CHAME VIA INTER. AL LADO DEL CHINITO FOO FOO', '2345-6543', '555-4433');
INSERT Piezas Values (52, 'PARABRISAS FRONTAL MODEL #3', 140.00, 7);
INSERT Coches Values ('ZX7643', '1-222-3333', 'TESLA', 'MODEL 3', 'RED', 70000);

SELECT * FROM Coches;
SELECT * FROM Reparaciones;
SELECT * FROM DetallesReparacion
SELECT * FROM Piezas


--  llene las tablas con datos válidos y utilice los procedimientos para interactuar con los datos   use : 
EXEC spF_CocheNumReparacion 1
EXEC spI_DetallesReparacion 1, 52, 1;
EXEC spF_DescripcionReparacion 1