using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class Formulario_web17 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarReporte();
            }
        }
        private void CargarReporte()
        {
            DataTable dt = objProducto.reporteMasVendidos(Application["cnnVentas"].ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                gvMasVendidos.DataSource = dt;
                gvMasVendidos.DataBind();
            }
            else
            {
                gvMasVendidos.DataSource = null;
                gvMasVendidos.DataBind();
            }
        }
    }
}