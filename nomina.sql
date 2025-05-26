CREATE DATABASE nomina;
USE nomina;

-- tabla tipo_documento
CREATE TABLE tipo_documento(
	id_tipo_documento INT AUTO_INCREMENT PRIMARY KEY,
    tipo_documento VARCHAR(60) NOT NULL,
    descripcion TEXT,
    
    -- integridad de la data
    CONSTRAINT check_tipo_documento
		CHECK (tipo_documento REGEXP '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ ._]+$')
);


-- tabla tipo_via
CREATE TABLE tipo_via(
	id_via INT AUTO_INCREMENT PRIMARY KEY,
    nombre_via VARCHAR(24) NOT NULL,
    
    -- integridad de la data
    CONSTRAINT check_nombre_via
		CHECK (nombre_via REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ._]+$')
);

-- tabla tipo_contrato
CREATE TABLE tipo_contrato(
	id_tipo_contrato INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo_contrato VARCHAR(40) NOT NULL,
    
    -- integridad de la data
    CONSTRAINT check_nombre_tipo_contrato
		CHECK (nombre_tipo_contrato REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ._]+$')
);

-- tabla tipo_noveda
CREATE TABLE tipo_novedad(
	id_tipo_novedad INT AUTO_INCREMENT PRIMARY KEY,
    nombre_novedad VARCHAR(60) NOT NULL,
    afecta_nomina BOOLEAN DEFAULT TRUE,
    
    -- integridad de la data
    CONSTRAINT check_nombre_novedad
		CHECK (nombre_novedad REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ._]+$')
);

-- tabla paises
CREATE TABLE paises(
	id_pais INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pais VARCHAR(40) NOT NULL UNIQUE,
    
    -- integridad de la data
    CONSTRAINT check_nombre_pais
		CHECK (nombre_pais REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ._]+$')
);

-- tabla departamentos
CREATE TABLE departamentos(
	id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_departamento VARCHAR(30) NOT NULL,
    id_pais INT NOT NULL CHECK (id_pais > 0),
    
    -- referencias
    FOREIGN KEY (id_pais) REFERENCES paises(id_pais),
    
    -- integridad de data
    CONSTRAINT check_nombre_departamento
		CHECK (nombre_departamento REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ]+$')
);

-- tabla ciudades
CREATE TABLE ciudades (
	id_ciudad INT  AUTO_INCREMENT PRIMARY KEY,
    nombre_ciudad VARCHAR(40),
    id_departamento INT NOT NULL CHECK (id_departamento > 0),
    id_pais INT NOT NULL CHECK (id_pais > 0),
    
    -- referencias
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
    FOREIGN KEY (id_pais) REFERENCES paises(id_pais),
    
    -- integridad de la data
    CONSTRAINT check_nombre_ciudad
		CHECK (nombre_ciudad REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ]+$')
);

-- tabla barrios
CREATE TABLE barrios(
	id_barrio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_barrio VARCHAR(30) NOT NULL,
    id_ciudad INT NOT NULL,
    id_departamento INT NOT NULL,
    id_pais INT NOT NULL,
    
    -- referencias
    FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad),
    FOREIGN KEY (id_pais) REFERENCES paises(id_pais),
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
    
    -- integridad de la data
    CONSTRAINT check_nombre_barrio
		CHECK (nombre_barrio REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ]+$'),
	CONSTRAINT check_id
		CHECK ( (id_ciudad> 0) AND (id_departamento > 0) AND (id_pais >0))
		
);

-- tabla areas
CREATE TABLE areas(
	id_area INT AUTO_INCREMENT PRIMARY KEY,
    nombre_area VARCHAR(30) NOT NULL,
    descripcion TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP CHECK(fecha_creacion >= '1900-01-01 00:00:00'),
    
    -- integridad de datos
    CONSTRAINT check_texto
		CHECK ( (nombre_area REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ._]+$') AND (descripcion REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ._]+$' ))
);

-- tabla cargos
CREATE TABLE cargos(
	id_cargo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cargo VARCHAR(50) NOT NULL,
    funcion TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP CHECK(fecha_creacion >= '1900-01-01 00:00:00'),
    id_area INT NOT NULL CHECK(id_area > 0),
    
    -- referencias
    FOREIGN KEY (id_area) REFERENCES areas(id_area),
    
    -- integridad de datos 
    CONSTRAINT check_texto_cargos
		CHECK ( (nombre_cargo REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ._]+$') AND (funcion REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ._]+$'))
);

-- tabla sucursales
CREATE TABLE sucursales(
	id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    telefono VARCHAR(20) NOT NULL UNIQUE,
    id_via INT NOT NULL,
    numeros_direccion VARCHAR(30) NOT NULL,
    id_barrio INT NOT NULL,
    id_ciudad INT NOT NULL,
    id_departamento INT NOT NULL,
    id_pais INT NOT NULL,
    
    -- referencias
    FOREIGN KEY (id_via) REFERENCES tipo_via(id_via),
    FOREIGN KEY (id_barrio) REFERENCES barrios(id_barrio),
    FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad),
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
    FOREIGN KEY (id_pais) REFERENCES paises(id_pais),
    
    -- integridad de datos
	CONSTRAINT check_id_sucursales
		CHECK ( (id_via >0) AND (id_barrio >0) AND (id_ciudad >0) AND (id_departamento >0) AND (id_pais >0))
);



-- tabla empleados
CREATE TABLE empleados(
	id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    id_tipo_documento INT NOT NULL,
    numero_documento INT NOT NULL UNIQUE CHECK (numero_documento > 0),
    primer_nombre VARCHAR(20) NOT NULL CHECK (primer_nombre REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ]+$'),
    segundo_nombre VARCHAR(20) CHECK (segundo_nombre REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ]*$'),
    primer_apellido VARCHAR(20) NOT NULL CHECK (primer_apellido REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ]+$'),
    segundo_apellido VARCHAR(20) NOT NULL CHECK (segundo_apellido REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ ]+$'),
    email VARCHAR(50) NOT NULL UNIQUE CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),
    telefono VARCHAR(40) NOT NULL UNIQUE CHECK (telefono REGEXP '^(\\+\\d{1,3}-)?\\d{3}-\\d{7}$'),
    id_via INT NOT NULL,
    numeros_direccion VARCHAR(30) NOT NULL CHECK (numeros_direccion REGEXP '^[A-Za-z0-9#\\- ]+$'),
    id_barrio INT NOT NULL CHECK (id_barrio >0),
    id_ciudad INT NOT NULL CHECK (id_ciudad >0),
    id_departamento INT NOT NULL CHECK (id_departamento >0),
    id_pais INT NOT NULL CHECK (id_pais >0),
    id_cargo INT NOT NULL CHECK (id_cargo >0),
    id_area INT NOT NULL CHECK (id_area >0),
    id_sucursal INT NOT NULL CHECK (id_sucursal >0),
    fecha_nacimiento DATE NOT NULL,
    fecha_ingreso DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- referencias
    FOREIGN KEY (id_tipo_documento) REFERENCES tipo_documento(id_tipo_documento),
    FOREIGN KEY (id_via) REFERENCES tipo_via(id_via),
    FOREIGN KEY (id_barrio) REFERENCES barrios(id_barrio),
    FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad),
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
    FOREIGN KEY (id_pais) REFERENCES paises(id_pais),
    FOREIGN KEY (id_cargo) REFERENCES cargos(id_cargo),
    FOREIGN KEY (id_area) REFERENCES areas(id_area),
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

-- tabla contratos
CREATE TABLE contratos(
	id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    id_tipo_contrato INT NOT NULL CHECK(id_tipo_contrato >0),
    id_empleado INT NOT NULL CHECK(id_empleado >0),
    fecha_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_finalizacion DATE DEFAULT NULL ,
    salario_base DECIMAL(10,2) NOT NULL DEFAULT 1 CHECK (salario_base >= 1),
    estado BOOLEAN DEFAULT TRUE,
    
    -- referencias
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_tipo_contrato) REFERENCES tipo_contrato(id_tipo_contrato)
);

-- tabla sucursales_areas
CREATE TABLE sucursales_areas(
	id_sucursal INT NOT NULL CHECK(id_sucursal >0),
    id_area INT NOT NULL CHECK(id_area >0),
    id_empleado INT NOT NULL CHECK(id_empleado >0),
    fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado BOOLEAN DEFAULT TRUE,
    descripcion TEXT NOT NULL CHECK (descripcion REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ0-9 .,_-]+$'),
    PRIMARY KEY (id_sucursal, id_area),
    
    -- referencias
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal),
    FOREIGN KEY (id_area) REFERENCES areas(id_area),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- tabla nomina
CREATE TABLE nomina(
	id_nomina INT AUTO_INCREMENT PRIMARY KEY,
    estado BOOLEAN DEFAULT TRUE,
    total_devengado DECIMAL(10,2) DEFAULT 0 CHECK (total_devengado >= 0),
    total_deducciones DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (total_deducciones >= 0),
    total_pagar DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (total_pagar >= 0),
    id_empleado INT NOT NULL,
    salario_base INT NOT NULL,
    fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_nomina_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
    
);






-- tabla novedades
CREATE TABLE novedades(
	id_novedad INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_tipo_novedad INT NOT NULL,
    fecha_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_fin DATETIME DEFAULT CURRENT_TIMESTAMP ,
    descripcion VARCHAR(200) DEFAULT NULL,
	dias_afectados INT NOT NULL CHECK(dias_afectados > 0),
    
    -- referencias
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_tipo_novedad) REFERENCES tipo_novedad(id_tipo_novedad)
);



-- tabla comisiones
CREATE TABLE comisiones(
	id_comision INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    vendido INT CHECK (vendido >= 0),
    
    -- referencias
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- tabla prestamos
CREATE TABLE prestamos(
	id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    numero_cuotas INT NOT NULL CHECK (numero_cuotas > 0),
    valor_cuotas INT NOT NULL CHECK (valor_cuotas > 0),
    fecha_prestamo DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- referencias
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- tabla cuotas_prestamos
CREATE TABLE cuotas_prestamos(
	id_cuota INT AUTO_INCREMENT PRIMARY KEY,
    id_nomina INT NOT NULL,
    id_prestamo INT NOT NULL,
    id_empleado INT NOT NULL,
    valor_pago INT NOT NULL CHECK (valor_pago >= 0),
    fecha_cuota DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- referencias
    FOREIGN KEY (id_nomina) REFERENCES nomina(id_nomina),
    FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- tabla liquidacion
CREATE TABLE liquidacion(
	id_liquidacion INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_prestamo INT NOT NULL,
    fecha_liquidacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    cesantias INT NOT NULL CHECK (cesantias >= 0),
    descuento_prestamo INT DEFAULT 0 CHECK (descuento_prestamo >= 0),
    total_liquidacion INT NOT NULL CHECK (total_liquidacion >= 0),
    
    -- referencias
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo)
);



-- tabla devengados
CREATE TABLE devengados(
	id_devengado INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_nomina INT NOT NULL,
    fecha_devengados DATETIME DEFAULT CURRENT_TIMESTAMP,
    concepto VARCHAR(100) NOT NULL CHECK (concepto REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ0-9 .,_-]+$'),
    valor DECIMAL(8,2) NOT NULL CHECK (valor >= 0),
    
    -- referencias
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_nomina) REFERENCES nomina(id_nomina)
);

-- tabla deducciones
CREATE TABLE deducciones (
	id_deduccion INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_nomina INT NOT NULL,
    fecha_devengados DATETIME DEFAULT CURRENT_TIMESTAMP,
    concepto VARCHAR(100) NOT NULL CHECK (concepto REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ0-9 .,_-]+$'),
    valor_porcentual DECIMAL(5,2) CHECK (valor_porcentual >= 0),
    
    -- referencias
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_nomina) REFERENCES nomina(id_nomina)
);


-- tabla horas_extras
CREATE TABLE horas_extras (
	id_horas_extras INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_nomina INT NOT NULL,
    fecha_horas_extras DATETIME DEFAULT CURRENT_TIMESTAMP,
    concepto VARCHAR(100) NOT NULL CHECK (concepto REGEXP '^[A-Za-záéíóúÁÉÍÓÚñÑ0-9 .,_-]+$'),
    cantidad_horas DECIMAL(3,2) NOT NULL CHECK (cantidad_horas > 0),
    valor_hora DECIMAL(8,2) NOT NULL CHECK (valor_hora >= 0),
    valor DECIMAL(10,2) CHECK (valor >= 0),
    
    -- referencias
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_nomina) REFERENCES nomina(id_nomina)
);

CREATE TABLE detalle_nomina (
  id_detalle_nomina INT AUTO_INCREMENT PRIMARY KEY,
  id_nomina INT NOT NULL CHECK(id_nomina >0),
  concepto VARCHAR(100) NOT NULL,
  valor DECIMAL(10, 2) NOT NULL,
  
  -- Referecia
  FOREIGN KEY (id_nomina) REFERENCES nomina(id_nomina)
);

USE nomina;



--  consultas

-- primera consulta
SELECT 
    a.nombre_area,
    c.nombre_cargo,
    e.id_empleado,
    td.tipo_documento,
    e.numero_documento,
    e.primer_nombre,
    e.segundo_nombre,
    e.primer_apellido,
    e.segundo_apellido,
    e.email,
    n.salario_base,
    COALESCE(SUM(d.valor_porcentual), 0) AS total_deducciones,
    COALESCE(SUM(dev.valor), 0) AS total_devengados,
    n.total_pagar
FROM empleados e
JOIN tipo_documento td ON e.id_tipo_documento = td.id_tipo_documento
JOIN cargos c ON e.id_cargo = c.id_cargo
JOIN areas a ON e.id_area = a.id_area
JOIN nomina n ON e.id_empleado = n.id_empleado
LEFT JOIN deducciones d ON e.id_empleado = d.id_empleado AND n.id_nomina = d.id_nomina
LEFT JOIN devengados dev ON e.id_empleado = dev.id_empleado AND n.id_nomina = dev.id_nomina
GROUP BY n.id_nomina
ORDER BY e.id_empleado;


-- segunda consulta
SELECT 
    s.nombre AS sucursal,
    a.nombre_area,
    COUNT(DISTINCT e.id_empleado) AS cantidad_empleados
FROM empleados e
JOIN sucursales s ON e.id_sucursal = s.id_sucursal
JOIN areas a ON e.id_area = a.id_area
GROUP BY s.id_sucursal, a.id_area
ORDER BY s.nombre, a.nombre_area;

-- Tercera consulta
SELECT 
    e.numero_documento AS cedula,
    CONCAT(e.primer_nombre, ' ', IFNULL(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', e.segundo_apellido) AS nombre_completo,
    td.tipo_documento,
    tn.nombre_novedad AS tipo_novedad,
    n.descripcion,
    c.nombre_cargo,
    con.salario_base,
    s.nombre AS sucursal
FROM novedades n
JOIN empleados e ON n.id_empleado = e.id_empleado
JOIN tipo_documento td ON e.id_tipo_documento = td.id_tipo_documento
JOIN tipo_novedad tn ON n.id_tipo_novedad = tn.id_tipo_novedad
JOIN cargos c ON e.id_cargo = c.id_cargo
JOIN contratos con ON e.id_empleado = con.id_empleado AND con.estado = TRUE
JOIN sucursales s ON e.id_sucursal = s.id_sucursal
WHERE n.fecha_inicio BETWEEN '2024-01-01' AND '2024-12-31'  -- reemplaza por tus fechas
ORDER BY n.fecha_inicio;

-- Cuarta consulta
SELECT 
    s.nombre AS sucursal,
    a.nombre_area,
    SUM(n.total_pagar) AS costo_total_nomina
FROM nomina n
JOIN empleados e ON n.id_empleado = e.id_empleado
JOIN sucursales s ON e.id_sucursal = s.id_sucursal
JOIN areas a ON e.id_area = a.id_area
GROUP BY s.id_sucursal, a.id_area
ORDER BY s.nombre, a.nombre_area;
