using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.CLIENTE
{
    public partial class mpCliente : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Esto se hace para personalizar la sesión
            if (System.Web.HttpUtility.HtmlEncode(Convert.ToString(Session["nombreUsuario"])) != "")
            {
                Session["cveUsuario"] = Session["cveUsuario"].ToString();
                lblSesion.Text = System.Web.HttpUtility.HtmlEncode(Convert.ToString(Session["nombreUsuario"])) + "<br>" + System.Web.HttpUtility.HtmlEncode(Convert.ToString(Session["Rol"]));
                // Se usará para mostrar los datos del cliente
                Session["cveSel"] = Session["cveUsuario"].ToString();
            }
        }
    }
}