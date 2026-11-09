using Org.BouncyCastle.Pqc.Crypto.Lms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.CLIENTE
{
    public partial class Formulario_web11 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Se limpian todas las variables de sesión
            Session["cveUsuario"] = 0;
            Session["nombreUsuario"] = "";
            Session["Rol"] = "";
            Session["cveSel"] = 0;
            Session["venActual"] = 0;
            Session["selProducto"] = 0;
            Session["selCompra"] = 0;
            Session["opMod"] = 0;
            Session["fotoTemp"] = "";
            // Cuando se tengan otras variables de sesión se deben liberar también

            // Se redirecciona a la página principal inicial
            Response.Redirect("../frmPrincipal.aspx");
        }
    }
}