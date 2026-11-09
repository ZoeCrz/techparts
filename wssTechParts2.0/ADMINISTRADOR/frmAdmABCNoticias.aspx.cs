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
    public partial class Formulario_web110 : System.Web.UI.Page
    {
        clsNoticia objNoticia = new clsNoticia();
        int claveNoticia = 0;
        private string carpetaImagenes = "../NOTICIAS/";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["cveNoticia"] != null && int.TryParse(Session["cveNoticia"].ToString(), out claveNoticia) && claveNoticia > 0)
                {
                    lblTituloPagina.Text = "Editar Noticia";
                    btnGuardar.Text = "Actualizar Noticia";
                    CargarDatos();
                }
                else
                {
                    lblTituloPagina.Text = "Nueva Noticia";
                    btnGuardar.Text = "Publicar Noticia";
                    imgNoticia.ImageUrl = carpetaImagenes + "default.jpg";
                }
            }
            // Recuperar clave en PostBack
            else if (Session["cveNoticia"] != null)
            {
                int.TryParse(Session["cveNoticia"].ToString(), out claveNoticia);
            }
        }
        private void CargarDatos()
        {
            try
            {
                DataSet ds = objNoticia.buscarNoticia(Application["cnnVentas"].ToString(), claveNoticia);

                if (ds != null && ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Columns.Contains("NOT_Clave") && ds.Tables[0].Rows[0]["NOT_Clave"].ToString() == "0")
                    {
                        Response.Write("<script>alert('La noticia no existe...'); window.location='frmAdmGestNoticias.aspx';</script>");
                        return;
                    }
                    DataRow row = ds.Tables[0].Rows[0];
                    // 2. VALIDACIÓN DE ESTATUS INACTIVO
                    string estatus = row["Estatus"].ToString();

                    if (estatus == "INACTIVA")
                    {
                        Response.Write("<script>alert('La noticia no puede ser editada ya que se encuentra INACTIVA...'); window.location='frmAdmGestNoticias.aspx';</script>");
                        DeshabilitarControles();
                    }
                    // 3. Cargar Datos
                    txtTitulo.Text = row["NOT_Titulo"].ToString();
                    txtContenido.Text = row["NOT_Contenido"].ToString();
                    txtURL.Text = row["NOT_URL"].ToString();
                    string img = row["NOT_Imagen"].ToString();
                    if (!string.IsNullOrEmpty(img)) imgNoticia.ImageUrl = img;
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error al cargar datos: " + "No se pudo completar la operación.");
            }
        }
        private void DeshabilitarControles()
        {
            txtTitulo.Enabled = false;
            txtContenido.Enabled = false;
            txtURL.Enabled = false;
            btnGuardar.Enabled = false;
            btnGuardar.Visible = false; // Ocultar botón guardar
            btnSubirImagen.Enabled = false;
            fuImagen.Enabled = false;
        }
        protected void btnSubirImagen_Click(object sender, EventArgs e)
        {
            if (fuImagen.HasFile)
            {
                try
                {
                    // Validaciones de archivo
                    if (fuImagen.PostedFile.ContentLength > 5242880)
                    {
                        MostrarAlerta("La imagen es demasiado grande (Máx 5MB).");
                        return;
                    }

                    string ext = Path.GetExtension(fuImagen.FileName).ToLower();
                    if (ext != ".jpg" && ext != ".png" && ext != ".jpeg")
                    {
                        MostrarAlerta("Solo formato JPG o PNG.");
                        return;
                    }

                    // Guardar
                    string rutaFisica = Server.MapPath(carpetaImagenes);
                    if (!Directory.Exists(rutaFisica)) Directory.CreateDirectory(rutaFisica);

                    string nombreArchivo = "NEWS_" + DateTime.Now.Ticks + ext;
                    SafeImages.Save(fuImagen.PostedFile, Path.Combine(rutaFisica, nombreArchivo));

                    // Mostrar
                    imgNoticia.ImageUrl = carpetaImagenes + nombreArchivo;
                    MostrarAlerta("¡Imagen cargada correctamente!");
                }
                catch (Exception ex)
                {
                    MostrarAlerta("Error al subir imagen: " + "No se pudo completar la operación.");
                }
            }
            else
            {
                MostrarAlerta("Seleccione un archivo primero.");
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // RE-VALIDACIÓN DE SEGURIDAD (Por si habilitan el botón con F12)
            if (claveNoticia > 0)
            {
                DataSet dsCheck = objNoticia.buscarNoticia(Application["cnnVentas"].ToString(), claveNoticia);
                if (dsCheck != null && dsCheck.Tables[0].Rows.Count > 0)
                {
                    if (dsCheck.Tables[0].Rows[0]["Estatus"].ToString() == "INACTIVA")
                    {
                        MostrarAlerta("Error: No se pueden guardar cambios en una noticia inactiva.");
                        return;
                    }
                }
            }

            // ... (El resto de tu lógica de validación y guardado sigue igual) ...
            if (string.IsNullOrWhiteSpace(txtTitulo.Text)) { MostrarAlerta("El título es obligatorio."); return; }
            if (string.IsNullOrWhiteSpace(txtContenido.Text)) { MostrarAlerta("El contenido es obligatorio."); return; }
            if (imgNoticia.ImageUrl == "../NOTICIAS/default.jpg") { MostrarAlerta("Por favor sube una imagen de portada."); return; }

            string imagen = imgNoticia.ImageUrl;
            string url = txtURL.Text.Trim();
            if (string.IsNullOrEmpty(url)) url = "#";

            try
            {
                DataSet res;
                if (claveNoticia == 0)
                {
                    res = objNoticia.agregarNoticia(Application["cnnVentas"].ToString(), txtTitulo.Text.Trim(), txtContenido.Text.Trim(), imagen, url);
                }
                else
                {
                    res = objNoticia.actualizarNoticia(Application["cnnVentas"].ToString(), claveNoticia, txtTitulo.Text.Trim(), txtContenido.Text.Trim(), imagen, url);
                }

                if (res != null && res.Tables[0].Rows[0][0].ToString() == "1")
                {
                    Response.Write("<script>alert('¡Noticia guardada exitosamente!'); window.location='frmAdmGestNoticias.aspx';</script>");
                }
                else
                {
                    MostrarAlerta("No se pudo guardar la noticia...");
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error crítico: " + "No se pudo completar la operación.");
            }
        }
        private void MostrarAlerta(string msg)
        {
            msg = System.Web.HttpUtility.JavaScriptStringEncode(msg);
            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{msg.Replace("'", "")}');", true);
        }
    }
}