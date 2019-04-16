CREATE TABLE auditoria(
usuario varchar (50),
tabla varchar (50),
accion varchar (50),
filas_afect int, 
fecha datetime
)

CREATE TABLE prueba(
id int,
nombre varchar (50)
)
drop table prueba

CREATE TRIGGER trig_prueba_inserted
ON prueba
after insert
AS 
	BEGIN 
		declare @tabla varchar(50), @accion varchar (10), @filas int, @fecha datetime
		set @tabla = 'prueba'
		select @filas = count(*) from inserted
		select @fecha = getdate()
		set @accion = 'I'
		insert into auditoria(usuario, tabla, accion, filas_afect, fecha)
		values (SYSTEM_USER, @tabla, @accion, @filas, @fecha)
	END

CREATE TRIGGER trig_prueba_update
ON prueba
after update
AS 
	BEGIN 
		declare @tabla varchar(50), @accion varchar (10), @filas_ins int, @filas_del int, @fecha datetime
		set @tabla = 'prueba'
		select @filas_ins = count(*) from inserted
		select @filas_del = count(*) from deleted
		select @fecha = getdate()
		set @accion = 'U'
		
		if(@filas_ins = @filas_del)
		begin
			insert into auditoria(usuario, tabla, accion, filas_afect, fecha)
			values (SYSTEM_USER, @tabla, @accion, @filas_ins, @fecha)
		end 
	END

CREATE TRIGGER trig_prueba_deleted
ON prueba
after delete
AS 
	BEGIN 
		declare @tabla varchar(50), @accion varchar (10), @filas int, @fecha datetime
		set @tabla = 'prueba'
		select @filas = count(*) from deleted
		select @fecha = getdate()
		set @accion = 'D'
		insert into auditoria(usuario, tabla, accion, filas_afect, fecha)
		values (SYSTEM_USER, @tabla, @accion, @filas, @fecha)
	END
		 
		 
insert into prueba (id, nombre) values (1, 'juan')
insert into prueba (id, nombre) values (2, 'gambito')


select * 
from auditoria

