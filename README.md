# TechParts
Tienda y panel de administración académico en ASP.NET Web Forms, C# y MySQL. Incluye catálogo, promociones, carrito, gestión de usuarios y reportes comerciales. Conserva .NET Framework 4.7.2 y la solución Visual Studio original.

## Características y resultados

- Catálogo con categorías, marcas, fichas de productos y ofertas. La portada muestra productos recientes y noticias.
- Carrito con gestión de cantidades y existencias, confirmación y consulta de compras.
- Panel administrativo para gestionar catálogo, usuarios, promociones, noticias y reportes.
- Demo reproducible con ocho productos ilustrados, seis categorías, cinco marcas, dos ofertas y dos noticias.
- Se integraron consultas parametrizadas, contraseñas con hash y operaciones transaccionales para el stock. La demo cubre el flujo académico de compra sin procesar pagos reales.

## Requisitos
Windows con Visual Studio, carga de trabajo de desarrollo web ASP.NET, targeting pack .NET Framework 4.7.2, IIS Express y MySQL 8.0. En macOS puedes revisar fuentes y SQL; la ejecución completa requiere Windows. No hay pagos reales integrados.

## Base de datos nueva de demostración
Esta entrega usa el **`ScriptTechParts.sql` correcto proporcionado por el autor**, adaptado para crear `techparts_demo` sin copiar cuentas ni contraseñas personales. Es una instalación nueva, no una migración de una base existente.

Desde la raíz, en MySQL CLI o importando estos tres archivos en Workbench:
```sh
mysql -u root -p < database/ScriptTechParts.sql
mysql -u root -p < database/demo.sql
mysql -u root -p < database/demo_visual.sql
```
Si `techparts_demo` ya existe, el primer script se detiene; no borres tus datos para repetirlo. Crea una base de pruebas independiente. La demo completa incluye ocho productos con imágenes, cinco marcas, seis categorías, dos ofertas y dos noticias. Los precios, el inventario y las ofertas son de ejemplo. No se incluyen cuentas con contraseñas públicas. Crea un usuario MySQL exclusivo con permisos sobre esta base, sin usar root desde la web.

Si ya importaste el `demo.sql` anterior y tu catálogo sigue con el único producto inicial, importa **solo** `demo_visual.sql` una vez. Ese complemento conserva el precio y el inventario del producto inicial y no modifica cuentas ni pedidos.

## Ejecutar la web
1. Copia `wssTechParts2.0/ConnectionStrings.example.config` como `ConnectionStrings.config` en la misma carpeta y reemplaza usuario y contraseña por los de tu MySQL local.
2. Abre `wssTechParts2.0.sln`, restaura paquetes NuGet y compila.
3. Configura `frmPrincipal.aspx` como página de inicio y ejecuta con IIS Express.
4. Registra una cuenta ficticia en la interfaz usando contraseña de 12 a 128 caracteres. Para probar el panel administrador, con una conexión MySQL administrativa ejecuta sobre TU demo:
```sql
USE techparts_demo;
UPDATE TEC_USUARIO SET ROL_Clave=1 WHERE USU_Usuario='TU_USUARIO_DE_DEMO';
```
Cierra sesión e inicia de nuevo. Crea otra cuenta para probar el recorrido de cliente. Puedes explorar el catálogo y las ofertas con los ejemplos precargados, o subir imágenes propias desde administración.

El botón de contacto está desactivado hasta configurar `ContactPhone` en appSettings; no publiques un teléfono personal por accidente. Los mapas con API key fueron retirados.

## Cambios relevantes
- Configuración privada externa e ignorada por Git.
- Contraseñas con PBKDF2-SHA256 y sal aleatoria; no se recuperan ni muestran las contraseñas guardadas. Una contraseña vacía al editar conserva la anterior. No admite contraseñas antiguas en texto plano.
- Llamadas a procedimientos con parámetros, controles de sesión/rol y pertenencia del pedido.
- Precios/totales calculados en SQL y stock modificado dentro de transacciones. Los importes SQL usan DECIMAL.
- Subidas de imágenes decodificadas y regrabadas; mensajes dinámicos de JavaScript escapados.
- Sin usuarios, fotos de perfiles, API keys ni cadenas de conexión reales de la carpeta original.

## Validación y límites
Los contratos entre llamadas C# y procedimientos se revisan estáticamente. Se incluye `.github/workflows/verify.yml` para compilar en Windows y ejecutar el esquema y pruebas del carrito en MySQL. La [verificación de la demo](https://github.com/ZoeCrz/techparts/actions/runs/42544261889) compiló en Windows y ejecutó en MySQL la creación de la base, la carga de `demo_visual.sql` y las pruebas del carrito. La prueba interactiva de la interfaz en IIS Express queda pendiente.

Antes de exponer una instancia a internet faltan revisión completa de salidas HTML/URL, control de intentos de acceso, regeneración de sesión tras login, pruebas de autorización y concurrencia, y revisión de dependencias. El carrito libera conexiones, comandos y adaptadores con `using`, muestra totales con `decimal` y verifica el resultado de la operación antes de anunciar que agregó el producto. En otros módulos queda código legado por migrar. Estas mejoras no requieren cambiar de tecnología.

El stock se reserva al añadir al carrito; actualmente no existe caducidad automática de reservas. El IVA de 16% se conserva como regla de la demo, no como asesoría fiscal. Revisa derechos de plantillas, logos y fotografías antes de publicar; conserva sus avisos y no presentes recursos de terceros como propios.
