using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0
{
    public partial class Formulario_web18 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnEnviarMensaje_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtNombre.Text) && !string.IsNullOrEmpty(txtMensaje.Text))
            {
                string telDestino = System.Configuration.ConfigurationManager.AppSettings["ContactPhone"];
                if (string.IsNullOrEmpty(telDestino) || !System.Text.RegularExpressions.Regex.IsMatch(telDestino, @"^\d{10,15}$"))
                {
                    ClientScript.RegisterStartupScript(GetType(), "contact", "alert('Contacto no configurado en esta demo.');", true);
                    return;
                }
                string texto = txtAsunto.Text + ": " + txtMensaje.Text;
                string ruta = "https://api.whatsapp.com/send?phone=" + telDestino + "&text=" + Uri.EscapeDataString(texto);
                ClientScript.RegisterStartupScript(GetType(), "contact", "window.open(" + HttpUtility.JavaScriptStringEncode(ruta, true) + ", '_blank', 'noopener');", true);
                // Limpiar campos
                txtNombre.Text = "";
                txtEmail.Text = "";
                txtAsunto.Text = "";
                txtMensaje.Text = "";
            }
            else
            {
                string script = "alert('Por favor completa los campos requeridos.');";
                ClientScript.RegisterStartupScript(this.GetType(), "Error", script, true);
            }
        }
    }
}