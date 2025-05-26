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




