using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        clsUsuario objUsuario = new clsUsuario();
        int clave = 0, rolUsuario = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Verificar si hay un usuario seleccionado para editar
                if (Session["cveSel"] != null && Session["cveSel"].ToString() != "0")
                {
                    clave = int.Parse(Session["cveSel"].ToString());
                    objUsuario.buscarUsuario(Application["cnnVentas"].ToString(), clave);
                    // VALIDACIÓN: Verificar si existe el usuario
                    if (objUsuario != null && !string.IsNullOrEmpty(objUsuario.Usuario))
                    {
                        if (objUsuario.Estatus == "INACTIVO" || objUsuario.Estatus == "0")
                        {
                            Response.Write("<script>alert('El usuario no puede ser editado ya que se encuentra INACTIVO...'); window.location='frmAdmGestUsuarios.aspx';</script>");
                            // Bloquear formulario
                            DeshabilitarControles();
                        }
                        // Cargar datos (incluso si está inactivo para que se vean, pero readonly)
                        txtNombre.Text = objUsuario.NomUsuario ?? "";
                        txtApPaterno.Text = objUsuario.ApPat ?? "";
                        txtApMaterno.Text = objUsuario.ApMat ?? "";
                        txtUsuario.Text = objUsuario.Usuario ?? "";
                        txtContrasena.Text = ""; // Opcional ocultar pass
                        txtContrasena2.Text = ""; // Confirmación
                        txtEmail.Text = objUsuario.Email ?? "";
                        txtTelefono.Text = objUsuario.Telefono ?? "";
                        txtCalle.Text = objUsuario.Calle ?? "";
                        txtNumero.Text = objUsuario.Numero ?? "";
                        txtColonia.Text = objUsuario.Colonia ?? "";
                        txtCP.Text = objUsuario.CP.ToString();
                        txtCiudad.Text = objUsuario.Ciudad ?? "";
                        txtMunicipio.Text = objUsuario.Municipio ?? "";
                        txtEstado.Text = objUsuario.Estado ?? "";
                        imgFotoPerfil.ImageUrl = objUsuario.Foto ?? "../FOTOS/USUARIOS/default.png";
                    }
                    else
                    {
                        // Si no existe, regresamos al grid
                        Response.Redirect("frmAdmABDUsuarios.aspx");
                    }
                }
                else
                {
                    Response.Redirect("frmAdmABDUsuarios.aspx");
                }
            }
        }
        // --- MÉTODO AUXILIAR PARA BLOQUEAR FORMULARIO ---
        private void DeshabilitarControles()
        {
            // TextBoxes
            txtNombre.Enabled = false;
            txtApPaterno.Enabled = false;
            txtApMaterno.Enabled = false;
            txtUsuario.Enabled = false;
            txtContrasena.Enabled = false;
            txtContrasena2.Enabled = false;
            txtEmail.Enabled = false;
            txtTelefono.Enabled = false;
            txtCalle.Enabled = false;
            txtNumero.Enabled = false;
            txtColonia.Enabled = false;
            txtCP.Enabled = false;
            txtCiudad.Enabled = false;
            txtMunicipio.Enabled = false;
            txtEstado.Enabled = false;
            btnGuardar.Enabled = false;
            btnGuardar.Visible = false; // Ocultamos el botón guardar para evitar clics
            btnSubirFoto.Enabled = false;
            fuFoto.Enabled = false;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // 1. RE-VALIDAR SESIÓN Y CLAVE
            if (Session["cveSel"] == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorSession", "alert('La sesión ha caducado.');", true);
                return;
            }
            clave = int.Parse(Session["cveSel"].ToString());
            // 2. RE-VALIDAR ESTATUS (SEGURIDAD)
            objUsuario.buscarUsuario(Application["cnnVentas"].ToString(), clave);
            if (objUsuario.Estatus == "INACTIVO" || objUsuario.Estatus == "0")
            {
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorInactivo",
                    "alert('Error de seguridad: No se pueden guardar cambios en un usuario inactivo...');", true);
                return;
            }
            string msg = validarDatos();
            if (msg == "")
            {
                try
                {
                    // 3. Determinar el rol
                    rolUsuario = 2;

                    if (!string.IsNullOrEmpty(objUsuario.Rol))
                    {
                        if (objUsuario.Rol.Trim().ToUpper() == "ADMINISTRADOR")
                        {
                            rolUsuario = 1;
                        }
                    }
                    // 4. Actualizar
                    DataSet dsResultado = objUsuario.actualizarInformacionUsuario(
                        Application["cnnVentas"].ToString(),
                        clave,
                        rolUsuario,
                        txtNombre.Text.Trim(),
                        txtApPaterno.Text.Trim(),
                        txtApMaterno.Text.Trim(),
                        txtEmail.Text.Trim(),
                        txtTelefono.Text.Trim(),
                        txtCalle.Text.Trim(),
                        txtNumero.Text.Trim(),
                        txtColonia.Text.Trim(),
                        txtCiudad.Text.Trim(),
                        txtMunicipio.Text.Trim(),
                        txtEstado.Text.Trim(),
                        int.Parse(txtCP.Text.Trim()),
                        imgFotoPerfil.ImageUrl,
                        txtUsuario.Text.Trim(),
                        txtContrasena.Text.Trim()
                    );
                    // 5. Verificar Resultado
                    int resultado = 0;
                    if (dsResultado != null && dsResultado.Tables.Count > 0 && dsResultado.Tables[0].Rows.Count > 0)
                    {
                        string valorRetorno = dsResultado.Tables[0].Rows[0][0].ToString();
                        if (int.TryParse(valorRetorno, out resultado) && resultado > 0)
                        {
                            Session["fotoTemp"] = null;
                            Response.Write("<script>alert('¡Actualización exitosa!'); window.location='frmAdmGestUsuarios.aspx';</script>");
                        }
                        else
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "ErrorLogico",
                                "alert('Error: No se pudo actualizar el registro. Verifique los datos.');", true);
                        }
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "ErrorBD",
                            "alert('Error: No se recibió respuesta de la base de datos');", true);
                    }
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "ErrorGeneral",
                        "alert('Error: " + "No se pudo completar la operación.".Replace("'", "\\'") + "');", true);
                }
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorValidacion",
                    "alert('" + msg.Replace("'", "\\'") + "');", true);
            }
        }
        protected void btnSubirFoto_Click(object sender, EventArgs e)
        {
            if (fuFoto.HasFile)
            {
                try
                {
                    // Validar tamaño del archivo (5 MB máximo)
                    if (fuFoto.PostedFile.ContentLength > 5242880)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "FotoError",
                            "alert('El archivo es demasiado grande. Máximo 5MB.');", true);
                        return;
                    }

                    // Validar tipo de archivo
                    string extension = Path.GetExtension(fuFoto.FileName).ToLower();
                    if (extension != ".jpg" && extension != ".jpeg" && extension != ".png" && extension != ".gif")
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "FotoError",
                            "alert('Solo se permiten archivos JPG, PNG o GIF.');", true);
                        return;
                    }
                    // Carpeta donde seguardarán las fotos
                    string rutaCarpeta = Server.MapPath("../FOTOS/USUARIOS/");
                    // Crear la carpeta si no existe
                    if (!Directory.Exists(rutaCarpeta))
                        Directory.CreateDirectory(rutaCarpeta);
                    // Obtener clave del usuario para el nombre
                    string claveUsuario = Session["cveUsuario"].ToString();
                    // Crear nombre único del archivo
                    string nombreUnico = "USER_" + claveUsuario + "_" +
                                       DateTime.Now.ToString("yyyyMMddHHmmss") + extension;
                    // Guardar archivo
                    string rutaGuardar = Path.Combine(rutaCarpeta, nombreUnico);
                    SafeImages.Save(fuFoto.PostedFile, rutaGuardar);
                    // Asignar la ruta relativa a la imagen
                    string rutaRelativa = "../FOTOS/USUARIOS/" + nombreUnico;
                    imgFotoPerfil.ImageUrl = rutaRelativa;
                    // Guardar la ruta en la sesión temporalmente
                    Session["fotoTemp"] = rutaRelativa;
                    // Mensaje de éxito
                    ClientScript.RegisterStartupScript(this.GetType(), "FotoOk",
                        "alert('¡Foto subida correctamente! Recuerde hacer clic en Guardar Cambios.');", true);
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "FotoError",
                        "alert('Error al subir la foto: " + "No se pudo completar la operación.".Replace("'", "\\'") + "');", true);
                }
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "NoFoto",
                    "alert('Debe seleccionar una foto para subir...');", true);
            }
        }
        private string validarDatos()
        {
            string mensaje = "";

            // Validar nombre
            if (string.IsNullOrWhiteSpace(txtNombre.Text))
                mensaje += "- El nombre es obligatorio\\n";

            // Validar apellido paterno
            if (string.IsNullOrWhiteSpace(txtApPaterno.Text))
                mensaje += "- El apellido paterno es obligatorio\\n";

            // Validar apellido materno
            if (string.IsNullOrWhiteSpace(txtApMaterno.Text))
                mensaje += "- El apellido materno es obligatorio\\n";

            // Validar correo
            if (string.IsNullOrWhiteSpace(txtEmail.Text))
                mensaje += "- El correo es obligatorio\\n";
            else if (!txtEmail.Text.Contains("@"))
                mensaje += "- El correo debe tener un formato válido\\n";

            // Validar teléfono
            if (string.IsNullOrWhiteSpace(txtTelefono.Text))
                mensaje += "- El teléfono es obligatorio\\n";
            else if (txtTelefono.Text.Length < 10)
                mensaje += "- El teléfono debe tener al menos 10 dígitos\\n";

            if (string.IsNullOrWhiteSpace(txtCalle.Text))
                mensaje += "- La calle es obligatoria\\n";

            if (string.IsNullOrWhiteSpace(txtNumero.Text))
                mensaje += "- El número de casa es obligatorio\\n";

            if (string.IsNullOrWhiteSpace(txtColonia.Text))
                mensaje += "- La colonia es obligatoria\\n";

            if (string.IsNullOrWhiteSpace(txtCiudad.Text))
                mensaje += "- La ciudad es obligatoria\\n";

            if (string.IsNullOrWhiteSpace(txtMunicipio.Text))
                mensaje += "- El municipio es obligatorio\\n";

            if (string.IsNullOrWhiteSpace(txtEstado.Text))
                mensaje += "- El estado es obligatorio\\n";

            // Validar código postal
            if (string.IsNullOrWhiteSpace(txtCP.Text))
                mensaje += "- El código postal es obligatorio\\n";
            else
            {
                int cp;
                if (!int.TryParse(txtCP.Text, out cp))
                    mensaje += "- El código postal debe ser numérico\\n";
            }

            // Validar usuario
            if (string.IsNullOrWhiteSpace(txtUsuario.Text))
                mensaje += "- El nombre de usuario es obligatorio\\n";

            if (txtContrasena.Text != txtContrasena2.Text)
                mensaje += "- Las contraseñas no coinciden\\n";
            return mensaje;
        }
    }
}
