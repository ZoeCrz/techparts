using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0
{
    public partial class Formulario_web1 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarNoticias();
                CargarMarcas();
                CargarProductosRecientes();
                CargarPromociones();
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
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        // Si solo hay 1 noticia, la duplicamos para que el carrusel no se rompa
                        if (dt.Rows.Count == 1)
                        {
                            // Importamos la misma fila (índice 0) al final de la tabla
                            dt.ImportRow(dt.Rows[0]);
                        }
                        // 2. Enlazamos al Repeater
                        rptNoticias.DataSource = dt;
                        rptNoticias.DataBind();
                    }
                }
            }
        }
        void CargarMarcas()
        {
            string conexion = Application["cnnVentas"].ToString();
            using (MySqlConnection cn = new MySqlConnection(conexion))
            {
                // 2. Llamas al método existente
                DataTable dtMarcas = objProducto.listarMarcas(conexion);
                // 3. Verificar que traiga datos para evitar errores
                if (dtMarcas != null && dtMarcas.Rows.Count > 0)
                {
                    // 1. Convertir el DataTable a una lista de objetos anónimos para manipularla fácil
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
            // 2. Usar método para traer el DataTable
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
                // Esto divide los 24 productos en 6 slides de 4 productos cada uno
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
        void CargarPromociones()
        {
            // 1. Obtener cadena de conexión
            string conexion = Application["cnnVentas"].ToString();
            // 2. Llamar al método que ejecuta spListarPromociones
            DataTable dt = objProducto.listarProductosDescuento(conexion);
            // 3. Validar y enlazar
            if (dt != null && dt.Rows.Count > 0)
            {
                // Si solo hay 1 promoción, la duplicamos para que el carrusel no se rompa
                if (dt.Rows.Count == 1)
                {
                    // Importamos la misma fila (índice 0) al final de la tabla
                    dt.ImportRow(dt.Rows[0]);
                }
                // 2. Enlazamos al Repeater
                rptPromociones.DataSource = dt;
                rptPromociones.DataBind();
                // Mostrar carrusel, ocultar mensaje
                divCarruselPromociones.Visible = true;
                pnlSinPromociones.Visible = false;
            }
            else
            {
                // B) NO HAY PROMOCIONES
                rptPromociones.DataSource = null;
                rptPromociones.DataBind();
                // Ocultar carrusel, mostrar mensaje
                divCarruselPromociones.Visible = false;
                pnlSinPromociones.Visible = true;
            }
        }
    }
}