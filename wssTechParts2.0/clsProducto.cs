using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
// SE USA PARA EL ARRAYLIST
using System.Collections;
// 1. Agregar las librerías que permiten manejar instrucciones de MySQL maneja cualquier origen de datos
using System.Data;
// Ejecutar las instrucciones de mysql como sp
using MySql.Data.MySqlClient;

namespace wssTechParts2._0
{
    public class clsProducto
    {
        // Propiedades del producto
        private int clave;
        private string codigo;
        private string nombre;
        private string descripcion;
        private string categoria;
        private string marca;
        private float precio;
        private int stock;
        private string imagen;
        private int catClave;
        private int marClave;

        // PERMITE ADMINISTRAR LA CADENA DE ADMINISTRACIÓN A LA BD
        public MySqlConnection cnn;
        // EJECUTAR UN COMANDO DE MYSQL
        public MySqlCommand cmd;
        // RECIBE VARIOS REGISTROS QUE VAN A UN SOLO CONTROL O UNA VARIABLE
        public MySqlDataAdapter da;
        // RECIBE VARIOS REGISTROS QUE PUEDEN IR A DIFERENTES CONTROLES O VARIAS VARIABLES
        public MySqlDataReader dr;
        // RECIBE EL RESULTADO DE MUCHOS REGISTROS SIN TIPEARSE, ES DECIR SIN FORMATO
        public DataTable dt;
        public DataSet ds;

        // Propiedades de lectura y escritura
        public int Clave { get => clave; set => clave = value; }
        public string Codigo { get => codigo; set => codigo = value; }
        public string Nombre { get => nombre; set => nombre = value; }
        public string Descripcion { get => descripcion; set => descripcion = value; }
        public string Categoria { get => categoria; set => categoria = value; }
        public string Marca { get => marca; set => marca = value; }
        public float Precio { get => precio; set => precio = value; }
        public int Stock { get => stock; set => stock = value; }
        public string Imagen { get => imagen; set => imagen = value; }
        public int CatClave { get => catClave; set => catClave = value; }
        public int MarClave { get => marClave; set => marClave = value; }

        // Constructor y destructor
        public clsProducto()
        {
            clave = 0;
            codigo = "";
            nombre = "";
            descripcion = "";
            categoria = "";
            marca = "";
            precio = 0;
            stock = 0;
            imagen = "";
            catClave = 0;
            marClave = 0;
        }

        // LISTA DE CATEGORÍAS EXISTENTES
        public DataTable listarCategorias(String cadConexion)
        {
            da = SqlProcedure.Adapter(cadConexion, "spCategoriasExistentes");
            dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
        public DataSet listarCategoriasDS(string cadConexion)
        {
            da = SqlProcedure.Adapter(cadConexion, "spCategoriasExistentes");
            ds = new DataSet();
            da.Fill(ds, "Categorias");
            return ds;
        }

        // LISTA DE MARCAS EXISTENTES
        public DataTable listarMarcas(String cadConexion)
        {
            da = SqlProcedure.Adapter(cadConexion, "spMarcasExistentes");
            dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
        public DataSet listarMarcasDS(string cadConexion)
        {
            da = SqlProcedure.Adapter(cadConexion, "spListarMarcasExistentes");
            ds = new DataSet();
            da.Fill(ds, "Marcas");
            return ds;
        }
        // LISTA DE PRODUCTOS QUE SE PUEDEN COMPRAR
        public DataTable listarProductos(String cadConexion)
        {
            da = SqlProcedure.Adapter(cadConexion, "spProductosComprar");
            dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
        // LISTA DE PRODUCTOS MÁS RECIENTES
        public DataTable listarProductosRecientes(String cadConexion)
        {
            da = SqlProcedure.Adapter(cadConexion, "spProductosRecientes");
            dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
        // MOSTRAR DETALLES DEL PRODUCTO SELECCIONADO - Para uso compatible con formulario de detalle
        public DataTable mostrarProducto(string cadConexion, int clave)
        {
            da = SqlProcedure.Adapter(cadConexion, "spBuscarProducto", clave);
            dt = new DataTable();
            da.Fill(dt);
            return dt;
        }

        // BUSCAR PRODUCTO Y POBLAR PROPIEDADES
        public DataSet buscarProducto(string cadConexion, int claveProducto)
        {
            MySqlConnection cnn = new MySqlConnection();
            cnn.ConnectionString = cadConexion;
            MySqlCommand cmd = new MySqlCommand();

            SqlProcedure.Configure(cmd, "spBuscarProducto", claveProducto);
            cmd.Connection = cnn;

            MySqlDataAdapter da = new MySqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.Fill(ds, "productoEncontrado");
            // Puebla las propiedades del objeto si el producto se encuentra
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                DataRow dr = ds.Tables[0].Rows[0];
                // Validar que tenemos todas las columnas esperadas antes de acceder a ellas
                if (ds.Tables[0].Columns.Count >= 9)
                {
                    clave = int.Parse(dr[0].ToString());           // Clave (índice 0)
                    codigo = dr[1].ToString();                     // Codigo (índice 1)
                    nombre = dr[2].ToString();                     // Nombre (índice 2)
                    descripcion = dr[3].ToString();                // Descripcion (índice 3)
                    categoria = dr[4].ToString();                  // Categoria (índice 4)
                    marca = dr[5].ToString();                      // Marca (índice 5)
                    precio = float.Parse(dr[6].ToString());        // Precio (índice 6)
                    stock = int.Parse(dr[7].ToString());           // Stock (índice 7)
                    imagen = dr[8].ToString();                     // Imagen (índice 8)
                }
                else
                {
                    // Producto no encontrado - reiniciar propiedades a valores por defecto
                    clave = 0;
                    codigo = "";
                    nombre = "";
                    descripcion = "";
                    categoria = "";
                    marca = "";
                    precio = 0;
                    stock = 0;
                    imagen = "";
                }
            }
            else
            {
                // Reiniciar propiedades si no hay datos
                clave = 0;
                codigo = "";
                nombre = "";
                descripcion = "";
                categoria = "";
                marca = "";
                precio = 0;
                stock = 0;
                imagen = "";
            }

            cnn.Close();
            return ds;
        }
        public DataSet gestionarProductos(String cadConexion)
        {
            da = SqlProcedure.Adapter(cadConexion, "spListarProductosExistentes");
            ds = new DataSet();
            da.Fill(ds, "gestProd");
            return ds;
        }
        public DataSet agregarProducto(string cadConexion, int categoria, int marca, string codigo, string nombre, string descripcion, float precio, int stock,string img)
        {
            da = SqlProcedure.Adapter(cadConexion, "spAgregarProducto", categoria, marca, codigo, nombre, descripcion, precio, stock, img);
            ds = new DataSet();
            da.Fill(ds, "Usuario");
            return ds;
        }
        public DataSet actualizarProducto(string cadConexion, int clave, int categoria, int marca, string codigo, string nombre, string descripcion, float precio, int stock, string img)
        {
            da = SqlProcedure.Adapter(cadConexion, "spActualizarProducto", clave, categoria, marca, codigo, nombre, descripcion, precio, stock, img);
            ds = new DataSet();
            da.Fill(ds, "Actualizar");
            return ds;
        }
        // ELIMINAR PRODUCTO
        public int eliminarProducto(string cadConexion, int clave)
        {
            int resultado = 0;
            cnn = new MySqlConnection();
            cnn.ConnectionString = cadConexion;
            cmd = new MySqlCommand();
            SqlProcedure.Configure(cmd, "spEliminarProducto", clave);
            cmd.Connection = cnn;
            cnn.Open();
            dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                resultado = int.Parse(dr.GetValue(0).ToString());
            }
            dr.Close();
            cnn.Close();
            return resultado;
        }
        // GESTIONAR MARCAS - Listar todas las marcas
        public DataSet gestionarMarcas(String cadConexion)
        {
            da = SqlProcedure.Adapter(cadConexion, "spListarMarcasExistentes");
            ds = new DataSet();
            da.Fill(ds, "gestMarcas");
            return ds;
        }
        // AGREGAR MARCA
        public DataSet agregarMarca(string cadConexion, string nombre, string logo)
        {
            da = SqlProcedure.Adapter(cadConexion, "spAgregarMarca", nombre, logo);
            ds = new DataSet();
            da.Fill(ds, "Marca");
            return ds;
        }
        // ACTUALIZAR MARCA
        public DataSet actualizarMarca(string cadConexion, int clave, string nombre, string logo)
        {
            da = SqlProcedure.Adapter(cadConexion, "spActualizarMarca", clave, nombre, logo);
            ds = new DataSet();
            da.Fill(ds, "Actualizar");
            return ds;
        }
        // ELIMINAR MARCA
        public int eliminarMarca(string cadConexion, int clave)
        {
            int resultado = 0;
            cnn = new MySqlConnection();
            cnn.ConnectionString = cadConexion;
            cmd = new MySqlCommand();
            SqlProcedure.Configure(cmd, "spEliminarMarca", clave);
            cmd.Connection = cnn;
            cnn.Open();
            dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                resultado = int.Parse(dr.GetValue(0).ToString());
            }
            dr.Close();
            cnn.Close();
            return resultado;
        }
        // BUSCAR MARCA
        public DataSet buscarMarca(string cadConexion, int claveMarca)
        {
            MySqlConnection cnn = new MySqlConnection();
            cnn.ConnectionString = cadConexion;
            MySqlCommand cmd = new MySqlCommand();

            SqlProcedure.Configure(cmd, "spBuscarMarca", claveMarca);
            cmd.Connection = cnn;

            MySqlDataAdapter da = new MySqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.Fill(ds, "marcaEncontrada");

            cnn.Close();
            return ds;
        }

        // LISTA DE PRODUCTOS EN PROMOCIÓN
        public DataTable listarProductosDescuento(String cadConexion)
        {
            da = SqlProcedure.Adapter(cadConexion, "spListarPromociones");
            dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
        public int registrarPromocion(string cadConexion, int idProd, string titulo, string desc, string tipo, float descVal, DateTime ini, DateTime fin, string img, int activa)
        {
            int resultado = 0;
            cnn = new MySqlConnection();
            cnn.ConnectionString = cadConexion;
            cmd = new MySqlCommand();
            SqlProcedure.Configure(cmd, "spRegistrarPromocion", idProd, titulo, desc, tipo, descVal, ini.ToString("yyyy-MM-dd"), fin.ToString("yyyy-MM-dd"), img, activa);
            cmd.Connection = cnn;
            cnn.Open();
            dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                resultado = int.Parse(dr.GetValue(0).ToString());
            }
            dr.Close();
            cnn.Close();
            return resultado;
        }

        // Obtener promoción de un producto específico
        public DataSet obtenerPromocionPorProducto(string cadConexion, int idProducto)
        {
            MySqlConnection cnn = new MySqlConnection(cadConexion);
            MySqlDataAdapter da = SqlProcedure.Adapter(cnn, "spObtenerPromocionProducto", idProducto);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }

        // Actualizar promoción
        public int actualizarPromocion(string cadConexion, int idPromo, string titulo, string desc, string tipo, float descVal, DateTime ini, DateTime fin, string img)
        {
            int res = 0;
            MySqlConnection cnn = new MySqlConnection(cadConexion);
            MySqlCommand cmd = new MySqlCommand();
            SqlProcedure.Configure(cmd, "spActualizarPromocion", idPromo, titulo, desc, tipo, descVal, ini.ToString("yyyy-MM-dd"), fin.ToString("yyyy-MM-dd"), img);
            cmd.Connection = cnn;

            try
            {
                cnn.Open();
                object valor = cmd.ExecuteScalar();
                if (valor != null) res = int.Parse(valor.ToString());
            }
            catch { res = 0; }
            finally { cnn.Close(); }

            return res;
        }

        // Obtener productos MÁS vendidos (Top 10)
        public DataTable reporteMasVendidos(string cadConexion)
        {
            // Preparamos la conexión y la llamada al SP
            MySqlDataAdapter da = SqlProcedure.Adapter(cadConexion, "spReporteMasVendidos");
            DataTable dt = new DataTable();
            try
            {
                // Llenamos la tabla con los resultados de la BD
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                // Opcional: Manejar el error o lanzarlo para que el formulario lo cachee
                throw new Exception("Error al generar reporte de más vendidos: " + "No se pudo completar la operación.");
            }

            return dt;
        }

        // Obtener productos MENOS vendidos (Inventario estancado)
        public DataTable reporteMenosVendidos(string cadConexion)
        {
            // Preparamos la conexión y la llamada al SP
            MySqlDataAdapter da = SqlProcedure.Adapter(cadConexion, "spReporteMenosVendidos");
            DataTable dt = new DataTable();
            try
            {
                // Llenamos la tabla
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                throw new Exception("Error al generar reporte de menos vendidos: " + "No se pudo completar la operación.");
            }

            return dt;
        }
    }
}
