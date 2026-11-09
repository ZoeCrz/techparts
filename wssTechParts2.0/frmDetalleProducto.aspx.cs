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
    public partial class Formulario_web16 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        DataTable dt;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["clave"] != null)
                {
                    int claveProducto;
                    if (int.TryParse(Request.QueryString["clave"], out claveProducto))
                    {
                        mostrarDetalle(claveProducto);
                    }
                }
            }
        }
        private void mostrarDetalle(int clave)
        {
            DataTable dt = objProducto.mostrarProducto(Application["cnnVentas"].ToString(), clave);

            if (dt.Rows.Count > 0)
            {
                // Datos básicos
                lblNombre.Text = dt.Rows[0]["Producto"].ToString();
                lblCategoria.Text = dt.Rows[0]["Categoria"].ToString();
                lblDescripcion.Text = dt.Rows[0]["Descripcion"].ToString();
                lblExistencias.Text = dt.Rows[0]["Existencias"].ToString();
                // --- LÓGICA DE PRECIOS ---
                // Leemos las columnas calculadas por el stored procedure
                double costoFinal = Convert.ToDouble(dt.Rows[0]["CostoFinal"]);
                double costoOriginal = Convert.ToDouble(dt.Rows[0]["Costo"]);
                int tieneDescuento = Convert.ToInt32(dt.Rows[0]["Descuento"]);
                // Guardamos el precio real en ViewState para usarlo en el botón "Agregar"
                ViewState["PrecioReal"] = costoFinal;
                if (tieneDescuento >= 1)
                {
                    // HAY OFERTA:
                    // Label principal muestra el precio bajo
                    lblPrecio.Text = "$" + costoFinal.ToString("0.00");

                    // Label anterior muestra precio alto, lo llenamos y lo hacemos visible
                    lblPrecioAnterior.Text = "$" + costoOriginal.ToString("0.00");
                    lblPrecioAnterior.Visible = true;
                }
                else
                {
                    // NO HAY OFERTA:
                    // Label principal muestra precio normal
                    lblPrecio.Text = "$" + costoOriginal.ToString("0.00");

                    // Ocultamos el label de precio anterior
                    lblPrecioAnterior.Visible = false;
                }
                // Imágenes
                imgProducto1.ImageUrl = dt.Rows[0]["Imagen"].ToString();
                imgProducto2.ImageUrl = dt.Rows[0]["Imagen"].ToString();
                imgProducto3.ImageUrl = dt.Rows[0]["Imagen"].ToString();
            }
            else
            {
                lblNombre.Text = "Producto no encontrado";
                lblCategoria.Text = "";
                lblDescripcion.Text = "";
                lblExistencias.Text = "";
                lblPrecio.Text = "";
                lblPrecioAnterior.Text = "";
            }
        }
        protected void btnAgregarCarrito_Click(object sender, EventArgs e)
        {
            Response.Redirect("frmIniciarSesion.aspx");
        }
    }
}