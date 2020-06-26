create database PARCIAL;   
use PARCIAL;  
GO

CREATE TABLE CLIENTES (
DNI INT,
APELLIDO VARCHAR(18),
NOMBRE varchar(18),
DIRECCION varchar(18),
CP varchar(18),
POBLACION varchar(18),
TELEFONO varchar(18),
TELEFONO2 varchar(18),
PRIMARY KEY (DNI)
);  
GO
insert into CLIENTES values(1,'RODRIGUEZ','ANA','CHORRERA','11CP','21P','231-2332','62145652')
insert into CLIENTES values(2,'REYES','EDILMA','ARRAIJAN','12CP','22P','231-5757','3767652')
insert into CLIENTES values(3,'LEZCANO','JOSE','CHAME','13CP','23P','231-5743','62457442')
insert into CLIENTES values(4,'ALMANZA','YENIA','CAPIRA','14CP','24P','231-4652','6247652')
insert into CLIENTES values(5,'ESPINOZA','GABRIEL','SAN CARLOS','25CP','25P','231-2212','674376776')
insert into CLIENTES values(6,'ESPINO','JAMES','ARRAIJAN','29CP','21P','222-2212','554376446')


CREATE TABLE COCHES (
matricula varchar(5),	
dni_propietario int,
marca varchar(18),
modelo varchar(18),
color varchar(18),
km varchar(18),
PRIMARY KEY (matricula),
FOREIGN KEY (dni_propietario) REFERENCES CLIENTES(DNI)
);
GO
insert into COCHES values('11F',1,'FORD','RANGER','ROJO','90KM')
insert into COCHES values('12F',2,'TOYOTA','HILUX','AZUL','125KM')
insert into COCHES values('13F',3,'CHEVROLET','SPARK','CELESTE','130KM')
insert into COCHES values('14F',4,'KIA','PICANTO','NEGRO','90KM')
insert into COCHES values('15F',5,'SUBARU','BRZ','BLANCO','125KM')
 
CREATE TABLE REPARACIONES (
numreparaciones int,
matricula varchar(5),
descripcion varchar(18),
fechaE date,
fechaS date,
horas varchar(18),
totalapagar money,
PRIMARY KEY (numreparaciones),
FOREIGN KEY (matricula) REFERENCES COCHES(matricula)
);
GO
insert into REPARACIONES values(101,'11F','BATERIA','2019-05-21','2019-06-22','50H',0.00)
insert into REPARACIONES values(102,'12F','TRANSMISION','2019-01-01','2019-01-03','30H',0.00)
insert into REPARACIONES values(103,'13F','SERVOFRENO','2019-02-20','2019-03-01','60H',0.00)
insert into REPARACIONES values(104,'14F','RADIADOR','2019-04-01','2019-04-12','54H',0.00)
insert into REPARACIONES values(105,'15F','AMORTIGUADOR','2019-08-08','2019-09-20','33H',0.00)
insert into REPARACIONES values(106,'13F','AMORTIGUADOR','2019-02-01','2019-03-01','60H',0.00)

CREATE TABLE PIEZAS(
referencia varchar(5),
DESCRIPCION varchar(18),
PRECIO money,
STOCK varchar(18),
PRIMARY KEY(REFERENCIA) 
);
GO
insert into PIEZAS values('11R','BATERIA',90,'100')
insert into PIEZAS values('12R','TRANSMISION',500,'89')
insert into PIEZAS values('13R','SERVOFRENO',250,'75')
insert into PIEZAS values('14R','RADIADOR',230,'32')
insert into PIEZAS values('15R','AMORTIGUADOR',390,'21')
insert into PIEZAS values('16R','VIDRIO',20,'7')
insert into PIEZAS values('17R','RETROVISOR',23,'2')
insert into PIEZAS values('18R','DEFENSA',30,'11')

CREATE TABLE DETALLESREPARACION (
nreparacion int,
referencia varchar(5),
unidades int,
FOREIGN KEY (nreparacion) REFERENCES REPARACIONES(numreparaciones),
FOREIGN KEY(REFERENCIA)  REFERENCES PIEZAS(REFERENCIA)
);
GO
insert into DETALLESREPARACION values(101,'11R',1)
insert into DETALLESREPARACION values(102,'12R',2)
insert into DETALLESREPARACION values(103,'13R',2)
insert into DETALLESREPARACION values(104,'14R',4)
insert into DETALLESREPARACION values(105,'15R',1)

CREATE TABLE RESUMEN(
secuencia bigint primary key not null,
CANTreparaciones int,
cliente int,
totalpagado money,
FOREIGN KEY (cliente) REFERENCES clientes(dni)
);
GO
insert into RESUMEN values(10001,1,1,200.00)
GO
insert into RESUMEN values(10002,12,2,250.00)
GO
insert into RESUMEN values(10003,3,3,290.00)
GO
insert into RESUMEN values(10004,1,4,253.00)
GO
insert into RESUMEN values(10005,6,5,207.00)
GO


-- PROCEDURES
-- Procedimiento para agregar pieza nueva
CREATE PROCEDURE sp_CrearPieza (@ref VARCHAR(5), @description VARCHAR(18),
@precio MONEY, @stock VARCHAR(18)) AS BEGIN
DECLARE @tempref VARCHAR(5);
SELECT @tempref = (SELECT P.referencia FROM PIEZAS AS P WHERE P.referencia = @ref);
BEGIN TRANSACTION
	IF @tempref IS NOT NULL
	BEGIN
		RAISERROR('La Pieza ya existe en el sistema', 1, 10);
		ROLLBACK TRANSACTION;
	END;
	ELSE
	BEGIN
		PRINT 'Creando nueva pieza en el sistema';
		INSERT INTO PIEZAS VALUES(@ref, @description, @precio, @stock);
		COMMIT TRANSACTION;
	END;
END
GO

-- Procedimiento para encontrar el precio de una pieza por referencia
CREATE PROCEDURE fp_CostoPieza (@ref VARCHAR(5)) AS
DECLARE @tempref VARCHAR(5);
SELECT @tempref = (SELECT P.referencia FROM PIEZAS AS P WHERE P.referencia = @ref);
BEGIN
BEGIN TRANSACTION
	IF @tempref IS NULL
	BEGIN
		RAISERROR('La Pieza NO EXISTE en el sistema', 1, 10);
		ROLLBACK TRANSACTION;
	END;
	ELSE
	BEGIN
		SELECT P.DESCRIPCION, P.PRECIO, P.STOCK FROM PIEZAS AS P WHERE P.referencia = @ref;
		COMMIT TRANSACTION;
	END;
END
GO


-- Procedures TEST
-- agregar pieza
EXEC sp_CrearPieza '11R','BATERIA',90,'100';
GO
-- Precio de pieza por referencia
EXEC fp_CostoPieza '11R';
GO


-- TRIGGERS
-- trigger que actualiza el total de la reparacion al agregar un detalle
CREATE TRIGGER ActualizarTotalReparacion ON DETALLESREPARACION FOR INSERT AS
BEGIN
	DECLARE @costopieza MONEY;
	DECLARE @cant int;
	SELECT @cant = (SELECT nc.unidades FROM inserted as nc);
	SELECT @costopieza = (SELECT P.PRECIO FROM PIEZAS AS P WHERE P.referencia = (SELECT i.referencia FROM inserted as i))*@cant;
	UPDATE REPARACIONES SET totalapagar += @costopieza WHERE REPARACIONES.numreparaciones = (SELECT i.nreparacion FROM inserted as i);
END;
GO

-- Trigger que crea nuevo resumen al crear un nuevo cliente
CREATE TRIGGER CrearResumenCliente ON CLIENTES FOR INSERT AS
BEGIN
	BEGIN TRANSACTION
	DECLARE @cliente INT;
	SELECT @cliente = (SELECT i.DNI FROM inserted as i);
	INSERT INTO RESUMEN VALUES(1000 + @cliente, 0, @cliente, 0.00);
	COMMIT  TRANSACTION;
END;
GO
