using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class Formulario_web15 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Evitar caché para que alertas no reaparezcan al usar botón Atrás
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
                Response.Cache.SetNoStore();
                llenarGrid();
            }
        }
        protected void gvMarcas_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMarcas.PageIndex = e.NewPageIndex;
            llenarGrid();
        }
        void llenarGrid()
        {
            objProducto.ds = new DataSet();
            objProducto.ds = objProducto.gestionarMarcas(Application["cnnVentas"].ToString());
            gvMarcas.DataSource = objProducto.ds;
            gvMarcas.DataMember = "gestMarcas";
            gvMarcas.DataBind();
        }
        protected void gvMarcas_RowDataBound(object sender, GridViewRowEventArgs e)
        {
        }
        protected void btnAgregarMarca_Click(object sender, EventArgs e)
        {
            Response.Redirect("frmAdmAgreMarca.aspx");
        }
        protected void btnEditar_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                ImageButton btn = (ImageButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int claveMarca = int.Parse(row.Cells[2].Text.ToString());
                Session["cveMarc"] = claveMarca;
                Response.Redirect("frmAdmEditMarca.aspx");
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorEditar",
                    $"alert('Error al editar: {"No se pudo completar la operación.".Replace("'", "\\'")}');", true);
            }
        }
        protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                // 1. Identificar la fila
                ImageButton btn = (ImageButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                int claveMarca = Convert.ToInt32(gvMarcas.DataKeys[row.RowIndex].Values["Clave"]);

                int statusInt = Convert.ToInt32(gvMarcas.DataKeys[row.RowIndex].Values["Estatus"]);

                // 3. Lógica de Eliminación
                if (statusInt == 0) // Ya es inactiva
                {
                    string script = "alert('Atención: La marca YA había sido dada de baja anteriormente.');";
                    ClientScript.RegisterStartupScript(this.GetType(), "AlertaBajaPrevia", script, true);
                }
                else
                {
                    // Procedemos a eliminar
                    int resultado = objProducto.eliminarMarca(Application["cnnVentas"].ToString(), claveMarca);

                    if (resultado == 1)
                    {
                        string script = "alert('¡Marca eliminada correctamente!');";
                        ClientScript.RegisterStartupScript(this.GetType(), "AlertaExito", script, true);

                        // Recargamos el Grid para que se vea el cambio (el estatus cambiará a INACTIVO)
                        llenarGrid();
                    }
                    else
                    {
                        string script = "alert('Error al intentar eliminar la marca.');";
                        ClientScript.RegisterStartupScript(this.GetType(), "AlertaError", script, true);
                    }
                }
            }
            catch (Exception ex)
            {
                string script = $"alert('Error crítico: {"No se pudo completar la operación."}');";
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorCatch", script, true);
            }
        }
    }
}
