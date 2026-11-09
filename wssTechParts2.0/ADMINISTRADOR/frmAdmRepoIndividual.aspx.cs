using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using wssCarritoCompras;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class WebForm4 : System.Web.UI.Page
    {
        clsUsuario objUsuario = new clsUsuario();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
                Response.Cache.SetNoStore();
                llenarGrid();
            }
        }
        void llenarGrid()
        {
            objUsuario.ds = new DataSet();
            objUsuario.ds = objUsuario.listarUsuarios(Application["cnnVentas"].ToString(), 0, 0);
            gvUsuarios.DataSource = objUsuario.ds;
            gvUsuarios.DataMember = "Usuarios";
            gvUsuarios.DataBind();
        }
        protected void gvUsuarios_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUsuarios.PageIndex = e.NewPageIndex;
            llenarGrid();
        }
        protected void gvUsuarios_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton btnVerReporte = (LinkButton)e.Row.FindControl("btnVerReporte");
                if (btnVerReporte != null)
                {
                    string claveUsuario = btnVerReporte.CommandArgument;
                    btnVerReporte.OnClientClick = $"window.location='frmAdmVerReporte.aspx?claveUsuario={claveUsuario}'; return false;";
                }
            }
        }
    }
}