DROP DATABASE IF EXISTS EduManage;

CREATE DATABASE IF NOT EXISTS EduManage CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE EduManage;

-- Tabla Profesores
CREATE TABLE IF NOT EXISTS tb_profesores (
    id_profesor VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT(UUID()),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL, 
    correo_electronico VARCHAR(100) NOT NULL UNIQUE
) ENGINE=INNODB;

-- Tabla Alumnos 
CREATE TABLE IF NOT EXISTS tb_alumnos (
    id_alumno VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT(UUID()), 
    carnet_alumno VARCHAR(10) UNIQUE NOT NULL, 
    nombre_alumno VARCHAR(50) NOT NULL, 
    apellido_alumno VARCHAR(50) NOT NULL, 
    edad_alumno INT NOT NULL CHECK (edad_alumno >= 0 AND edad_alumno <= 100)
) ENGINE=INNODB;


-- Tabla Materias
CREATE TABLE IF NOT EXISTS tb_materias (
    id_materia VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT(UUID()), 
    nombre_materia VARCHAR(100) UNIQUE NOT NULL,
    grupo_materia INT NOT NULL CHECK (grupo_materia > 0), 
    id_profesor VARCHAR(36), 
    cupos INT CHECK (cupos >= 0),
    FOREIGN KEY (id_profesor) REFERENCES tb_profesores(id_profesor)
) ENGINE=INNODB;

-- Tabla Inscripciones 
CREATE TABLE IF NOT EXISTS tb_inscripciones (
    id_inscripcion VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT(UUID()), 
    id_alumno VARCHAR(36) NOT NULL,
    id_materia VARCHAR(36) NOT NULL, 
    fecha_inscripcion DATE NOT NULL DEFAULT CURRENT_DATE, 
    estado ENUM ('Activo', 'Inactivo') NOT NULL,
    UNIQUE (id_alumno, id_materia),
    FOREIGN KEY (id_alumno) REFERENCES tb_alumnos(id_alumno), 
    FOREIGN KEY (id_materia) REFERENCES tb_materias(id_materia)
) ENGINE=INNODB;


-- Tabla calificaciones 
CREATE TABLE IF NOT EXISTS tb_calificaciones (
    id_calificacion VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT(UUID()), 
    id_inscripcion VARCHAR(36) NOT NULL,
    calificacion_final DECIMAL(5,2) NOT NULL, 
    fecha_calificacion DATE NOT NULL DEFAULT CURRENT_DATE, 
    FOREIGN KEY (id_inscripcion) REFERENCES tb_inscripciones(id_inscripcion),
    CONSTRAINT positivo CHECK (calificacion_final >= 0  AND calificacion_final <= 100) 
)ENGINE=INNODB;



DELIMITER //
-- Procedure Agregar Profesor 

CREATE PROCEDURE agregar_profesor(
    IN nombre_profesor VARCHAR(100),
    IN apellido_profesor VARCHAR(100),
    IN correo_electronico_profesor VARCHAR(100)
)
BEGIN
    INSERT INTO tb_profesores (nombre, apellido, correo_electronico) 
    VALUES (nombre_profesor, apellido_profesor, correo_electronico_profesor);
END//

DELIMITER ;


DELIMITER //
-- Procedure Agregar Estudiantes 
CREATE PROCEDURE agregar_estudiante(
    IN carnet_alumno VARCHAR(10),
    IN nombre_alumno VARCHAR(50),
    IN apellido_alumno VARCHAR(50),
    IN edad_alumno INT
)
BEGIN
    INSERT INTO tb_alumnos (carnet_alumno, nombre_alumno, apellido_alumno, edad_alumno) 
    VALUES (carnet_alumno, nombre_alumno, apellido_alumno, edad_alumno);
END//

DELIMITER ;

DELIMITER //
-- Procedure Agregar Materia 
CREATE PROCEDURE agregar_materia(
    IN nombre_materia VARCHAR(100),
    IN grupo_materia INT,
    IN id_profesor VARCHAR(36),
    IN cupos INT
)
BEGIN
    INSERT INTO tb_materias (nombre_materia, grupo_materia, id_profesor, cupos) 
    VALUES (nombre_materia, grupo_materia, id_profesor, cupos);
END//

DELIMITER ;

DELIMITER //
-- Procedure Agregar Inscipciones 
CREATE PROCEDURE agregar_incripciones(
    IN id_alumno VARCHAR(36),
    IN id_materia VARCHAR(36),
    IN estado ENUM ('Activo', 'Inactivo')
)
BEGIN
    INSERT INTO tb_inscripciones (id_alumno, id_materia, estado) 
    VALUES (id_alumno, id_materia, estado);
END//

DELIMITER ;


DELIMITER //
-- Procedure Agregar Calificaciones 
CREATE PROCEDURE agregar_calificaciones(
    IN id_inscripcion VARCHAR(36),
    IN calificacion_final DECIMAL(5,2)
)
BEGIN
    INSERT INTO tb_calificaciones (id_inscripcion, calificacion_final) 
    VALUES (id_inscripcion, calificacion_final);
END//

DELIMITER ;


DELIMITER //

DELIMITER //
-- TRIGGER
CREATE TRIGGER actualizar_cupos_despues_inscripcion
AFTER INSERT ON tb_inscripciones
FOR EACH ROW
BEGIN
    UPDATE tb_materias
    SET cupos = cupos - 1
    WHERE id_materia = NEW.id_materia;
END;


DELIMITER ;
DELIMITER //

-- Agregar profesor

CALL agregar_profesor('John', 'Doe', 'john.doe@example.com');
CALL agregar_profesor('Jane', 'Smith', 'jane.smith@example.com');
CALL agregar_profesor('Michael', 'Johnson', 'michael.johnson@example.com');
CALL agregar_profesor('Emily', 'Brown', 'emily.brown@example.com');
CALL agregar_profesor('David', 'Wilson', 'david.wilson@example.com');
CALL agregar_profesor('Sarah', 'Martinez', 'sarah.martinez@example.com');
CALL agregar_profesor('Christopher', 'Anderson', 'christopher.anderson@example.com');
CALL agregar_profesor('Jessica', 'Taylor', 'jessica.taylor@example.com');
CALL agregar_profesor('Matthew', 'Thomas', 'matthew.thomas@example.com');
CALL agregar_profesor('Laura', 'Hernandez', 'laura.hernandez@example.com');
CALL agregar_profesor('Daniel', 'Moore', 'daniel.moore@example.com');
CALL agregar_profesor('Elizabeth', 'Walker', 'elizabeth.walker@example.com');
CALL agregar_profesor('Kevin', 'Young', 'kevin.young@example.com');
CALL agregar_profesor('Amanda', 'White', 'amanda.white@example.com');
CALL agregar_profesor('Ryan', 'King', 'ryan.king@example.com');

SELECT id_profesor FROM tb_profesores;


-- Agregar Alumnos 
CALL agregar_estudiante('20230001', 'Maria', 'Garcia', 20);
CALL agregar_estudiante('20230002', 'Juan', 'Rodriguez', 21);
CALL agregar_estudiante('20230003', 'Ana', 'Martinez', 22);
CALL agregar_estudiante('20230004', 'Carlos', 'Lopez', 19);
CALL agregar_estudiante('20230005', 'Laura', 'Perez', 20);
CALL agregar_estudiante('20230006', 'Pedro', 'Gonzalez', 21);
CALL agregar_estudiante('20230007', 'Sofia', 'Sanchez', 20);
CALL agregar_estudiante('20230008', 'Diego', 'Torres', 19);
CALL agregar_estudiante('20230009', 'Valeria', 'Ramirez', 20);
CALL agregar_estudiante('20230010', 'Daniel', 'Flores', 21);
CALL agregar_estudiante('20230011', 'Mariana', 'Diaz', 20);
CALL agregar_estudiante('20230012', 'Alejandro', 'Hernandez', 22);
CALL agregar_estudiante('20230013', 'Fernanda', 'Gomez', 19);
CALL agregar_estudiante('20230014', 'Gabriel', 'Muñoz', 20);
CALL agregar_estudiante('20230015', 'Andrea', 'Castro', 21);

SELECT * FROM tb_alumnos;

-- Agregar Materias
-- Agregar Materias
CALL agregar_materia('Matemáticas I', 1, 'a0470274-d65a-11ee-b494-d8bbc1ad5156', 30);
CALL agregar_materia('Matemáticas II', 2, 'a045f3ab-d65a-11ee-b494-d8bbc1ad5156', 25);
CALL agregar_materia('Física I', 1, 'a046991a-d65a-11ee-b494-d8bbc1ad5156', 30);
CALL agregar_materia('Física II', 2, 'a045b44c-d65a-11ee-b494-d8bbc1ad5156', 25);
CALL agregar_materia('Química I', 1, 'a046bf29-d65a-11ee-b494-d8bbc1ad5156', 30);
CALL agregar_materia('Química II', 2, 'a0456da8-d65a-11ee-b494-d8bbc1ad5156', 25);
CALL agregar_materia('Historia', 1, 'a04508a7-d65a-11ee-b494-d8bbc1ad5156', 30);
CALL agregar_materia('Geografía', 2, 'a0461aa4-d65a-11ee-b494-d8bbc1ad5156', 25);
CALL agregar_materia('Literatura', 1, 'a044eb31-d65a-11ee-b494-d8bbc1ad5156', 30);
CALL agregar_materia('Arte', 2, 'a046db6a-d65a-11ee-b494-d8bbc1ad5156', 25);
CALL agregar_materia('Biología', 1, 'a046707f-d65a-11ee-b494-d8bbc1ad5156', 30);
CALL agregar_materia('Educación Física', 2, 'a0464245-d65a-11ee-b494-d8bbc1ad5156', 25);
CALL agregar_materia('Inglés I', 1, 'a0452b57-d65a-11ee-b494-d8bbc1ad5156', 30);
CALL agregar_materia('Inglés II', 2, 'a04720f3-d65a-11ee-b494-d8bbc1ad5156', 25);
CALL agregar_materia('Informática', 1, 'a045d51f-d65a-11ee-b494-d8bbc1ad5156', 30);

SELECT * FROM tb_materias;

-- Agregar Inscripciones
CALL agregar_incripciones('a047624d-d65a-11ee-b494-d8bbc1ad5156', 'e0b8cc7b-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a0477c0e-d65a-11ee-b494-d8bbc1ad5156', 'e0b7e8c3-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a047a9d8-d65a-11ee-b494-d8bbc1ad5156', 'e0baa0f9-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a047d517-d65a-11ee-b494-d8bbc1ad5156', 'e0b74830-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a04800c3-d65a-11ee-b494-d8bbc1ad5156', 'e0b6b7ec-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a0484bb1-d65a-11ee-b494-d8bbc1ad5156', 'e0bbafb9-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a048cf0a-d65a-11ee-b494-d8bbc1ad5156', 'e0b5d57d-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a0492c2e-d65a-11ee-b494-d8bbc1ad5156', 'e0b83baa-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a0494eb2-d65a-11ee-b494-d8bbc1ad5156', 'e0ba1b1f-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a04972ac-d65a-11ee-b494-d8bbc1ad5156', 'e0b99882-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a049914a-d65a-11ee-b494-d8bbc1ad5156', 'e0b63c49-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a049b22a-d65a-11ee-b494-d8bbc1ad5156', 'e0b6fb67-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a049cf19-d65a-11ee-b494-d8bbc1ad5156', 'e0b911dc-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a049ee67-d65a-11ee-b494-d8bbc1ad5156', 'e0b5008f-d65a-11ee-b494-d8bbc1ad5156', 'Activo');
CALL agregar_incripciones('a04a0d51-d65a-11ee-b494-d8bbc1ad5156', 'e0bb2020-d65a-11ee-b494-d8bbc1ad5156', 'Activo');

SELECT * FROM tb_inscripciones;


-- Agregar Calificaciones
CALL agregar_calificaciones('6d5328e8-d65b-11ee-b494-d8bbc1ad5156', 85.5);
CALL agregar_calificaciones('6d4fdfde-d65b-11ee-b494-d8bbc1ad5156', 70.2);
CALL agregar_calificaciones('6d51ccdd-d65b-11ee-b494-d8bbc1ad5156', 95.8);
CALL agregar_calificaciones('6d4ebdab-d65b-11ee-b494-d8bbc1ad5156', 60.0);
CALL agregar_calificaciones('6d525361-d65b-11ee-b494-d8bbc1ad5156', 78.9);
CALL agregar_calificaciones('6d4e2c85-d65b-11ee-b494-d8bbc1ad5156', 88.3);
CALL agregar_calificaciones('6d4d0ba3-d65b-11ee-b494-d8bbc1ad5156', 92.1);
CALL agregar_calificaciones('6d5026dd-d65b-11ee-b494-d8bbc1ad5156', 85.7);
CALL agregar_calificaciones('6d4cb2a8-d65b-11ee-b494-d8bbc1ad5156', 70.5);
CALL agregar_calificaciones('6d52dc9b-d65b-11ee-b494-d8bbc1ad5156', 78.0);
CALL agregar_calificaciones('6d514d33-d65b-11ee-b494-d8bbc1ad5156', 95.0);
CALL agregar_calificaciones('6d50bf39-d65b-11ee-b494-d8bbc1ad5156', 82.4);
CALL agregar_calificaciones('6d4d60ea-d65b-11ee-b494-d8bbc1ad5156', 67.8);
CALL agregar_calificaciones('6d536d57-d65b-11ee-b494-d8bbc1ad5156', 90.6);
CALL agregar_calificaciones('6d4f51af-d65b-11ee-b494-d8bbc1ad5156', 75.3);

SELECT * FROM tb_calificaciones;