using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        int claveMarca = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Verificar si hay una marca seleccionada en sesión
                if (Session["cveMarc"] != null && int.TryParse(Session["cveMarc"].ToString(), out claveMarca) && claveMarca > 0)
                {
                    CargarDatosMarca(claveMarca);
                }
                else
                {
                    Response.Redirect("frmAdmGestProveedores.aspx");
                }
            }
            // Recuperar clave en PostBacks
            else if (Session["cveMarc"] != null)
            {
                int.TryParse(Session["cveMarc"].ToString(), out claveMarca);
            }
        }
        private void CargarDatosMarca(int clave)
        {
            try
            {
                DataSet ds = objProducto.buscarMarca(Application["cnnVentas"].ToString(), clave);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    // 1. VALIDACIÓN SI LA MARCA NO EXISTE (store procedure regresa 0)
                    if (ds.Tables[0].Rows[0][0].ToString() == "0")
                    {
                        Response.Write("<script>alert('La marca no puede ser editada ya que se encuentra INACTIVA...'); window.location='frmAdmGestProveedores.aspx';</script>");
                        return;
                    }
                    DataRow dr = ds.Tables[0].Rows[0];
                    // 2. VALIDACIÓN SI LA MARCA ESTÁ INACTIVA
                    string estatus = dr["MAR_Estatus"].ToString();
                    if (estatus == "INACTIVA" || estatus == "0")
                    {
                        // A) Mandamos la alerta
                        Response.Write("<script>alert('La marca no puede ser editada ya que se encuentra INACTIVA...'); window.location='frmAdmGestProveedores.aspx';</script>");
                        // B) Bloqueamos los controles
                        DeshabilitarControles();
                    }
                    // 3. CARGAR DATOS (Se cargan igual para visualización)
                    txtNombre.Text = dr["MAR_Nombre"].ToString();
                    string logo = dr["MAR_Logo"].ToString();
                    if (!string.IsNullOrEmpty(logo))
                    {
                        imgLogo.ImageUrl = logo;
                    }
                }
                else
                {
                    MostrarAlerta("Error: No se encontraron datos.");
                    Response.Redirect("frmAdmGestProveedores.aspx");
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error al cargar datos: " + "No se pudo completar la operación.");
            }
        }

        // --- MÉTODO PARA BLOQUEAR EL FORMULARIO ---
        private void DeshabilitarControles()
        {
            txtNombre.Enabled = false;

            // Botones de acción
            btnGuardar.Enabled = false;
            btnGuardar.Visible = false;

            btnSubirLogo.Enabled = false;
            fuLogo.Enabled = false;
        }
        // Método auxiliar para mostrar alertas
        private void MostrarAlerta(string mensaje)
        {
            mensaje = System.Web.HttpUtility.JavaScriptStringEncode(mensaje);
            string script = $"alert('{mensaje.Replace("'", "")}');";
            ClientScript.RegisterStartupScript(this.GetType(), "AlertaGen", script, true);
        }

        // EVENTO SUBIR FOTO (CON ALERTAS)
        protected void btnSubirLogo_Click(object sender, EventArgs e)
        {
            if (fuLogo.HasFile)
            {
                try
                {
                    // 1. Validar tamaño (5MB)
                    if (fuLogo.PostedFile.ContentLength > 5242880)
                    {
                        MostrarAlerta("El archivo es demasiado grande. Máximo 5MB.");
                        return;
                    }

                    // 2. Validar extensión
                    string extension = Path.GetExtension(fuLogo.FileName).ToLower();
                    if (extension != ".jpg" && extension != ".jpeg" && extension != ".png" && extension != ".gif")
                    {
                        MostrarAlerta("Formato no válido. Solo JPG, PNG o GIF.");
                        return;
                    }

                    // 3. Directorio
                    string rutaCarpeta = Server.MapPath("../FOTOS/MARCAS/");
                    if (!Directory.Exists(rutaCarpeta))
                        Directory.CreateDirectory(rutaCarpeta);

                    // 4. Guardar archivo
                    string nombreArchivo = "MARCA_TEMP_" + DateTime.Now.ToString("yyyyMMddHHmmss") + extension;
                    string rutaGuardar = Path.Combine(rutaCarpeta, nombreArchivo);

                    SafeImages.Save(fuLogo.PostedFile, rutaGuardar);

                    // 5. Mostrar en el control Image
                    imgLogo.ImageUrl = "../FOTOS/MARCAS/" + nombreArchivo;

                    // 6. Alerta de éxito específica para la foto
                    MostrarAlerta("Foto cargada correctamente. No olvide dar clic en GUARDAR CAMBIOS.");
                }
                catch (Exception ex)
                {
                    MostrarAlerta("Error al subir logo: " + "No se pudo completar la operación.");
                }
            }
            else
            {
                MostrarAlerta("Por favor, seleccione un archivo primero...");
            }
        }
        // EVENTO GUARDAR (CON VALIDACIÓN Y ALERTA FINAL)
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                // Validar Nombre
                if (string.IsNullOrWhiteSpace(txtNombre.Text))
                {
                    MostrarAlerta("El nombre de la marca es obligatorio.");
                    return;
                }
                // Validar Foto Obligatoria
                // Verificamos si la URL está vacía, es nula, o contiene la palabra "default" o "default-logo"
                if (string.IsNullOrEmpty(imgLogo.ImageUrl) ||
                    imgLogo.ImageUrl.ToLower().Contains("default"))
                {
                    MostrarAlerta("Debe subir un Logo para la marca (La foto es obligatoria).");
                    return;
                }
                if (Session["cveMarc"] == null)
                {
                    Response.Redirect("frmAdmGestProveedores.aspx");
                    return;
                }
                claveMarca = int.Parse(Session["cveMarc"].ToString());
                DataSet dsResultado = objProducto.actualizarMarca(
                    Application["cnnVentas"].ToString(),
                    claveMarca,
                    txtNombre.Text.Trim(),
                    imgLogo.ImageUrl
                );
                if (dsResultado != null && dsResultado.Tables.Count > 0 && dsResultado.Tables[0].Rows.Count > 0)
                {
                    int resultado = int.Parse(dsResultado.Tables[0].Rows[0]["Resultado"].ToString());

                    if (resultado == 1)
                    {
                        // Limpiamos la variable de sesión
                        Session["cveMarc"] = null;

                        Response.Write("<script>alert('¡Marca actualizada correctamente!'); window.location='frmAdmGestProveedores.aspx';</script>");
                    }
                    else
                    {
                        MostrarAlerta("No se pudo actualizar la marca...");
                    }
                }
                else
                {
                    MostrarAlerta("Error: La base de datos no respondió.");
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error crítico: " + "No se pudo completar la operación.");
            }
        }
    }
}