using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using wssCarritoCompras;

namespace wssTechParts2._0
{
    public partial class Formulario_web13 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        protected void Page_Load(object sender, EventArgs e)
        {
            CargarPromociones();
        }
        private void CargarPromociones()
        {
            DataTable dt = objProducto.listarProductosDescuento(Application["cnnVentas"].ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                rptPromociones.DataSource = dt;
                rptPromociones.DataBind();

                pnlListaPromociones.Visible = true;
                pnlSinPromociones.Visible = false;
            }
            else
            {
                // NO HAY DATOS: Ocultamos la lista, mostramos el mensaje
                pnlListaPromociones.Visible = false;
                pnlSinPromociones.Visible = true;
            }
        }
    }
}