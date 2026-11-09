using System;
using System.Data;
using MySql.Data.MySqlClient;
using wssTechParts2._0;

namespace wssCarritoCompras
{
    public class clsCarrito
    {
        private static DataSet Leer(string conexion, string tabla, string procedimiento, params object[] valores)
        {
            using (var cnn = new MySqlConnection(conexion))
            using (var comando = SqlProcedure.Command(cnn, procedimiento, valores))
            using (var adaptador = new MySqlDataAdapter(comando))
            {
                var datos = new DataSet();
                adaptador.Fill(datos, tabla);
                return datos;
            }
        }

        private static string Ejecutar(string conexion, string procedimiento, params object[] valores)
        {
            using (var cnn = new MySqlConnection(conexion))
            using (var comando = SqlProcedure.Command(cnn, procedimiento, valores))
            {
                cnn.Open();
                var resultado = comando.ExecuteScalar();
                return resultado == null || resultado == DBNull.Value ? "0" : resultado.ToString();
            }
        }

        // LISTA DE PRODUCTOS QUE SE PUEDEN COMPRAR
        public DataSet listarProductos(String cadConexion)
        {
            return Leer(cadConexion, "Productos", "spProductosComprar");
        }
        // BUSCA UN PRODUCTO
        public DataSet buscarProducto(string cadConexion, int clave)
        {
            return Leer(cadConexion, "ProductoEncontrado", "spBuscarProducto", clave);
        }

        // MÉTODOS DEL CARRITO DE COMPRAS
        public DataSet listarVentasCliente(String cadConexion, int cliente)
        {
            AccessGuard.User(cliente);
            return Leer(cadConexion, "VentasRealizadas", "spMostrarVentasCliente", cliente);
        }

        // INSERTAR UNA NUEVA VENTA
        public string insertarVenta(string cadConexion, int cveCliente)
        {
            AccessGuard.User(cveCliente);
            try { return Ejecutar(cadConexion, "spRegistroNuevaVenta", cveCliente, 0m); }
            catch (MySqlException) { return "0"; }
        }

        // Insertar un detalle de venta
        public string insertarDetalleVenta(string cadConexion, int cveVenta, int cveProd, int cantidad)
        {
            AccessGuard.Sale(cadConexion, cveVenta);
            return Ejecutar(cadConexion, "spRegistrarDetalleVenta", cveVenta, cveProd, cantidad, 0m, 0m, "Pendiente", "Pendiente", 0m);
        }

        public DataSet listarDetalleVenta(string cadConexion, int cveVenta)
        {
            AccessGuard.Sale(cadConexion, cveVenta);
            return Leer(cadConexion, "VentaActual", "spDetalleVentaActual", cveVenta);
        }
        public string eliminarProductoDetalleVenta(string cadConexion, int cveVenta, int cveProd)
        {
            AccessGuard.Sale(cadConexion, cveVenta);
            return Ejecutar(cadConexion, "spEliminarProductoCompra", cveVenta, cveProd, 0);
        }

        // actualizar cantidad desde el DropDownList
        public string actualizarCantidadCarrito(string cadConexion, int cveVenta, int cveProd, int cantidad)
        {
            AccessGuard.Sale(cadConexion, cveVenta);
            return Ejecutar(cadConexion, "spActualizarCantidadCarrito", cveVenta, cveProd, cantidad, 0m);
        }

        // CONFIRMA LA VENTA
        public string confirmarVenta(string cadConexion, int cveVenta, string direccion, string pago)
        {
            AccessGuard.Sale(cadConexion, cveVenta);
            return Ejecutar(cadConexion, "spConfirmarVenta", cveVenta, 0m, direccion, pago);
        }

        // CANCELA LA VENTA
        public string cancelarVenta(string cadConexion, int cveVenta)
        {
            AccessGuard.Sale(cadConexion, cveVenta);
            return Ejecutar(cadConexion, "spCancelarVenta", cveVenta);
        }
        // LISTA LAS VENTAS AGRUPADAS POR DÍA
        public DataSet listarVentasPorDia(string cadConexion)
        {
            return Leer(cadConexion, "VentasDiarias", "spVentasPorDia");
        }
    }
}
