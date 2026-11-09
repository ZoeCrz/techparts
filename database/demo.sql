USE techparts_demo;
INSERT INTO TEC_ROL VALUES
(1,'ADMINISTRADOR','Administracion de demo',1,NOW()),
(2,'CLIENTE','Catalogo y compras de demo',1,NOW());
INSERT INTO TEC_CATEGORIA VALUES(1,'Componentes de ejemplo','Datos ficticios',1,NOW());
INSERT INTO TEC_MARCA VALUES(1,'Marca de ejemplo','',1,NOW());
INSERT INTO TEC_PRODUCTO VALUES(1,1,1,'DEMO-001','Producto de ejemplo','Producto ficticio para probar el carrito',100.00,20,'',1,1,NOW());
