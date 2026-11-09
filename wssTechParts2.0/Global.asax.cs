using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace wssTechParts2._0
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            // Variable de aplicación que contiene la cadena de conexión
            Application["cnnVentas"] = ConfigurationManager.ConnectionStrings["cnnTechParts"].ConnectionString.ToString();
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            // VARIABLES DE SESIÓN PARA GUARDAR LOS DATOS DEL USUARIO QUE ACCEDE
            Session["cveUsuario"] = 0;
            Session["nombreUsuario"] = "";
            Session["Rol"] = "";
            Session["cveSel"] = 0;
            Session["venActual"] = 0;
            Session["selProducto"] = 0;
            Session["selCompra"] = 0;
            Session["opMod"] = 0;
            Session["fotoTemp"] = "";
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AcquireRequestState(object sender, EventArgs e)
        {
            string path = Request.AppRelativeCurrentExecutionFilePath;
            bool admin = path.StartsWith("~/ADMINISTRADOR/", StringComparison.OrdinalIgnoreCase);
            bool client = path.StartsWith("~/CLIENTE/", StringComparison.OrdinalIgnoreCase);
            if (!admin && !client) return;
            int userId;
            if (Context.Session == null || !int.TryParse(Convert.ToString(Session["cveUsuario"]), out userId) || userId <= 0)
            {
                Response.Redirect("~/frmIniciarSesion.aspx", true);
                return;
            }
            string role = Convert.ToString(Session["Rol"]).Trim();
            if ((admin && !role.Equals("ADMINISTRADOR", StringComparison.OrdinalIgnoreCase)) ||
                (client && !role.Equals("CLIENTE", StringComparison.OrdinalIgnoreCase)))
                throw new HttpException(403, "No tienes permiso para acceder a esta sección.");
        }

        protected void Application_PreRequestHandlerExecute(object sender, EventArgs e)
        {
            var page = Context.Handler as System.Web.UI.Page;
            if (page != null && Context.Session != null)
                page.Init += (source, args) => page.ViewStateUserKey = Session.SessionID;
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}
