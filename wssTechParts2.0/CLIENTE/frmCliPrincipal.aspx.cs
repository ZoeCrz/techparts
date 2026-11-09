using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using wssCarritoCompras;

namespace wssTechParts2._0.CLIENTE
{
    public partial class Formulario_web1 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        clsCarrito objCarrito = new clsCarrito();
        protected void Page_Load(object sender, EventArgs e)
        {
            lblCliente.Text = Session["nombreUsuario"].ToString();
            if (!IsPostBack)
            {
                CargarNoticias();
                CargarMarcas();
                CargarProductosRecientes();
            }
        }

        void CargarNoticias()
        {
            string conexion = Application["cnnVentas"].ToString();
            using (MySqlConnection cn = new MySqlConnection(conexion))
            {
                string query = @"CALL spNoticiasActivas()";

                using (MySqlDataAdapter da = new MySqlDataAdapter(query, cn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptNoticias.DataSource = dt;
                    rptNoticias.DataBind();
                }
            }
        }
        void CargarMarcas()
        {
            string conexion = Application["cnnVentas"].ToString();
            using (MySqlConnection cn = new MySqlConnection(conexion))
            {
                // 2. Llamas a tu método existente
                DataTable dtMarcas = objProducto.listarMarcas(conexion);

                // 3. Verificamos que traiga datos para evitar errores
                if (dtMarcas != null && dtMarcas.Rows.Count > 0)
                {
                    // 1. Convertimos el DataTable a una lista de objetos anónimos para manipularla fácil
                    var listaCompleta = dtMarcas.AsEnumerable().Select(row => new
                    {
                        Clave = row["Clave"],
                        Marca = row["Marca"],
                        Logo = row["Logo"]
                    }).ToList();

                    // 2. LÓGICA DE AGRUPACIÓN (CHUNKING)
                    // Esto divide la lista completa en grupos pequeños de 4 elementos
                    var gruposDeCuatro = listaCompleta
                        .Select((x, i) => new { Index = i, Value = x })
                        .GroupBy(x => x.Index / 4)
                        .Select(x => x.Select(v => v.Value).ToList())
                        .ToList();

                    // Si solo hay 1 marca, la duplicamos para que el carrusel no se rompa
                    if (dtMarcas.Rows.Count == 1)
                    {
                        // Importamos la misma fila (índice 0) al final de la tabla
                        dtMarcas.ImportRow(dtMarcas.Rows[0]);
                    }
                    // 3. Enlazamos los grupos al Repeater PADRE
                    rptSliderMarcas.DataSource = gruposDeCuatro;
                    rptSliderMarcas.DataBind();
                }
            }
        }
        void CargarProductosRecientes()
        {
            // 1. Obtener cadena de conexión
            string conexion = Application["cnnVentas"].ToString();

            // 2. Usar el método para traer el DataTable
            DataTable dt = objProducto.listarProductosRecientes(conexion);

            if (dt != null && dt.Rows.Count > 0)
            {
                // 3. Convertir DataTable a Lista para poder manipularla con LINQ
                var listaProductos = dt.AsEnumerable().Select(row => new
                {
                    Clave = row["Clave"],
                    Productos = row["Productos"],
                    Imagen = row["Imagen"],

                    // Nuevos datos para ofertas:
                    Costo = row["Costo"],             // Precio Original
                    CostoFinal = row["CostoFinal"],   // Precio con Descuento
                    Descuento = row["Descuento"],     // 1 o 0
                    EtiquetaDescuento = row["EtiquetaDescuento"] // "-15%"
                }).ToList();

                // 4. AGRUPAR DE 4 EN 4 (Lógica del Slider)
                // Esto divide tus 24 productos en 6 slides de 4 productos cada uno
                var gruposDeCuatro = listaProductos
                    .Select((x, i) => new { Index = i, Value = x })
                    .GroupBy(x => x.Index / 4)
                    .Select(x => x.Select(v => v.Value).ToList())
                    .ToList();

                // Si solo hay 1 producto, lo duplicamos para que el carrusel no se rompa
                if (dt.Rows.Count == 1)
                {
                    // Importamos la misma fila (índice 0) al final de la tabla
                    dt.ImportRow(dt.Rows[0]);
                }

                // 5. Enlazar al Repeater Padre
                rptSliderProductos.DataSource = gruposDeCuatro;
                rptSliderProductos.DataBind();
            }
        }
        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string[] argumentos = btn.CommandArgument.ToString().Split('|');
            int idProducto = int.Parse(argumentos[0]);

            // El ID del cliente logueado está en Session["cveUsuario"]
            // LÓGICA DE SEGURIDAD
            string idVentaActual = "";
            if (Session["venActual"] != null)
            {
                idVentaActual = Session["venActual"].ToString();
            }
            // Si no hay sesión O el ID es inválido/cero, creamos una nueva venta
            if (string.IsNullOrEmpty(idVentaActual) || idVentaActual == "0")
            {
                // IMPORTANTE: Asegúrate de tener el ID del cliente logueado
                int idCliente = int.Parse(Session["cveUsuario"].ToString());

                idVentaActual = objCarrito.insertarVenta(Application["cnnVentas"].ToString(), idCliente);
                Session["venActual"] = idVentaActual; // Guardamos el nuevo ID válido
            }
            // Verificación final antes de insertar detalle
            if (idVentaActual != "0")
            {
                int idVenta = int.Parse(idVentaActual);
                // Ahora sí, insertar detalle es seguro porque idVenta existe en la BD
                if (objCarrito.insertarDetalleVenta(Application["cnnVentas"].ToString(), idVenta, idProducto, 1) != "1")
                {
                    ClientScript.RegisterStartupScript(GetType(), "stock", "alert(\'No se pudo agregar el producto. Verifica el inventario.\');", true);
                    return;
                }

                Response.Write("<script>alert('¡El producto ha sido agregado a tu bolsa!'); window.location='frmCliCarrito.aspx';</script>");
            }
            else
            {
                Response.Write("<script>alert('Error: No se pudo crear la venta. Intente iniciar sesión nuevamente...');</script>");
            }
        }
    }
}