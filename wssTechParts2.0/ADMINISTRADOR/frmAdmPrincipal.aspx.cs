using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class Formulario_web1 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        protected void Page_Load(object sender, EventArgs e)
        {
            lblAdministrador.Text = Session["nombreUsuario"].ToString();
            if (!IsPostBack)
            {
                CargarNoticias();
                CargarMarcas();
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
    }
}