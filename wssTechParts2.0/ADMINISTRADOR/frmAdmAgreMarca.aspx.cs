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
    public partial class frmAdmAgreMarca : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        private string rutaImagenes = "../FOTOS/MARCAS/";
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnSubirLogo_Click(object sender, EventArgs e)
        {
            if (fuLogo.HasFile)
            {
                string extension = Path.GetExtension(fuLogo.FileName).ToLower();
                long tamano = fuLogo.PostedFile.ContentLength;
                int maxTamano = 5 * 1024 * 1024;
                if (tamano > maxTamano)
                {
                    MostrarAlerta("La imagen debe ser menor a 5MB", "error");
                    return;
                }
                string[] extensionesPermitidas = { ".jpg", ".jpeg", ".png", ".gif" };
                if (!extensionesPermitidas.Contains(extension))
                {
                    MostrarAlerta("Solo se permiten archivos JPG, PNG o GIF", "error");
                    return;
                }
                try
                {
                    string nombreArchivo = Guid.NewGuid().ToString() + extension;
                    string rutaCompleta = Server.MapPath(rutaImagenes);
                    if (!Directory.Exists(rutaCompleta))
                    {
                        Directory.CreateDirectory(rutaCompleta);
                    }
                    SafeImages.Save(fuLogo.PostedFile, Path.Combine(rutaCompleta, nombreArchivo));
                    imgLogo.ImageUrl = rutaImagenes + nombreArchivo;
                    MostrarAlerta("¡Logo subido correctamente!", "success");
                }
                catch (Exception ex)
                {
                    MostrarAlerta("Error al subir logo: " + "No se pudo completar la operación.", "error");
                }
            }
            else
            {
                MostrarAlerta("Por favor selecciona un logo", "warning");
            }
        }
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!ValidarDatos())
            {
                return;
            }
            try
            {
                string nombre = txtNombre.Text.Trim();
                string logo = imgLogo.ImageUrl;
                DataSet resultado = objProducto.agregarMarca(
                    Application["cnnVentas"].ToString(),
                    nombre,
                    logo
                );
                if (resultado != null && resultado.Tables.Count > 0 && resultado.Tables[0].Rows.Count > 0)
                {
                    string mensaje = resultado.Tables[0].Rows[0][0].ToString();
                    if (mensaje.Contains("exito") || mensaje.Contains("exitoso"))
                    {
                        Response.Write("<script>alert('¡Marca guardada correctamente!'); window.location='frmAdmGestProveedores.aspx';</script>");
                    }
                    else
                    {
                        MostrarAlerta("Error al guardar: " + mensaje, "error");
                    }
                }
                else
                {
                    MostrarAlerta("Error al guardar la marca", "error");
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error: " + "No se pudo completar la operación.".Replace("'", "\\'"), "error");
            }
        }
        private bool ValidarDatos()
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text))
            {
                MostrarAlerta("El nombre de la marca es obligatorio", "warning");
                return false;
            }
            if (imgLogo.ImageUrl == "../FOTOS/MARCAS/default.png")
            {
                MostrarAlerta("Por favor sube un logo de la marca", "warning");
                return false;
            }
            return true;
        }

        private void LimpiarFormulario()
        {
            txtNombre.Text = string.Empty;
            imgLogo.ImageUrl = "../FOTOS/MARCAS/default.png";
            fuLogo.FileBytes.ToString();
        }

        private void MostrarAlerta(string mensaje, string tipo)
        {
            mensaje = System.Web.HttpUtility.JavaScriptStringEncode(mensaje);
            string script = "";
            switch (tipo)
            {
                case "success":
                    script = "alert('" + mensaje + "');";
                    break;
                case "error":
                    script = "alert('" + mensaje + "');";
                    break;
                case "warning":
                    script = "alert('" + mensaje + "');";
                    break;
                default:
                    script = "alert('" + mensaje + "');";
                    break;
            }
            ClientScript.RegisterStartupScript(this.GetType(), "Alerta", script, true);
        }
    }
}
