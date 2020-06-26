Ahora le toca cumplir con lo siguiente usando el servidor de microsoft:
1- haga las pruebas con estos ejemplos de cursores adaptandolos a tablas que hayamos utilizado
2-  cree un cursor nuevo,  de su propia autoria que desempeñe una tarea válida 


use ejemplodecursor
GO
Create table items(
item_id uniqueidentifier not null,
item_description varchar(250) not null
)

insert into items values(NEWID(),'Este es un auto maravilloso')
insert into items values(NEWID(),'Esta es una bicicleta rapida')
insert into items values(NEWID(),'Este es un avion caro')
insert into items values(NEWID(),'Esta es una bicicleta barata')
insert into items values(NEWID(),'Esto es una vacaciones de ensueño')

select * from items
declare @item uniqueidentifier



DECLARE ITEM_CURSOR CURSOR FOR  SELECT item_id FROM items
OPEN ITEM_CURSOR 
FETCH NEXT FROM ITEM_CURSOR INTO @item

while @@FETCH_STATUS=0
BEGIN
select ITEM_DESCRIPTION FROM items WHERE item_id=@item
FETCH NEXT FROM ITEM_CURSOR INTO @item
END
CLOSE ITEM_CURSOR
DEALLOCATE ITEM_CURSOR



/**************************************************************************************/


--PRIMER EJEMPLO
DECLARE @cliente_id MICURSOR CURSOR
for 
select cliente_id from CLIENTES
open micursor
fetch next from micurso into @cliente_id 
while @@FETCH_STATUS = 0
BEGIN 
SELECT cliente_nom, cliente_salario*1.05 as Aumento from clientes where cliente_id = @cliente_id
exec proceaumento @cliente_id ,0.05 
fetch next from MICURSOR INTO @cliente_id  
close micurso
DEALLOCATE MICURSO


--SEGUNDO EJEMPLO
DROP PROCEDURE IF EXISTS REPORTE
GO
CREATE PROCEDURE REPORTE
as

DECLARE @MATRICULA VARCHAR(8), @AUTO VARCHAR(90),@COLOR VARCHAR(24),@NOMBRE VARCHAR(24)

DECLARE MICURSOR CURSOR 
FOR SELECT 
C.MATRICULA, 
(C.MARCA + ' '+C.MODELO) AS AUTOS,
C.color,
CL.NOMBRE AS PROPIETARIO 
FROM CLIENTESS CL INNER JOIN COCHESS C ON CL.DNI=C.dni_propietario

OPEN  MICURSOR
FETCH MICURSOR INTO @MATRICULA,@AUTO,@COLOR,@NOMBRE
--IMPRIMIR REPORTE
PRINT 'MATRICULA       AUTOS       COLOR       NOMBRE'   
PRINT '--------------------------------------------------------------'
--AGREGAR DETALLES
WHILE @@FETCH_STATUS=0
BEGIN
PRINT @MATRICULA+SPACE(7)+@AUTO+SPACE(7)+
	@COLOR+SPACE(7)+@NOMBRE+SPACE(7)
	FETCH MICURSOR INTO @MATRICULA,@AUTO,@COLOR,@NOMBRE
 
END
CLOSE MICURSOR
DEALLOCATE MICURSOR
GO
EXEC REPORTE
