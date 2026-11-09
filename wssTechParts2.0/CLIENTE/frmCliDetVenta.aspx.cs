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
    public partial class Formulario_web17 : System.Web.UI.Page
    {
        // 1. Instanciamos la clase
        clsCarrito objCarrito = new clsCarrito();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Validamos que exista la sesión
                if (Session["selCompra"] != null)
                {
                    string idCompraStr = Session["selCompra"].ToString();
                    lblFolioCompra.Text = idCompraStr;
                    // Convertimos a INT porque el método pide int cveVenta
                    int idCompraInt = int.Parse(idCompraStr);

                    CargarDetalleVenta(idCompraInt);
                }
                else
                {
                    // Si no hay sesión, regresamos
                    Response.Redirect("frmCliCompras.aspx");
                }
            }
        }
        private void CargarDetalleVenta(int idCompra)
        {
            // 3. Llamamos a TU método listarDetalleVenta
            DataSet ds = objCarrito.listarDetalleVenta(Application["cnnVentas"].ToString(), idCompra);

            // 4. Verificamos que el DataSet tenga datos en la tabla "VentaActual"
            if (ds != null && ds.Tables["VentaActual"].Rows.Count > 0)
            {
                DataTable dt = ds.Tables["VentaActual"];

                // Enlazamos al Repeater
                rptDetalleVenta.DataSource = dt;
                rptDetalleVenta.DataBind();

                lblDireccionEnvio.Text = dt.Rows[0]["DirEnvio"].ToString();
                lblMetodoPago.Text = dt.Rows[0]["MetodoP"].ToString();

                // 5. Calcular Totales
                decimal subtotal = 0m;
                foreach (DataRow row in dt.Rows)
                {
                    subtotal += Convert.ToDecimal(row["TotalxUnidades"]);
                }

                decimal iva = Math.Round(subtotal * 0.16m, 2, MidpointRounding.AwayFromZero);
                decimal total = subtotal + iva;

                lblSubtotal.Text = subtotal.ToString("C");
                lblIVA.Text = iva.ToString("C");
                lblTotal.Text = total.ToString("C");
            }
            else
            {
                // Si no hay datos (tabla vacía)
                lblSubtotal.Text = "$0.00";
                lblIVA.Text = "$0.00";
                lblTotal.Text = "$0.00";
                lblDireccionEnvio.Text = "";
                lblMetodoPago.Text = "";
            }
        }
    }
}