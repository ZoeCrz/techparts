using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class Formulario_web19 : System.Web.UI.Page
    {
        clsNoticia objNoticia = new clsNoticia();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LlenarGrid();
            }
        }
        void LlenarGrid()
        {
            DataSet ds = objNoticia.listarNoticiasGestion(Application["cnnVentas"].ToString());
            gvNoticias.DataSource = ds;
            gvNoticias.DataBind();
        }
        // BOTÓN AGREGAR NUEVA (Redirige limpio)
        protected void btnAgregarNoticia_Click(object sender, EventArgs e)
        {
            Session["cveNoticia"] = null; // Limpiamos sesión para indicar que es NUEVO
            Response.Redirect("frmAdmABCNoticias.aspx");
        }
        // BOTONES EDITAR / ELIMINAR (En el Grid)
        // EN EL GRIDVIEW (Evento RowCommand)
        protected void gvNoticias_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Editar")
            {
                Session["cveNoticia"] = e.CommandArgument.ToString();
                Response.Redirect("frmAdmABCNoticias.aspx");
            }
            else if (e.CommandName == "Eliminar")
            {
                try
                {
                    int id = int.Parse(e.CommandArgument.ToString());
                    // Llamamos al SP modificado
                    int resultado = objNoticia.eliminarNoticia(Application["cnnVentas"].ToString(), id);

                    if (resultado == 1)
                    {
                        // ÉXITO
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('¡Noticia dada de baja correctamente!');", true);
                        LlenarGrid();
                    }
                    else if (resultado == 0)
                    {
                        // YA ESTABA INACTIVA
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Atención: Esta noticia YA había sido dada de baja anteriormente.');", true);
                    }
                    else
                    {
                        // NO EXISTE
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Error: La noticia no existe...');", true);
                    }
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error: {"No se pudo completar la operación."}');", true);
                }
            }
        }
        protected void gvNoticias_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvNoticias.PageIndex = e.NewPageIndex;
            LlenarGrid();
        }
        protected void gvNoticias_RowDataBound(object sender, GridViewRowEventArgs e) { }
    }
}