-- Run ONLY against a freshly created demo database with demo.sql and demo_visual.sql loaded.
USE techparts_demo;
DELIMITER $$
CREATE PROCEDURE assert_equal(IN actual DECIMAL(12,2), IN expected DECIMAL(12,2), IN message_text VARCHAR(128))
BEGIN
 IF actual IS NULL OR actual <> expected THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=message_text; END IF;
END $$
DELIMITER ;
-- Demo visual: catálogo con imágenes y ofertas activas sin afectar el producto base.
CALL assert_equal((SELECT COUNT(*) FROM TEC_PRODUCTO WHERE PRO_Estatus=1 AND PRO_Imagen LIKE '../PRODUCTOS/%'),8,'Demo products with images');
CALL assert_equal((SELECT COUNT(*) FROM TEC_NOTICIA WHERE NOT_Activo=1),2,'Demo news');
CALL assert_equal((SELECT COUNT(*) FROM TEC_PRODUCTO_PROMOCION P JOIN TEC_PROMOCION R ON R.ROM_Clave=P.ROM_Clave WHERE R.ROM_Activa=1 AND CURRENT_DATE BETWEEN R.ROM_FechaInicio AND R.ROM_FechaFin),2,'Active demo offers');
-- Deliberately unusable hash: this fixture cannot authenticate in the web app.
CALL spAgregarUsuario(2,'Demo','Test','User','test@example.invalid','0000000000','Demo','1','Demo','Demo','Demo','Demo',10000,'','test-cart','pbkdf2-sha256$invalid-test-fixture');
SET @user=(SELECT USU_Clave FROM TEC_USUARIO WHERE USU_Usuario='test-cart');
CALL spRegistroNuevaVenta(@user,1);
SET @sale=(SELECT MAX(PED_Clave) FROM TEC_PEDIDO WHERE USU_Clave=@user);
CALL spRegistrarDetalleVenta(@sale,1,2,0.01,999,'x','x',0.01);
CALL assert_equal((SELECT PRO_Stock FROM TEC_PRODUCTO WHERE PRO_Clave=1),18,'Stock after add');
CALL assert_equal((SELECT DTP_Subtotal FROM TEC_DETALLE_PEDIDO WHERE PED_Clave=@sale),200,'Client price must be ignored');
CALL spActualizarCantidadCarrito(@sale,1,3,0.01);
CALL assert_equal((SELECT PRO_Stock FROM TEC_PRODUCTO WHERE PRO_Clave=1),17,'Stock after quantity change');
CALL spActualizarCantidadCarrito(@sale,1,200,0.01);
CALL assert_equal((SELECT DTP_Cantidad FROM TEC_DETALLE_PEDIDO WHERE PED_Clave=@sale),3,'Reject insufficient stock');
CALL spEliminarProductoCompra(@sale,1,999);
CALL spEliminarProductoCompra(@sale,1,999);
CALL assert_equal((SELECT PRO_Stock FROM TEC_PRODUCTO WHERE PRO_Clave=1),20,'Do not restore client quantity or restore twice');
CALL spRegistrarDetalleVenta(@sale,1,2,0,0,'x','x',0);
CALL spCancelarVenta(@sale);
CALL spCancelarVenta(@sale);
CALL assert_equal((SELECT PRO_Stock FROM TEC_PRODUCTO WHERE PRO_Clave=1),20,'Cancellation must restore once');
CALL spRegistroNuevaVenta(@user,0);
SET @sale=(SELECT MAX(PED_Clave) FROM TEC_PEDIDO WHERE USU_Clave=@user);
CALL spRegistrarDetalleVenta(@sale,1,2,0,0,'x','x',0);
CALL spConfirmarVenta(@sale,0.01,'Demo address','Demo payment');
CALL assert_equal((SELECT PED_Total FROM TEC_PEDIDO WHERE PED_Clave=@sale),232,'Server total with demo tax');
CALL spCancelarVenta(@sale);
CALL assert_equal((SELECT PED_Estatus FROM TEC_PEDIDO WHERE PED_Clave=@sale),2,'Confirmed sale must remain confirmed');
CALL assert_equal((SELECT PRO_Stock FROM TEC_PRODUCTO WHERE PRO_Clave=1),18,'Do not restore confirmed stock');
