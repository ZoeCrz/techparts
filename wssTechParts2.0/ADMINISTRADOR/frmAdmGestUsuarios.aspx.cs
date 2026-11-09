using Org.BouncyCastle.Asn1.Cmp;
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
    public partial class Formulario_web12 : System.Web.UI.Page
    {
        clsUsuario objUsuario = new clsUsuario();
        DataSet ds;
        int claveEmpleado = 0;
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
        void verUsuarios()
        {
            ds = new DataSet();
            ds = objUsuario.listarUsuarios(Application["cnnVentas"].ToString(), 0, claveEmpleado);
            gvUsuarios.DataSource = ds;
            gvUsuarios.DataMember = "Usuarios";
            gvUsuarios.DataBind();
            gvUsuarios.Visible = true;
        }
        protected void gvUsuarios_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUsuarios.PageIndex = e.NewPageIndex;
            verUsuarios();
        }
        protected void btnAgregarUsuario_Click(object sender, EventArgs e)
        {
            Response.Redirect("frmAdmAgreUsuario.aspx");
        }
        protected void gvUsuarios_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            Session["cveSel"] = int.Parse(gvUsuarios.Rows[e.NewSelectedIndex].Cells[3].Text.ToString());
            Response.Redirect("frmAdmABDUsuarios.aspx");
        }
        protected void gvUsuarios_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int claveUsuario = int.Parse(gvUsuarios.Rows[e.RowIndex].Cells[3].Text.ToString());
                string nombreUsuario = gvUsuarios.Rows[e.RowIndex].Cells[5].Text.ToString();
                // 2. Llamar al SP de eliminación
                int resultado = objUsuario.eliminarUsuario(Application["cnnVentas"].ToString(), claveUsuario);

                // 3. Limpiar sesión si borraste el usuario seleccionado
                if (Session["cveSel"] != null && Session["cveSel"].ToString() == claveUsuario.ToString())
                {
                    Session["cveSel"] = "0";
                }
                // 4. Lógica de Alertas
                if (resultado == 1)
                {
                    // ÉXITO
                    string script = "alert('¡Se cambió el estatus del usuario " + nombreUsuario + " a inactivo correctamente!');";
                    ClientScript.RegisterStartupScript(this.GetType(), "AlertaExito", script, true);

                    // IMPORTANTE: Recargar la tabla aquí para ver el cambio
                    llenarGrid();
                }
                else if (resultado == 0)
                {
                    // YA ESTABA INACTIVO
                    string script = "alert('El usuario " + nombreUsuario + " YA ha sido dado de baja anteriormente.');";
                    ClientScript.RegisterStartupScript(this.GetType(), "AlertaBajaPrevia", script, true);
                }
                else
                {
                    // NO EXISTE
                    string script = "alert('La clave " + claveUsuario + " NO pertenece a ningún usuario registrado.');";
                    ClientScript.RegisterStartupScript(this.GetType(), "AlertaError", script, true);
                }
            }
            catch (Exception ex)
            {
                string script = "alert('Error crítico: " + "No se pudo completar la operación." + "');";
                ClientScript.RegisterStartupScript(this.GetType(), "AlertaCrash", script, true);
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
        protected void gvUsuarios_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                ImageButton btn = (ImageButton)e.Row.FindControl("btnEnviarMsg");
                if (btn == null) return;

                int claveUsuario = int.Parse(e.Row.Cells[3].Text.ToString());
                objUsuario.buscarUsuario(Application["cnnVentas"].ToString(), claveUsuario);

                string telefono = objUsuario.Telefono;
                string nombreUsuario = objUsuario.NomUsuario;

                if (!string.IsNullOrWhiteSpace(telefono))
                {
                    string telFormato = "52" + telefono.Trim().TrimStart('0');
                    string mensaje = "Hola " + nombreUsuario ;
                    string urlWhatsApp = "https://api.whatsapp.com/send?phone=" + telFormato +
                                         "&text=" + HttpUtility.UrlEncode(mensaje);

                    btn.OnClientClick = $"window.open('{urlWhatsApp}', '_blank'); return false;";
                }
                else
                {
                    btn.OnClientClick = "alert('No se encontró teléfono para este usuario...'); return false;";
                }
            }
        }
    }
}
