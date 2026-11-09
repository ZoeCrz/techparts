using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class Formulario_web18 : System.Web.UI.Page
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
            DataTable dt = objProducto.reporteMenosVendidos(Application["cnnVentas"].ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                gvMenosVendidos.DataSource = dt;
                gvMenosVendidos.DataBind();
            }
            else
            {
                gvMenosVendidos.DataSource = null;
                gvMenosVendidos.DataBind();
            }
        }
    }
}