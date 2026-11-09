-- Complemento de demo.sql. Ejecutar una vez en la base techparts_demo.
-- Los precios, el inventario, las promociones y las noticias son ejemplos.
USE techparts_demo;
START TRANSACTION;

INSERT INTO TEC_CATEGORIA (CAT_Clave, CAT_Nombre, CAT_Descripcion, CAT_Estatus, CAT_FechaRegistro) VALUES
(2, 'Memoria RAM', 'Módulos de memoria para equipos de escritorio.', 1, NOW()),
(3, 'Tarjetas gráficas', 'Tarjetas de video dedicadas.', 1, NOW()),
(4, 'Procesadores', 'Procesadores para equipos de escritorio.', 1, NOW()),
(5, 'Tarjetas madre', 'Placas base para armar equipos.', 1, NOW()),
(6, 'Fuentes de poder', 'Alimentación para equipos de escritorio.', 1, NOW());

INSERT INTO TEC_MARCA (MAR_Clave, MAR_Nombre, MAR_Logo, MAR_Estatus, MAR_FechaRegistro) VALUES
(2, 'Corsair', '../FOTOS/MARCAS/corsair.png', 1, NOW()),
(3, 'MSI', '../FOTOS/MARCAS/msi.png', 1, NOW()),
(4, 'Intel', '../FOTOS/MARCAS/intel.png', 1, NOW()),
(5, 'AMD', '../FOTOS/MARCAS/amd.png', 1, NOW());

-- Conservar el precio, stock y código del producto base que usa la prueba de carrito.
UPDATE TEC_PRODUCTO
SET PRO_Imagen = '../PRODUCTOS/default.png'
WHERE PRO_Clave = 1 AND PRO_Codigo = 'DEMO-001' AND COALESCE(PRO_Imagen, '') = '';

UPDATE TEC_MARCA
SET MAR_Logo = '../FOTOS/MARCAS/default.png'
WHERE MAR_Clave = 1 AND MAR_Nombre = 'Marca de ejemplo' AND COALESCE(MAR_Logo, '') = '';

INSERT INTO TEC_PRODUCTO (PRO_Clave, CAT_Clave, MAR_Clave, PRO_Codigo, PRO_Nombre,
    PRO_Descripcion, PRO_Precio, PRO_Stock, PRO_Imagen, PRO_Destacado, PRO_Estatus, PRO_FechaRegistro) VALUES
(2, 2, 2, 'DEMO-002', 'Corsair Vengeance LPX', 'Ejemplo de memoria RAM para el catálogo.', 899.00, 18, '../PRODUCTOS/RAM/ram_corsair_lpx.png', 1, 1, NOW()),
(3, 3, 3, 'DEMO-003', 'MSI GeForce RTX 4070', 'Ejemplo de tarjeta gráfica dedicada.', 10999.00, 8, '../PRODUCTOS/GRAFICAS/gpu_msi_4070.png', 1, 1, NOW()),
(4, 4, 4, 'DEMO-004', 'Intel Core i5-13600K', 'Ejemplo de procesador Intel para comparar en el catálogo.', 5399.00, 12, '../PRODUCTOS/PROCESADORES/cpu_intel_i5_13600k.png', 0, 1, NOW()),
(5, 5, 3, 'DEMO-005', 'MSI B650', 'Ejemplo de tarjeta madre para equipos de escritorio.', 3599.00, 10, '../PRODUCTOS/MOTHERBOARDS/mobo_msi_b650.png', 0, 1, NOW()),
(6, 6, 2, 'DEMO-006', 'Corsair RM850x', 'Ejemplo de fuente de poder para un equipo de escritorio.', 2499.00, 14, '../PRODUCTOS/FUENTES DE PODER/psu_corsair_rm850x.png', 0, 1, NOW()),
(7, 4, 5, 'DEMO-007', 'AMD Ryzen 5 7600X', 'Ejemplo de procesador AMD para el catálogo.', 3899.00, 15, '../PRODUCTOS/PROCESADORES/cpu_amd_7600x.png', 0, 1, NOW()),
(8, 3, 5, 'DEMO-008', 'AMD Radeon RX 7800 XT', 'Ejemplo de tarjeta gráfica para la demo.', 9499.00, 9, '../PRODUCTOS/GRAFICAS/gpu_amd_7800xt.png', 1, 1, NOW());

INSERT INTO TEC_PROMOCION (ROM_Clave, ROM_Titulo, ROM_Descripcion, ROM_TipoPromocion,
    ROM_Descuento, ROM_FechaInicio, ROM_FechaFin, ROM_ImagenBanner, ROM_Activa, ROM_FechaRegistro) VALUES
(1, 'Actualiza tu equipo', 'Promoción ficticia de memoria RAM.', 'Porcentaje', 10.00, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 1 YEAR), '../FOTOS/offerBanner.png', 1, NOW()),
(2, 'Gráficos en oferta', 'Promoción ficticia de tarjeta gráfica.', 'MontoFijo', 500.00, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 1 YEAR), '../FOTOS/ofertas.png', 1, NOW());

INSERT INTO TEC_PRODUCTO_PROMOCION (ROM_Clave, PRO_Clave) VALUES (1, 2), (2, 3);

INSERT INTO TEC_NOTICIA (NOT_Titulo, NOT_Contenido, NOT_Imagen, NOT_URL, NOT_Activo, NOT_FechaPublicacion) VALUES
('Explora el catálogo de TechParts', 'Conoce las categorías y compara los componentes de esta tienda de demostración.', '../FOTOS/altaGama.png', '../frmProductos.aspx', 1, NOW()),
('Arma tu próximo equipo', 'Consulta las ofertas de ejemplo y prueba cómo funciona el catálogo de TechParts.', '../FOTOS/armado.png', '../frmPromociones.aspx', 1, NOW());
COMMIT;
