-- Fresh DEMO database only. No DROP, no real accounts, no production data.
/* 1. CREAR LA BASE DE DATOS */
CREATE DATABASE techparts_demo;

/* 2. ACTIVAR LA BASE DE DATOS A UTILIZAR */
USE techparts_demo;

/* 3. CREAR LAS TABLAS DE LA BASE DE DATOS */
-- TABLA DE ROLES
CREATE TABLE TEC_ROL
(
	ROL_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ROL_Descripcion			NVARCHAR(100) NOT NULL,
    ROL_Permisos			NVARCHAR(250) NOT NULL,
    ROL_Estatus				INT NOT NULL,
    ROL_FechaRegistro		TIMESTAMP NOT NULL
)ENGINE=InnoDB;

-- TABLA DE USUARIOS (CLIENTES Y ADMINISTRADORES)
CREATE TABLE TEC_USUARIO
(
	USU_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ROL_Clave				INT	NOT NULL,
    USU_Nombre				NVARCHAR(50) NOT NULL,
    USU_ApellidoPaterno		NVARCHAR(50) NOT NULL,
    USU_ApellidoMaterno		NVARCHAR(50),
    USU_Usuario				NVARCHAR(50) NOT NULL UNIQUE,
    USU_Contrasena NVARCHAR(255) NOT NULL,
    USU_Email				NVARCHAR(80) NOT NULL UNIQUE,
    USU_Telefono			VARCHAR(12) NOT NULL,
    USU_Calle				NVARCHAR(250) NOT NULL,
    USU_Numero				NVARCHAR(20) NOT NULL,
    USU_Colonia				NVARCHAR(250) NOT NULL,
    USU_Ciudad				NVARCHAR(100),
    USU_Municipio			NVARCHAR(60),
    USU_Estado				NVARCHAR(60) NOT NULL,
    USU_CodigoPostal		INT NOT NULL,
    USU_Foto				NVARCHAR(250),
    USU_Estatus				INT NOT NULL,
    USU_FechaRegistro		TIMESTAMP NOT NULL,
    -- LLAVE FORANEA
    FOREIGN KEY (ROL_Clave) REFERENCES TEC_ROL(ROL_Clave)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

-- TABLA DE CATEGORÍAS
CREATE TABLE TEC_CATEGORIA
(
	CAT_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    CAT_Nombre				NVARCHAR(100) NOT NULL UNIQUE,
    CAT_Descripcion			NVARCHAR(250),
    CAT_Estatus				INT NOT NULL,
    CAT_FechaRegistro		TIMESTAMP NOT NULL
)ENGINE=InnoDB;

-- TABLA DE MARCAS
CREATE TABLE TEC_MARCA
(
	MAR_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    MAR_Nombre				NVARCHAR(100) NOT NULL UNIQUE,
    MAR_Logo				NVARCHAR(250),
    MAR_Estatus				INT NOT NULL,
    MAR_FechaRegistro		TIMESTAMP NOT NULL
)ENGINE=InnoDB;

-- TABLA DE PRODUCTOS
CREATE TABLE TEC_PRODUCTO
(
	PRO_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    CAT_Clave				INT NOT NULL,
    MAR_Clave				INT NOT NULL,
    PRO_Codigo				NVARCHAR(25) NOT NULL UNIQUE,
    PRO_Nombre				NVARCHAR(200) NOT NULL UNIQUE,
    PRO_Descripcion			NVARCHAR(500),
    PRO_Precio				DECIMAL(12,2) NOT NULL,
    PRO_Stock				INT NOT NULL,
    PRO_Imagen				NVARCHAR(250),
    PRO_Destacado			INT DEFAULT 0,
    PRO_Estatus				INT NOT NULL,
    PRO_FechaRegistro		TIMESTAMP NOT NULL,
    -- LLAVES FORANEAS
    FOREIGN KEY (CAT_Clave) REFERENCES TEC_CATEGORIA(CAT_Clave)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (MAR_Clave) REFERENCES TEC_MARCA(MAR_Clave)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

-- TABLA DE PROMOCIONES
CREATE TABLE TEC_PROMOCION
(
	ROM_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ROM_Titulo				NVARCHAR(200) NOT NULL,
    ROM_Descripcion			NVARCHAR(500),
    ROM_TipoPromocion		NVARCHAR(50) NOT NULL, -- Porcentaje, MontoFijo, 2x1
    ROM_Descuento			DECIMAL(12,2) NOT NULL,
    ROM_FechaInicio			DATE NOT NULL,
    ROM_FechaFin			DATE NOT NULL,
    ROM_ImagenBanner		NVARCHAR(250),
    ROM_Activa				INT NOT NULL,
    ROM_FechaRegistro		TIMESTAMP NOT NULL
)ENGINE=InnoDB;

-- TABLA INTERMEDIA: PRODUCTOS EN PROMOCIÓN
CREATE TABLE TEC_PRODUCTO_PROMOCION
(
	PPR_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ROM_Clave				INT NOT NULL,
    PRO_Clave				INT NOT NULL,
    -- LLAVES FORANEAS
    FOREIGN KEY (ROM_Clave) REFERENCES TEC_PROMOCION(ROM_Clave)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PRO_Clave) REFERENCES TEC_PRODUCTO(PRO_Clave)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

-- TABLA DE PAQUETES ARMADOS
CREATE TABLE TEC_PAQUETE
(
	PAQ_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    PAQ_Nombre				NVARCHAR(200) NOT NULL,
    PAQ_Descripcion			NVARCHAR(500),
    PAQ_Cantidad			INT	NOT NULL,
    PAQ_PrecioPaquete		DECIMAL(12,2) NOT NULL,
    PAQ_PrecioIndividual	DECIMAL(12,2) NOT NULL,
    PAQ_Ahorro				DECIMAL(12,2) NOT NULL,
    PAQ_Imagen				NVARCHAR(250),
    PAQ_Activo				INT NOT NULL,
    PAQ_FechaRegistro		TIMESTAMP NOT NULL
)ENGINE=InnoDB;

-- TABLA INTERMEDIA: PRODUCTOS DEL PAQUETE
CREATE TABLE TEC_PRODUCTO_PAQUETE
(
	PPQ_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    PAQ_Clave				INT NOT NULL,
    PRO_Clave				INT NOT NULL,
    PPQ_Cantidad			INT NOT NULL,
    -- LLAVES FORANEAS
    FOREIGN KEY (PAQ_Clave) REFERENCES TEC_PAQUETE(PAQ_Clave)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PRO_Clave) REFERENCES TEC_PRODUCTO(PRO_Clave)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

-- TABLA DE PEDIDOS (VENTAS)
CREATE TABLE TEC_PEDIDO
(
	PED_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    USU_Clave				INT	NOT NULL,
    PED_IVA					DECIMAL(12,2) NOT NULL,
    PED_Total				DECIMAL(12,2) NOT NULL,
    PED_Estatus				INT NOT NULL, # En proceso, Confirmado, Cancelado
    PED_FechaPedido			TIMESTAMP NOT NULL,
    -- LLAVES FORANEAS
    FOREIGN KEY (USU_Clave) REFERENCES TEC_USUARIO(USU_Clave)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

-- TABLA DE DETALLE DE PEDIDOS
CREATE TABLE TEC_DETALLE_PEDIDO
(
	DTP_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    PED_Clave				INT NOT NULL,
    PRO_Clave				INT NOT NULL,
    DTP_Cantidad			INT NOT NULL,
    DTP_Subtotal			DECIMAL(12,2) NOT NULL,
    DTP_Descuento			DECIMAL(12,2) DEFAULT 0,
    DTP_DireccionEnvio		NVARCHAR(300) NOT NULL,
    DTP_MetodoPago			NVARCHAR(50) NOT NULL,
    DTP_PrecioUnitario		DECIMAL(12,2) NOT NULL,
    -- LLAVES FORANEAS
    UNIQUE KEY uq_pedido_producto (PED_Clave, PRO_Clave),
    FOREIGN KEY (PED_Clave) REFERENCES TEC_PEDIDO(PED_Clave)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PRO_Clave) REFERENCES TEC_PRODUCTO(PRO_Clave)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

-- TABLA DE CONTACTO (MENSAJES)
CREATE TABLE TEC_CONTACTO
(
	CON_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    CON_Nombre				NVARCHAR(100) NOT NULL,
    CON_Email				NVARCHAR(80) NOT NULL,
    CON_Asunto				NVARCHAR(150) NOT NULL,
    CON_Mensaje				NVARCHAR(500) NOT NULL,
    CON_Leido				INT DEFAULT 0,
    CON_FechaEnvio			TIMESTAMP NOT NULL
)ENGINE=InnoDB;

-- TABLA DE NOTICIAS Y NOVEDADES
CREATE TABLE TEC_NOTICIA
(
	NOT_Clave				INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    NOT_Titulo				NVARCHAR(200) NOT NULL,
    NOT_Contenido			NVARCHAR(1000) NOT NULL,
    NOT_Imagen				NVARCHAR(250) NOT NULL,
    NOT_URL					NVARCHAR(1000) NOT NULL,
    NOT_Activo				INT NOT NULL,
    NOT_FechaPublicacion	TIMESTAMP NOT NULL
)ENGINE=InnoDB;


DELIMITER $$
CREATE PROCEDURE spProductosComprar()
BEGIN
	SELECT A.PRO_Clave Clave, A.PRO_Nombre Productos, A.PRO_Stock Existencias, A.PRO_Precio Costo, A.PRO_Imagen Imagen,
			IF(A.PRO_Estatus = 1, "ACTIVO", "INACTIVO") Estatus, B.CAT_Clave CatId, B.CAT_Nombre Categoria, E.MAR_Clave MarId, E.MAR_Nombre Marca,
			-- Precio Final (Llamado 'Costo' para que tu C# no se rompa)
			ROUND(
				IFNULL(
					(SELECT 
						CASE 
							WHEN C.ROM_TipoPromocion = 'Porcentaje' THEN A.PRO_Precio - (A.PRO_Precio * (C.ROM_Descuento / 100))
							WHEN C.ROM_TipoPromocion = 'MontoFijo' THEN A.PRO_Precio - C.ROM_Descuento
						END
					 FROM TEC_PROMOCION C, TEC_PRODUCTO_PROMOCION D
					 WHERE D.PRO_Clave = A.PRO_Clave 
					   AND D.ROM_Clave = C.ROM_Clave 
					   AND C.ROM_Activa = 1 
					   AND CURRENT_DATE BETWEEN C.ROM_FechaInicio AND C.ROM_FechaFin
					 LIMIT 1), 
				A.PRO_Precio), 2
			) CostoFinal,
            -- Bandera para saber si mostramos el Badge rojo o no
			(SELECT COUNT(*) 
			 FROM TEC_PROMOCION C, TEC_PRODUCTO_PROMOCION D
			 WHERE D.PRO_Clave = A.PRO_Clave 
			   AND D.ROM_Clave = C.ROM_Clave 
			   AND C.ROM_Activa = 1 
			   AND CURRENT_DATE BETWEEN C.ROM_FechaInicio AND C.ROM_FechaFin
			) Descuento,
            -- Texto del Badge (-15% o -$200)
			IFNULL(
				(SELECT 
					IF(C.ROM_TipoPromocion = 'Porcentaje', CONCAT('-', C.ROM_Descuento, '%'), CONCAT('-$', C.ROM_Descuento))
				 FROM TEC_PROMOCION C, TEC_PRODUCTO_PROMOCION D
				 WHERE D.PRO_Clave = A.PRO_Clave 
				   AND D.ROM_Clave = C.ROM_Clave 
				   AND C.ROM_Activa = 1 
				   AND CURRENT_DATE BETWEEN C.ROM_FechaInicio AND C.ROM_FechaFin
				 LIMIT 1),
			'') EtiquetaDescuento
    FROM TEC_PRODUCTO A, TEC_CATEGORIA B, TEC_MARCA E
    WHERE A.PRO_Estatus = 1 AND A.PRO_Stock > 0 AND E.MAR_Estatus = 1 AND A.CAT_Clave = B.CAT_Clave AND A.MAR_Clave = E.MAR_Clave;
END $$

CREATE PROCEDURE spListarProductosExistentes()
BEGIN
	SELECT A.PRO_Clave Clave, A.PRO_Nombre Productos, A.PRO_Imagen Imagen, B.CAT_Nombre Categoria,
		A.PRO_Precio Costo, A.PRO_Stock Existencias, IF(A.PRO_Estatus = 1, "ACTIVO", "INACTIVO") Estatus,
        -- 1. CALCULAR PRECIO FINAL (Si hay oferta vigente)
        ROUND(
			IFNULL(
				(SELECT 
					CASE 
						WHEN C.ROM_TipoPromocion = 'Porcentaje' THEN A.PRO_Precio - (A.PRO_Precio * (C.ROM_Descuento / 100))
						WHEN C.ROM_TipoPromocion = 'MontoFijo' THEN A.PRO_Precio - C.ROM_Descuento
					END
				 FROM TEC_PROMOCION C, TEC_PRODUCTO_PROMOCION D
				 WHERE D.PRO_Clave = A.PRO_Clave AND D.ROM_Clave = C.ROM_Clave AND C.ROM_Activa = 1 AND CURRENT_DATE BETWEEN C.ROM_FechaInicio AND C.ROM_FechaFin
				 LIMIT 1), 
			A.PRO_Precio), 2
		) CostoFinal,
        -- 2. INDICADOR DE DESCUENTO (1 = Si tiene, 0 = No tiene)
        -- Esto sirve para que en el GridView sepas cuándo tachar el precio original
		(SELECT COUNT(*) 
		 FROM TEC_PROMOCION C, TEC_PRODUCTO_PROMOCION D
		 WHERE D.PRO_Clave = A.PRO_Clave AND D.ROM_Clave = C.ROM_Clave AND C.ROM_Activa = 1 AND CURRENT_DATE BETWEEN C.ROM_FechaInicio AND C.ROM_FechaFin
		) Descuento
    FROM TEC_PRODUCTO A, TEC_CATEGORIA B
    WHERE A.CAT_Clave = B.CAT_Clave
    ORDER BY A.PRO_Nombre ASC;
END $$

CREATE PROCEDURE spProductosRecientes()
BEGIN
	SELECT 
        A.PRO_Clave Clave, A.PRO_Nombre Productos, A.PRO_Stock Existencias, A.PRO_Imagen Imagen, A.PRO_Precio Costo, 
        -- COSTO FINAL (Calculado si hay promoción activa)
        ROUND(
            IFNULL(
                (SELECT 
                    CASE 
                        WHEN C.ROM_TipoPromocion = 'Porcentaje' THEN A.PRO_Precio - (A.PRO_Precio * (C.ROM_Descuento / 100))
                        WHEN C.ROM_TipoPromocion = 'MontoFijo' THEN A.PRO_Precio - C.ROM_Descuento
                    END
                 FROM TEC_PROMOCION C, TEC_PRODUCTO_PROMOCION D
                 WHERE D.PRO_Clave = A.PRO_Clave 
                   AND D.ROM_Clave = C.ROM_Clave 
                   AND C.ROM_Activa = 1 
                   AND CURRENT_DATE BETWEEN C.ROM_FechaInicio AND C.ROM_FechaFin
                 LIMIT 1), 
            A.PRO_Precio), 2
        ) CostoFinal,
        -- ANDERA DE DESCUENTO (1 = Si, 0 = No)
        (SELECT COUNT(*) 
         FROM TEC_PROMOCION C, TEC_PRODUCTO_PROMOCION D
         WHERE D.PRO_Clave = A.PRO_Clave 
           AND D.ROM_Clave = C.ROM_Clave 
           AND C.ROM_Activa = 1 
           AND CURRENT_DATE BETWEEN C.ROM_FechaInicio AND C.ROM_FechaFin
        ) Descuento,
        -- ETIQUETA (-15% o -$500)
        IFNULL(
            (SELECT 
                IF(C.ROM_TipoPromocion = 'Porcentaje', CONCAT('-', C.ROM_Descuento, '%'), CONCAT('-$', C.ROM_Descuento))
             FROM TEC_PROMOCION C, TEC_PRODUCTO_PROMOCION D
             WHERE D.PRO_Clave = A.PRO_Clave 
               AND D.ROM_Clave = C.ROM_Clave 
               AND C.ROM_Activa = 1 
               AND CURRENT_DATE BETWEEN C.ROM_FechaInicio AND C.ROM_FechaFin
             LIMIT 1),
        '') EtiquetaDescuento
    FROM TEC_PRODUCTO A, TEC_MARCA B
    WHERE A.PRO_Estatus = 1 AND A.PRO_Stock > 0 AND B.MAR_Estatus = 1 AND A.MAR_Clave = B.MAR_Clave
    ORDER BY A.PRO_FechaRegistro DESC
    LIMIT 24;
END $$

CREATE PROCEDURE spCategoriasExistentes()
BEGIN
	SELECT A.CAT_Clave Clave, A.CAT_Nombre Categoria, A.CAT_Descripcion Descripcion, COUNT(B.PRO_Stock) Cantidad
    FROM TEC_CATEGORIA A, TEC_PRODUCTO B, TEC_MARCA C
    WHERE B.PRO_Estatus = 1 AND A.CAT_Estatus = 1 AND B.PRO_Stock > 0 AND C.MAR_Estatus = 1 AND A.CAT_Clave = B.CAT_Clave AND B.MAR_Clave = C.MAR_Clave
    GROUP BY A.CAT_Clave
    ORDER BY Clave;
END $$

CREATE PROCEDURE spMarcasExistentes()
BEGIN
	SELECT A.MAR_Clave Clave, A.MAR_Nombre Marca, COUNT(B.PRO_Stock) Cantidad, A.MAR_Logo Logo, a.MAR_Estatus Estatus,
		DATE_FORMAT(A.MAR_FechaRegistro, '%d %M %Y') FechaRegistro
    FROM TEC_MARCA A, TEC_PRODUCTO B
    WHERE B.PRO_Estatus = 1 AND A.MAR_Estatus = 1 AND B.PRO_Stock > 0 AND A.MAR_Clave = B.MAR_Clave
    GROUP BY A.MAR_Clave
    ORDER BY A.MAR_Nombre ASC;
END $$

CREATE PROCEDURE spListarMarcasExistentes()
BEGIN
	SELECT MAR_Clave Clave, MAR_Nombre Marca, MAR_Logo Logo, MAR_Estatus Estatus,
		DATE_FORMAT(MAR_FechaRegistro, '%d %M %Y') FechaRegistro
    FROM TEC_MARCA
    GROUP BY MAR_Clave
    ORDER BY MAR_Nombre ASC;
END $$

CREATE PROCEDURE spNoticiasActivas()
BEGIN
	SELECT NOT_Clave Clave, NOT_Titulo Titulo, NOT_Contenido Contenido, NOT_Imagen Imagen, NOT_URL URL
    FROM TEC_NOTICIA
    WHERE NOT_Activo = 1
    ORDER BY NOT_FechaPublicacion
    LIMIT 5;
END $$

CREATE PROCEDURE spMostrarVentasCliente(
	IN CLAVE	INT
)
BEGIN
	IF EXISTS(SELECT USU_Clave FROM TEC_USUARIO WHERE USU_Clave = CLAVE) THEN
		SELECT 	B.PED_Clave ClaveCompra,
				A.USU_Clave ClaveCliente,
				CONCAT(A.USU_Nombre," ",A.USU_ApellidoPaterno," ",A.USU_ApellidoMaterno) Cliente,
				CONCAT(A.USU_Calle," #",A.USU_Numero,", ",A.USU_Colonia,", ",A.USU_Ciudad," ",A.USU_Municipio,", ",A.USU_Estado,", ",A.USU_CodigoPostal) Direccion,
				DATE_FORMAT(B.PED_FechaPedido, '%d %M %Y') FechaCompra,
				B.PED_Total Total,
				CASE
					WHEN B.PED_Estatus = 1 THEN "EN PROCESO"
					WHEN B.PED_Estatus = 2 THEN "CONFIRMADA"
					ELSE "CANCELADA"
				END Estatus
		FROM TEC_USUARIO A, TEC_PEDIDO B
		WHERE A.USU_Clave = CLAVE AND A.USU_Clave = B.USU_Clave
        ORDER BY ClaveCompra DESC;
	ELSE
		SELECT CAST(0 AS UNSIGNED) ClaveCompra;
	END IF;
END $$

CREATE PROCEDURE spRegistroNuevaVenta(IN CLAVE_USUARIO INT, IN TOTAL DECIMAL(12,2))
BEGIN
 IF EXISTS(SELECT 1 FROM TEC_USUARIO WHERE USU_Clave=CLAVE_USUARIO AND USU_Estatus=1) THEN
 INSERT INTO TEC_PEDIDO VALUES(NULL,CLAVE_USUARIO,0,0,1,NOW());
 SELECT LAST_INSERT_ID();
 ELSE SELECT 0; END IF;
END $$

CREATE PROCEDURE spBuscarProducto(
	IN CLAVE 	INT
)
BEGIN
	IF EXISTS(SELECT PRO_Clave FROM TEC_PRODUCTO WHERE PRO_Clave = CLAVE AND PRO_Estatus = 1) THEN
		SELECT 	A.PRO_Clave Clave, A.PRO_Codigo Codigo, A.PRO_Nombre Producto, A.PRO_Descripcion Descripcion, B.CAT_Nombre Categoria, C.MAR_Nombre Marca, A.PRO_Precio Costo, A.PRO_Stock Existencias, A.PRO_Imagen Imagen,
				IF(A.PRO_Estatus = 1, "ACTIVO", "INACTIVO") Estatus, DATE_FORMAT(A.PRO_FechaRegistro, '%d %M %Y') Fecha,
                -- 2. PRECIO FINAL (Calculado con Subconsulta)
				ROUND(
					IFNULL(
						(SELECT 
							CASE 
								WHEN D.ROM_TipoPromocion = 'Porcentaje' THEN A.PRO_Precio - (A.PRO_Precio * (D.ROM_Descuento / 100))
								WHEN D.ROM_TipoPromocion = 'MontoFijo' THEN A.PRO_Precio - D.ROM_Descuento
							END
						 FROM TEC_PROMOCION D, TEC_PRODUCTO_PROMOCION E
						 WHERE E.PRO_Clave = A.PRO_Clave 
						   AND E.ROM_Clave = D.ROM_Clave 
						   AND D.ROM_Activa = 1 
						   AND CURRENT_DATE BETWEEN D.ROM_FechaInicio AND D.ROM_FechaFin
						 LIMIT 1), 
					A.PRO_Precio), 2
				) CostoFinal,
				-- 3. TIENE DESCUENTO (1 = Si, 0 = No)
				(SELECT COUNT(*) 
				 FROM TEC_PROMOCION D, TEC_PRODUCTO_PROMOCION E
				 WHERE E.PRO_Clave = A.PRO_Clave 
				   AND E.ROM_Clave = D.ROM_Clave 
				   AND D.ROM_Activa = 1 
				   AND CURRENT_DATE BETWEEN D.ROM_FechaInicio AND D.ROM_FechaFin
				) Descuento,
				-- 4. ETIQUETA DEL DESCUENTO (Texto para el badge)
				IFNULL(
					(SELECT 
						IF(D.ROM_TipoPromocion = 'Porcentaje', CONCAT('-', D.ROM_Descuento, '%'), CONCAT('-$', D.ROM_Descuento))
					 FROM TEC_PROMOCION D, TEC_PRODUCTO_PROMOCION E
					 WHERE E.PRO_Clave = A.PRO_Clave 
					   AND E.ROM_Clave = D.ROM_Clave 
					   AND D.ROM_Activa = 1 
					   AND CURRENT_DATE BETWEEN D.ROM_FechaInicio AND D.ROM_FechaFin
					 LIMIT 1),
				'') EtiquetaDescuento
		FROM TEC_PRODUCTO A, TEC_CATEGORIA B, TEC_MARCA C
		WHERE A.PRO_Clave = CLAVE AND A.PRO_Estatus = 1 AND A.CAT_Clave = B.CAT_Clave AND A.MAR_Clave = C.MAR_Clave
        ORDER BY A.PRO_Clave;
	ELSE
		SELECT 0 CLAVE;
	END IF;
END $$

CREATE PROCEDURE spRegistrarDetalleVenta(
 IN claveVenta INT, IN claveProducto INT, IN cantidad INT, IN subtotal DECIMAL(12,2),
 IN descuento DECIMAL(12,2), IN dirEnvio NVARCHAR(300), IN metodoPago NVARCHAR(50), IN precioUnitario DECIMAL(12,2))
BEGIN
 DECLARE v_state INT DEFAULT NULL;
 DECLARE v_stock INT DEFAULT NULL;
 DECLARE v_price DECIMAL(12,2);
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
 SELECT PED_Estatus INTO v_state FROM TEC_PEDIDO WHERE PED_Clave=claveVenta FOR UPDATE;
 SELECT PRO_Stock,PRO_Precio INTO v_stock,v_price FROM TEC_PRODUCTO
 WHERE PRO_Clave=claveProducto AND PRO_Estatus=1 FOR UPDATE;
 IF v_state=1 AND cantidad BETWEEN 1 AND 10000 AND v_stock>=cantidad THEN
 SET v_price = GREATEST(0, ROUND(COALESCE((
 SELECT CASE WHEN P.ROM_TipoPromocion='Porcentaje' THEN v_price*(1-P.ROM_Descuento/100)
 WHEN P.ROM_TipoPromocion='MontoFijo' THEN v_price-P.ROM_Descuento ELSE v_price END
 FROM TEC_PROMOCION P JOIN TEC_PRODUCTO_PROMOCION PP ON PP.ROM_Clave=P.ROM_Clave
 WHERE PP.PRO_Clave=claveProducto AND P.ROM_Activa=1
 AND CURRENT_DATE BETWEEN P.ROM_FechaInicio AND P.ROM_FechaFin
 ORDER BY P.ROM_Clave LIMIT 1), v_price),2));
 INSERT INTO TEC_DETALLE_PEDIDO VALUES(NULL,claveVenta,claveProducto,cantidad,cantidad*v_price,0,'Pendiente','Pendiente',v_price)
 ON DUPLICATE KEY UPDATE DTP_Cantidad=DTP_Cantidad+cantidad, DTP_Subtotal=DTP_Cantidad*v_price, DTP_PrecioUnitario=v_price;
 UPDATE TEC_PRODUCTO SET PRO_Stock=PRO_Stock-cantidad WHERE PRO_Clave=claveProducto;
 COMMIT; SELECT 1;
 ELSE ROLLBACK; SELECT 0; END IF;
END $$

CREATE PROCEDURE spDetalleVentaActual(
	IN claveVenta INT
)
BEGIN
	SELECT 	A.PED_Clave CveVenta, A.PRO_Clave CveProducto, B.PRO_Nombre Productos, A.DTP_Cantidad UnidadesCompradas,
			A.DTP_PrecioUnitario PrecioUnidad, B.PRO_Precio PrecioOriginal, A.DTP_Subtotal TotalxUnidades, B.PRO_Imagen Imagen,
            A.DTP_DireccionEnvio DirEnvio, A.DTP_MetodoPago MetodoP
	FROM TEC_DETALLE_PEDIDO A, TEC_PRODUCTO B
    WHERE A.PED_Clave = claveVenta AND A.PRO_Clave = B.PRO_Clave;
END $$

CREATE PROCEDURE spEliminarProductoCompra(IN claveVenta INT, IN claveProducto INT, IN cantidad INT)
BEGIN
 DECLARE v_state INT DEFAULT NULL;
 DECLARE v_actual INT DEFAULT NULL;
 DECLARE v_stock INT;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
 SELECT PED_Estatus INTO v_state FROM TEC_PEDIDO WHERE PED_Clave=claveVenta FOR UPDATE;
 SELECT PRO_Stock INTO v_stock FROM TEC_PRODUCTO WHERE PRO_Clave=claveProducto FOR UPDATE;
 SELECT DTP_Cantidad INTO v_actual FROM TEC_DETALLE_PEDIDO
 WHERE PED_Clave=claveVenta AND PRO_Clave=claveProducto FOR UPDATE;
 IF v_state=1 AND v_actual IS NOT NULL THEN
 DELETE FROM TEC_DETALLE_PEDIDO WHERE PED_Clave=claveVenta AND PRO_Clave=claveProducto;
 UPDATE TEC_PRODUCTO SET PRO_Stock=PRO_Stock+v_actual WHERE PRO_Clave=claveProducto;
 COMMIT; SELECT 1;
 ELSE ROLLBACK; SELECT 0; END IF;
END $$

CREATE PROCEDURE spActualizarCantidadCarrito(
 IN claveVenta INT, IN claveProducto INT, IN nuevaCantidad INT, IN precioUnitario DECIMAL(12,2))
BEGIN
 DECLARE v_state INT DEFAULT NULL;
 DECLARE v_old INT DEFAULT NULL;
 DECLARE v_stock INT DEFAULT NULL;
 DECLARE v_price DECIMAL(12,2);
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
 SELECT PED_Estatus INTO v_state FROM TEC_PEDIDO WHERE PED_Clave=claveVenta FOR UPDATE;
 SELECT PRO_Stock INTO v_stock FROM TEC_PRODUCTO WHERE PRO_Clave=claveProducto FOR UPDATE;
 SELECT DTP_Cantidad,DTP_PrecioUnitario INTO v_old,v_price FROM TEC_DETALLE_PEDIDO
 WHERE PED_Clave=claveVenta AND PRO_Clave=claveProducto FOR UPDATE;
 IF v_state=1 AND nuevaCantidad BETWEEN 1 AND 10000 AND v_old IS NOT NULL AND v_stock>=nuevaCantidad-v_old THEN
 UPDATE TEC_PRODUCTO SET PRO_Stock=PRO_Stock-(nuevaCantidad-v_old) WHERE PRO_Clave=claveProducto;
 UPDATE TEC_DETALLE_PEDIDO SET DTP_Cantidad=nuevaCantidad,DTP_Subtotal=nuevaCantidad*v_price
 WHERE PED_Clave=claveVenta AND PRO_Clave=claveProducto;
 COMMIT; SELECT 1;
 ELSE ROLLBACK; SELECT 0; END IF;
END $$

CREATE PROCEDURE spConfirmarVenta(IN claveVenta INT, IN total DECIMAL(12,2), IN dirEnvio NVARCHAR(300), IN metodoPago NVARCHAR(50))
BEGIN
 DECLARE v_state INT DEFAULT NULL;
 DECLARE v_subtotal DECIMAL(12,2);
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
 SELECT PED_Estatus INTO v_state FROM TEC_PEDIDO WHERE PED_Clave=claveVenta FOR UPDATE;
 SELECT SUM(DTP_Subtotal) INTO v_subtotal FROM TEC_DETALLE_PEDIDO WHERE PED_Clave=claveVenta;
 IF v_state=1 AND v_subtotal IS NOT NULL AND LENGTH(TRIM(dirEnvio))>0 AND LENGTH(TRIM(metodoPago))>0 THEN
 UPDATE TEC_PEDIDO SET PED_IVA=ROUND(v_subtotal*0.16,2), PED_Total=v_subtotal+ROUND(v_subtotal*0.16,2), PED_Estatus=2
 WHERE PED_Clave=claveVenta;
 UPDATE TEC_DETALLE_PEDIDO SET DTP_DireccionEnvio=dirEnvio,DTP_MetodoPago=metodoPago WHERE PED_Clave=claveVenta;
 COMMIT; SELECT 1;
 ELSE ROLLBACK; SELECT 0; END IF;
END $$

CREATE PROCEDURE spCancelarVenta(IN claveVenta INT)
BEGIN
 DECLARE v_state INT DEFAULT NULL;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
 SELECT PED_Estatus INTO v_state FROM TEC_PEDIDO WHERE PED_Clave=claveVenta FOR UPDATE;
 IF v_state=1 THEN
 UPDATE TEC_PRODUCTO P JOIN TEC_DETALLE_PEDIDO D ON D.PRO_Clave=P.PRO_Clave
 SET P.PRO_Stock=P.PRO_Stock+D.DTP_Cantidad WHERE D.PED_Clave=claveVenta;
 DELETE FROM TEC_DETALLE_PEDIDO WHERE PED_Clave=claveVenta;
 UPDATE TEC_PEDIDO SET PED_Estatus=3,PED_Total=0,PED_IVA=0 WHERE PED_Clave=claveVenta;
 COMMIT; SELECT 1;
 ELSE ROLLBACK; SELECT 0; END IF;
END $$

CREATE PROCEDURE spBuscarUsuario(
	IN CLAVE 	INT
)
BEGIN
	IF EXISTS(SELECT USU_Clave FROM TEC_USUARIO WHERE USU_Clave = CLAVE) THEN
		SELECT 	A.USU_Clave Clave, B.ROL_Descripcion Rol, A.USU_Nombre Nombre, A.USU_ApellidoPaterno ApPat, A.USU_ApellidoMaterno ApMat, A.USU_Email Email,
				A.USU_Telefono Telefono, A.USU_Calle Calle, A.USU_Numero Numero, A.USU_Colonia Colonia, A.USU_Ciudad Ciudad, A.USU_Municipio Municipio,
                A.USU_Estado Estado, A.USU_CodigoPostal CP, A.USU_Foto Foto, A.USU_Usuario Usuario, '' Contrasena,
                IF(A.USU_Estatus = 1, "ACTIVO", "INACTIVO") Estatus, DATE_FORMAT(A.USU_FechaRegistro, '%d %M %Y') Fecha,
                CONCAT(A.USU_Calle," #",A.USU_Numero,", ",A.USU_Colonia,". ",A.USU_Ciudad,", ",A.USU_Estado,". ",A.USU_CodigoPostal) DirEnvio
		FROM TEC_USUARIO A, TEC_ROL B
		WHERE A.USU_Clave = CLAVE AND A.ROL_Clave = B.ROL_Clave;
	ELSE
		SELECT 0 CLAVE;
	END IF;
END $$

CREATE PROCEDURE spActualizarInformacionUsuario(
	IN claveUsuario 	INT,
    IN rol				INT,
    IN nombre 			NVARCHAR(50),
    IN apPat 			NVARCHAR(50),
    IN apMat 			NVARCHAR(50),
    IN email 			NVARCHAR(80),
    IN tel				VARCHAR(12),
    IN calle 			NVARCHAR(250),
    IN numero 			NVARCHAR(20),
    IN colonia 			NVARCHAR(250),
    IN ciudad 			NVARCHAR(100),
    IN municipio 		NVARCHAR(60),
    IN estado 			NVARCHAR(60),
    IN cp 				INT,
    IN foto 			NVARCHAR(250),
    IN usuario 			NVARCHAR(50),
    IN contrasena		NVARCHAR(255)
)
BEGIN
 IF contrasena IS NOT NULL AND contrasena <> '' AND contrasena NOT LIKE 'pbkdf2-sha256$%' THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Password hash required'; END IF;
	IF EXISTS(SELECT USU_Clave FROM TEC_USUARIO WHERE USU_Clave = claveUsuario AND USU_Estatus = 1) THEN
		UPDATE TEC_USUARIO
		SET ROL_Clave = rol, USU_Nombre = nombre, USU_ApellidoPaterno = apPat, USU_ApellidoMaterno = apMat, USU_Email = email,
			USU_Telefono = tel, USU_Calle = calle, USU_Numero = numero, USU_Colonia = colonia, USU_Ciudad = ciudad, USU_Municipio = municipio,
            USU_Estado = estado, USU_CodigoPostal = cp, USU_Foto = foto, USU_Usuario = usuario, USU_Contrasena = IF(contrasena IS NULL OR contrasena = '', USU_Contrasena, contrasena)
		WHERE USU_Clave = claveUsuario;
        SELECT 	A.USU_Clave Clave, B.ROL_Descripcion Rol, A.USU_Nombre Nombre, A.USU_ApellidoPaterno ApPat, A.USU_ApellidoMaterno ApMat, A.USU_Email Email,
				A.USU_Telefono Telefono, A.USU_Calle Calle, A.USU_Numero Numero, A.USU_Colonia Colonia, A.USU_Ciudad Ciudad, A.USU_Municipio Municipio,
                A.USU_Estado Estado, A.USU_CodigoPostal CP, A.USU_Foto Foto, A.USU_Usuario Usuario, '' Contrasena
		FROM TEC_USUARIO A, TEC_ROL B
		WHERE A.USU_Clave = claveUsuario AND A.ROL_Clave = B.ROL_Clave;
	ELSE
		SELECT 0 CLAVE;
	END IF;
END $$

CREATE PROCEDURE spListarUsuarios(
	IN op 		INT,
    IN clave 	INT
)
BEGIN
	IF(op = 0) THEN
		SELECT 	A.USU_Clave Clave, A.USU_Foto Foto, CONCAT(A.USU_Nombre," ",A.USU_ApellidoPaterno," ",A.USU_ApellidoMaterno) Usuario,
				B.ROL_Descripcion Rol, IF(A.USU_Estatus = 1, "ACTIVO", "INACTIVO") Estatus
		FROM TEC_USUARIO A, TEC_ROL B
		WHERE A.ROL_Clave = B.ROL_Clave
        ORDER BY Usuario;
	ELSE
		SELECT 	A.USU_Clave Clave, B.ROL_Descripcion Rol, A.USU_Nombre Nombre, A.USU_ApellidoPaterno ApPat, A.USU_ApellidoMaterno ApMat, A.USU_Email Email,
				A.USU_Telefono Telefono, A.USU_Calle Calle, A.USU_Numero Numero, A.USU_Colonia Colonia, A.USU_Ciudad Ciudad, A.USU_Municipio Municipio,
                A.USU_Estado Estado, A.USU_CodigoPostal CP, A.USU_Foto Foto, A.USU_Usuario Usuario, '' Contrasena,
                IF(A.USU_Estatus = 1, "ACTIVO", "INACTIVO") Estatus
		FROM TEC_USUARIO A, TEC_ROL B
		WHERE A.ROL_Clave = B.ROL_Clave AND A.USU_Clave = clave;
	END IF;
END $$

CREATE PROCEDURE spEliminarUsuario(
    IN clave 	INT
)
BEGIN
	IF EXISTS(SELECT USU_Clave FROM TEC_USUARIO WHERE USU_Clave = clave) THEN
		IF EXISTS(SELECT USU_Clave FROM TEC_USUARIO WHERE USU_Clave = clave AND USU_Estatus = 1) THEN
			UPDATE TEC_USUARIO
			SET USU_Estatus = 0
			WHERE USU_Clave = clave;
			SELECT 1 ELIMINADO;
		ELSE
			SELECT 0 ELIMINADO;
		END IF;
	ELSE
		SELECT 2 ELIMINADO;
	END IF;
END $$

CREATE PROCEDURE spAgregarUsuario(
    IN rol				INT,
    IN nombre 			NVARCHAR(50),
    IN apPat 			NVARCHAR(50),
    IN apMat 			NVARCHAR(50),
    IN email 			NVARCHAR(80),
    IN tel				VARCHAR(12),
    IN calle 			NVARCHAR(250),
    IN numero 			NVARCHAR(20),
    IN colonia 			NVARCHAR(250),
    IN ciudad 			NVARCHAR(100),
    IN municipio 		NVARCHAR(60),
    IN estado 			NVARCHAR(60),
    IN cp 				INT,
    IN foto 			NVARCHAR(250),
    IN usuario 			NVARCHAR(50),
    IN contrasena		NVARCHAR(255)
)
BEGIN
 IF contrasena NOT LIKE 'pbkdf2-sha256$%' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Password hash required'; END IF;
	IF NOT EXISTS(SELECT USU_Usuario, USU_Email FROM TEC_USUARIO WHERE USU_Usuario = usuario OR USU_Email = email) THEN
        INSERT INTO TEC_USUARIO
        VALUES	(null, rol, nombre, apPat, apMat, usuario, contrasena, email, tel, calle, numero, colonia, ciudad, municipio,
				estado, cp, foto, 1, now());
		SELECT 	A.USU_Clave Clave, B.ROL_Descripcion Rol, A.USU_Nombre Nombre, A.USU_ApellidoPaterno ApPat, A.USU_ApellidoMaterno ApMat, A.USU_Email Email,
				A.USU_Telefono Telefono, A.USU_Calle Calle, A.USU_Numero Numero, A.USU_Colonia Colonia, A.USU_Ciudad Ciudad, A.USU_Municipio Municipio,
                A.USU_Estado Estado, A.USU_CodigoPostal CP, A.USU_Foto Foto, A.USU_Usuario Usuario, '' Contrasena,
                IF(A.USU_Estatus = 1, "ACTIVO", "INACTIVO") Estatus
		FROM TEC_USUARIO A, TEC_ROL B
		WHERE A.USU_Usuario = usuario AND A.USU_Estatus = 1 AND A.ROL_Clave = B.ROL_Clave;
	ELSE
		SELECT 0 CLAVE;
	END IF;
END $$

CREATE PROCEDURE spListarRoles()
BEGIN
	SELECT 	ROL_Clave Clave, Rol_Descripcion Rol, IF(ROL_Estatus = 1, "ACTIVO", "INACTIVO") Estatus
	FROM TEC_ROL
	ORDER BY Rol;
END $$

create PROCEDURE spAgregarProducto(
    IN p_categoria      INT,
    IN p_marca          INT,
    IN p_codigo         NVARCHAR(25),
    IN p_nombre         NVARCHAR(200),
    IN p_descripcion    NVARCHAR(500),
    IN p_precio         DECIMAL(12,2),
    IN p_stock          INT,
    IN p_img            NVARCHAR(250)
)
BEGIN
    IF NOT EXISTS(SELECT PRO_Codigo FROM TEC_Producto WHERE PRO_Codigo = p_codigo) THEN
        INSERT INTO TEC_PRODUCTO
        VALUES (null, p_categoria, p_marca, p_codigo, p_nombre, p_descripcion, p_precio, p_stock, p_img, 1, 1, now());
        SELECT 'Producto guardado con éxito' AS Mensaje;
    ELSE
        SELECT 'El código del producto ya existe en el sistema.' AS Mensaje;
    END IF;
END $$

CREATE PROCEDURE spActualizarProducto(
    IN clave          INT,
    IN categoria      INT,
    IN marca          INT,
    IN codigo         NVARCHAR(25),
    IN nombre         NVARCHAR(200),
    IN descripcion    NVARCHAR(500),
    IN precio         DECIMAL(12,2),
    IN stock          INT,
    IN img            NVARCHAR(250)
)
BEGIN
    IF EXISTS(SELECT PRO_Clave FROM TEC_PRODUCTO WHERE PRO_Clave = clave) THEN
        UPDATE TEC_PRODUCTO
        SET 
            CAT_Clave       = categoria,
            MAR_Clave       = marca,
            PRO_Codigo      = codigo,
            PRO_Nombre      = nombre,
            PRO_Descripcion = descripcion,
            PRO_Precio      = precio,
            PRO_Stock       = stock,
            PRO_Imagen      = img
        WHERE PRO_Clave = clave;
        SELECT 1; 
    ELSE
        SELECT 0; 
    END IF;
END $$

CREATE PROCEDURE spEliminarProducto(
    IN clave INT
)
BEGIN
    IF EXISTS (SELECT PRO_Clave 
               FROM TEC_PRODUCTO 
               WHERE PRO_Clave = clave) THEN
        IF EXISTS (SELECT PRO_Clave 
                   FROM TEC_PRODUCTO 
                   WHERE PRO_Clave = clave 
                     AND PRO_Estatus = 1) THEN
            UPDATE TEC_PRODUCTO
            SET PRO_Estatus = 0
            WHERE PRO_Clave = clave;
            SELECT 1 ELIMINADO;
        ELSE
            SELECT 0 ELIMINADO;
        END IF;
    ELSE
        SELECT 2 ELIMINADO;
    END IF;
END $$

CREATE PROCEDURE spAgregarMarca(
    IN nombre NVARCHAR(100),
    IN logo NVARCHAR(250)
)
BEGIN
    DECLARE resultado VARCHAR(200);
    IF nombre IS NULL OR nombre = '' THEN
        SELECT 'Error: El nombre de la marca es obligatorio' as Resultado;
    ELSEIF EXISTS(SELECT 1 FROM TEC_MARCA WHERE MAR_Nombre = nombre) THEN
        SELECT 'Error: Ya existe una marca con este nombre' as Resultado;
    ELSE
        INSERT INTO TEC_MARCA (MAR_Nombre, MAR_Logo, MAR_Estatus, MAR_FechaRegistro)
        VALUES (nombre, logo, 1, NOW());
        SELECT 'Marca registrada exitosamente' as Resultado;
    END IF;
END$$

CREATE PROCEDURE spEliminarMarca(
    IN p_clave INT
)
BEGIN
    DECLARE v_resultado INT;
    IF NOT EXISTS(SELECT 1 FROM TEC_MARCA WHERE MAR_Clave = p_clave) THEN
        SELECT 0;
    ELSE
        UPDATE TEC_MARCA 
        SET MAR_Estatus = 0
        WHERE MAR_Clave = p_clave;
        SELECT 1;
    END IF;
END$$

CREATE PROCEDURE spActualizarMarca(
    IN p_clave INT,
    IN p_nombre NVARCHAR(100),
    IN p_logo NVARCHAR(250)
)
BEGIN
    IF EXISTS(SELECT MAR_Clave FROM TEC_MARCA WHERE MAR_Clave = p_clave) THEN
        -- Actualizamos
        UPDATE TEC_MARCA
        SET MAR_Nombre = p_nombre,
            MAR_Logo = p_logo
        WHERE MAR_Clave = p_clave;
        SELECT 1 AS Resultado; -- Éxito
    ELSE
        SELECT 0 AS Resultado; -- Error: No existe
    END IF;
END$$

CREATE PROCEDURE spBuscarMarca(
    IN p_clave INT
)
BEGIN
    SELECT MAR_Clave, MAR_Nombre, MAR_Logo, MAR_Estatus
    FROM TEC_MARCA
    WHERE MAR_Clave = p_clave;
END$$

CREATE PROCEDURE spRegistrarPromocion(
	IN claveProducto	INT,
    IN titulo       	NVARCHAR(200),
    IN descripcion  	NVARCHAR(500),
    IN tipo         	NVARCHAR(50), 
    IN descuento    	DECIMAL(12,2),
    IN fechaInicio  	DATE,
    IN fechaFin     	DATE,
    IN imagen       	NVARCHAR(250),
    IN activa       	INT
)
BEGIN
	DECLARE ultimaPromo INT;
    IF NOT EXISTS (
		SELECT * FROM TEC_PROMOCION A, TEC_PRODUCTO_PROMOCION B
        WHERE B.PRO_Clave = claveProducto AND A.ROM_Clave = B.Rom_Clave AND A.ROM_Titulo = titulo AND A.ROM_Activa = 1
    ) THEN
		INSERT INTO TEC_PROMOCION
		VALUES (null, titulo, descripcion, tipo, descuento, fechaInicio, fechaFin, imagen, activa, NOW());
		SET ultimaPromo = LAST_INSERT_ID();
        INSERT INTO TEC_PRODUCTO_PROMOCION
		VALUES (null, ultimaPromo, claveProducto);
        SELECT 1 AGREGADO;
	ELSE
		SELECT 0 AGREGADO;        
    END IF;
END $$

CREATE PROCEDURE spListarPromociones()
BEGIN
	SELECT C.ROM_Clave Clave_Promo, A.PRO_CLAVE Clave_Producto, A.PRO_Nombre Producto, A.PRO_Imagen Imagen, A.PRO_Precio Precio_Original,
    C.ROM_Titulo Promocion, C.ROM_Descripcion Descripcion, C.ROM_ImagenBanner Banner, DATE_FORMAT(C.ROM_FechaInicio, '%d %M') Inicio, DATE_FORMAT(C.ROM_FechaFin, '%d %M') Fin,
		-- Mostramos el descuento de forma legible
		CONCAT(
			IF(C.ROM_TipoPromocion = 'Porcentaje', CONCAT('-', C.ROM_Descuento, '%'), CONCAT('-$', C.ROM_Descuento))
		) AS Descuento_Aplicado,
		-- Cálculo del precio final
		ROUND(
			CASE 
				WHEN C.ROM_TipoPromocion = 'Porcentaje' THEN A.PRO_Precio - (A.PRO_Precio * (C.ROM_Descuento / 100))
				WHEN C.ROM_TipoPromocion = 'MontoFijo' THEN A.PRO_Precio - C.ROM_Descuento
				ELSE A.PRO_Precio
			END, 2
		) AS Precio_Final
	FROM TEC_PRODUCTO A, TEC_PRODUCTO_PROMOCION B, TEC_PROMOCION C, TEC_MARCA D
	WHERE 
		A.PRO_Estatus = 1 AND A.PRO_Stock > 0 AND D.MAR_Estatus = 1 AND A.PRO_Clave = B.PRO_Clave AND B.ROM_Clave = C.ROM_Clave
        AND A.MAR_Clave = D.MAR_Clave AND C.ROM_Activa = 1 AND CURRENT_DATE BETWEEN C.ROM_FechaInicio AND C.ROM_FechaFin;
END $$

CREATE PROCEDURE spObtenerPromocionProducto(
    IN claveProducto INT
)
BEGIN
    SELECT A.ROM_Clave, A.ROM_Titulo, A.ROM_Descripcion, A.ROM_TipoPromocion, 
           A.ROM_Descuento, A.ROM_FechaInicio, A.ROM_FechaFin, A.ROM_ImagenBanner
    FROM TEC_PROMOCION A, TEC_PRODUCTO_PROMOCION B
    WHERE B.PRO_Clave = claveProducto AND A.ROM_Activa = 1 AND A.ROM_Clave = B.ROM_Clave
    LIMIT 1;
END $$

CREATE PROCEDURE spActualizarPromocion(
    IN clavePromo INT,
    IN titulo NVARCHAR(200),
    IN descripcion NVARCHAR(500),
    IN tipo NVARCHAR(50),
    IN descuento DECIMAL(12,2),
    IN fechaInicio DATE,
    IN fechaFin DATE,
    IN imagen NVARCHAR(250)
)
BEGIN
    UPDATE TEC_PROMOCION
    SET ROM_Titulo = titulo, ROM_Descripcion = descripcion, ROM_TipoPromocion = tipo, ROM_Descuento = descuento,
        ROM_FechaInicio = fechaInicio, ROM_FechaFin = fechaFin,
        -- Si la imagen viene vacía o nula, no la actualizamos (mantenemos la anterior)
        ROM_ImagenBanner = IF(imagen IS NULL OR imagen = '', ROM_ImagenBanner, imagen)
    WHERE ROM_Clave = clavePromo;
    SELECT 1 Resultado;
END $$

CREATE PROCEDURE spVentasPorDia()
BEGIN
    SELECT 
        -- CORRECCIÓN: Usamos DATE() para ignorar la hora y agrupar solo por el día
        DATE(PED_FechaPedido) AS Fecha,
        COUNT(*) AS CantidadVentas,
        -- Contadores por estatus (Esto estaba bien, solo mejoré la legibilidad)
        SUM(CASE WHEN PED_Estatus = 2 THEN 1 ELSE 0 END) AS VentasConfirmadas,
        SUM(CASE WHEN PED_Estatus = 1 THEN 1 ELSE 0 END) AS VentasPendientes,
        SUM(CASE WHEN PED_Estatus = 3 THEN 1 ELSE 0 END) AS VentasCanceladas,
        -- Suma monetaria solo de lo confirmado
        SUM(CASE WHEN PED_Estatus = 2 THEN PED_Total ELSE 0 END) AS TotalDia
    FROM TEC_PEDIDO
    -- Agrupamos usando la función DATE
    GROUP BY DATE(PED_FechaPedido)
    ORDER BY Fecha DESC;
END $$

CREATE PROCEDURE spReporteMasVendidos()
BEGIN
    SELECT 
        A.PRO_Clave Clave, A.PRO_Nombre Producto, B.CAT_Nombre Categoria, C.MAR_Nombre Marca, A.PRO_Imagen Imagen,
        -- Sumamos la cantidad vendida de la tabla detalles
        SUM(D.DTP_Cantidad) TotalUnidadesVendidas,
        -- Sumamos el dinero generado
        CONCAT('$', FORMAT(SUM(D.DTP_Subtotal), 2)) TotalIngresos
    FROM TEC_PRODUCTO A, TEC_CATEGORIA B, TEC_MARCA C, TEC_DETALLE_PEDIDO D, TEC_PEDIDO E
	-- FILTRO CLAVE: Solo ventas confirmadas (Estatus 2)
    WHERE E.PED_Estatus = 2 AND A.CAT_Clave = B.CAT_Clave AND A.MAR_Clave = C.MAR_Clave
    AND A.PRO_Clave = D.PRO_Clave AND D.PED_Clave = E.PED_Clave
    GROUP BY A.PRO_Clave
    ORDER BY TotalUnidadesVendidas DESC
    LIMIT 10; -- Mostramos el Top 10
END $$

CREATE PROCEDURE spReporteMenosVendidos()
BEGIN
    SELECT 
        A.PRO_Clave Clave, 
        A.PRO_Nombre Producto, 
        B.CAT_Nombre Categoria, 
        C.MAR_Nombre Marca, 
        A.PRO_Imagen Imagen,
        A.PRO_Stock StockActual, -- Agregamos Stock para ver inventario estancado
        IF(A.PRO_Estatus = 1, 'ACTIVO', 'INACTIVO') Estatus,
        -- 1. CALCULAR UNIDADES VENDIDAS (Subconsulta)
        -- Esto busca en las tablas de pedidos solo si hay coincidencias, si no, pone 0.
        IFNULL(
            (SELECT SUM(D.DTP_Cantidad)
             FROM TEC_DETALLE_PEDIDO D, TEC_PEDIDO E
             WHERE D.PED_Clave = E.PED_Clave 
               AND E.PED_Estatus = 2 -- Solo ventas confirmadas
               AND D.PRO_Clave = A.PRO_Clave), 
        0) TotalUnidadesVendidas,
        -- 2. CALCULAR INGRESOS (Subconsulta)
        CONCAT('$', FORMAT(
            IFNULL(
                (SELECT SUM(D.DTP_Subtotal)
                 FROM TEC_DETALLE_PEDIDO D, TEC_PEDIDO E
                 WHERE D.PED_Clave = E.PED_Clave 
                   AND E.PED_Estatus = 2
                   AND D.PRO_Clave = A.PRO_Clave), 
            0), 2)
        ) TotalIngresos
    FROM TEC_PRODUCTO A, TEC_CATEGORIA B, TEC_MARCA C
    WHERE A.CAT_Clave = B.CAT_Clave 
      AND A.MAR_Clave = C.MAR_Clave
      -- No unimos con DETALLE aquí abajo para no perder los productos con 0 ventas
    ORDER BY TotalUnidadesVendidas ASC, A.PRO_Stock DESC
    LIMIT 15;
END $$

CREATE PROCEDURE spListarNoticiasGestion()
BEGIN
    SELECT NOT_Clave Clave, 
           NOT_Titulo Titulo, 
           NOT_Imagen Imagen, 
           DATE_FORMAT(NOT_FechaPublicacion, '%d %M %Y') Fecha,
           NOT_URL URL,
           IF(NOT_Activo = 1, 'ACTIVA', 'INACTIVA') Estatus
    FROM TEC_NOTICIA
    ORDER BY NOT_FechaPublicacion DESC;
END $$

CREATE PROCEDURE spBuscarNoticia(
	IN CLAVE INT
)
BEGIN
    IF EXISTS(SELECT NOT_Clave FROM TEC_NOTICIA WHERE NOT_Clave = CLAVE) THEN
        SELECT NOT_Clave, NOT_Titulo, NOT_Contenido, NOT_Imagen, NOT_URL, 
               IF(NOT_Activo = 1, 'ACTIVA', 'INACTIVA') Estatus
        FROM TEC_NOTICIA
        WHERE NOT_Clave = CLAVE;
    ELSE
        SELECT 0 AS NOT_Clave; -- Indicador de no encontrado
    END IF;
END $$

CREATE PROCEDURE spAgregarNoticia(
    IN titulo NVARCHAR(100),
    IN contenido TEXT,
    IN imagen NVARCHAR(250),
    IN url NVARCHAR(250)
)
BEGIN
    INSERT INTO TEC_NOTICIA (NOT_Titulo, NOT_Contenido, NOT_Imagen, NOT_URL, NOT_FechaPublicacion, NOT_Activo)
    VALUES (titulo, contenido, imagen, url, NOW(), 1);
    SELECT 1 AS Resultado;
END $$

CREATE PROCEDURE spActualizarNoticia(
    IN clave INT,
    IN titulo NVARCHAR(100),
    IN contenido TEXT,
    IN imagen NVARCHAR(250),
    IN url NVARCHAR(250)
)
BEGIN
    IF EXISTS(SELECT NOT_Clave FROM TEC_NOTICIA WHERE NOT_Clave = clave) THEN
        UPDATE TEC_NOTICIA
        SET NOT_Titulo = titulo,
            NOT_Contenido = contenido,
            NOT_Imagen = imagen,
            NOT_URL = url
        WHERE NOT_Clave = clave;
        SELECT 1 AS Resultado;
    ELSE
        SELECT 0 AS Resultado;
    END IF;
END $$

CREATE PROCEDURE spEliminarNoticia(
    IN clave INT
)
BEGIN
    -- Caso 1: La noticia existe pero YA es inactiva (NOT_Activo = 0)
    IF EXISTS(SELECT NOT_Clave FROM TEC_NOTICIA WHERE NOT_Clave = clave AND NOT_Activo = 0) THEN
        SELECT 0 AS Resultado; 
    -- Caso 2: La noticia existe y es activa -> Procedemos a eliminar
    ELSEIF EXISTS(SELECT NOT_Clave FROM TEC_NOTICIA WHERE NOT_Clave = clave) THEN
        UPDATE TEC_NOTICIA SET NOT_Activo = 0 WHERE NOT_Clave = clave;
        SELECT 1 AS Resultado;
    -- Caso 3: No existe el ID
    ELSE
        SELECT -1 AS Resultado;
    END IF;
END $$

CREATE PROCEDURE spCredencialesAcceso(IN usuario NVARCHAR(50))
BEGIN
 SELECT U.USU_Clave Clave, CONCAT_WS(' ', U.USU_Nombre, U.USU_ApellidoPaterno, U.USU_ApellidoMaterno) Usuario,
 R.ROL_Descripcion Rol, U.USU_Contrasena PasswordHash
 FROM TEC_USUARIO U JOIN TEC_ROL R ON R.ROL_Clave=U.ROL_Clave
 WHERE U.USU_Usuario=usuario AND U.USU_Estatus=1 AND R.ROL_Estatus=1 LIMIT 1;
END $$
DELIMITER ;
