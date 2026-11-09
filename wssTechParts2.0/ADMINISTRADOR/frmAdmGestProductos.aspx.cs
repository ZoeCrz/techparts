using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class Formulario_web14 : System.Web.UI.Page
    {   // COPIA E INSTANCIA DE LA CLASE
        clsProducto objProductos = new clsProducto();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Evitar caché para la página con alertas (botón Atrás)
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
                Response.Cache.SetNoStore();
                llenarGrid();
            }
        }
        protected void gvProductos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // Se genera la nueva página de datos
            gvProductos.PageIndex = e.NewPageIndex;
            // Se llena de registros la página
            llenarGrid();
        }
        protected void gvProductos_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            Session["cveSel"] = int.Parse(gvProductos.Rows[e.NewSelectedIndex].Cells[2].Text.ToString());
            Response.Redirect("frmAdmEditProductos.aspx");
        }

        protected void gvProductos_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                // 1. Obtener el índice real de la fila (considerando la paginación si aplica)
                int index = e.RowIndex;
                int claveProducto = int.Parse(gvProductos.Rows[index].Cells[2].Text.ToString());
                string nombreProducto = gvProductos.Rows[index].Cells[4].Text.ToString();

                // 3. Llamar al método de eliminar
                int resultado = objProductos.eliminarProducto(Application["cnnVentas"].ToString(), claveProducto);

                if (resultado == 1)
                {
                    // ÉXITO
                    string script = "alert('¡Se cambió el estatus del producto " + nombreProducto + " a inactivo correctamente!');";
                    ClientScript.RegisterStartupScript(this.GetType(), "AlertaExito", script, true);

                    // IMPORTANTE: Recargar SOLO la tabla, no la página
                    llenarGrid();
                }
                else if (resultado == 0)
                {
                    // YA ESTABA DADO DE BAJA
                    string script = "alert('Atención: El producto " + nombreProducto + " YA ha sido dado de baja anteriormente.');";
                    ClientScript.RegisterStartupScript(this.GetType(), "AlertaBajaPrevia", script, true);
                }
                else
                {
                    // NO SE ENCONTRÓ
                    string script = "alert('Error: La clave " + claveProducto + " NO pertenece a ningún producto registrado.');";
                    ClientScript.RegisterStartupScript(this.GetType(), "AlertaError", script, true);
                }
                // 4. ELIMINAMOS EL REDIRECT
            }
            catch (Exception ex)
            {
                string script = "alert('Error crítico: " + "No se pudo completar la operación." + "');";
                ClientScript.RegisterStartupScript(this.GetType(), "AlertaCrash", script, true);
            }
        }
        void llenarGrid()
        {
            objProductos.ds = new DataSet();
            objProductos.ds = objProductos.gestionarProductos(Application["cnnVentas"].ToString());
            gvProductos.DataSource = objProductos.ds;
            gvProductos.DataMember = "gestProd";
            gvProductos.DataBind();

        }
        protected void gvProductos_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void gvProductos_RowDeleted(object sender, GridViewDeletedEventArgs e)
        {

        }
        protected void gvProductos_RowEditing(object sender, GridViewEditEventArgs e)
        {

        }
        protected void gvProductos_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }
        protected void btnSubirFoto_Click(object sender, EventArgs e)
        {
            
        }
        protected void btnAgregarProducto_Click(object sender, EventArgs e)
        {
            Response.Redirect("frmAdmABCProductos.aspx");
        }

    }
}