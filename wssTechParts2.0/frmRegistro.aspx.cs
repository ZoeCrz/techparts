using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        clsUsuario objUsuario = new clsUsuario();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                imgFotoPerfil.ImageUrl = "/FOTOS/USUARIOS/default.png";
            }
        }
        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            string msg = validarDatos();

            if (msg == "")
            {
                try
                {
                    // Validar que el usuario y email no estén en uso
                    int validacion = objUsuario.validarUsuarioYEmail(
                        Application["cnnVentas"].ToString(),
                        txtUsuario.Text.Trim(),
                        txtEmail.Text.Trim()
                    );

                    if (validacion == 1)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "ErrorUsuario",
                            "alert('Error: El nombre de usuario ya está en uso. Por favor, elige otro.');", true);
                        return;
                    }
                    else if (validacion == 2)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "ErrorEmail",
                            "alert('Error: El correo electrónico ya está registrado. Por favor, utiliza otro.');", true);
                        return;
                    }
                    else if (validacion == 3)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "ErrorAmbos",
                            "alert('Error: El usuario y el correo ya están registrados. Por favor, utiliza otros.');", true);
                        return;
                    }
                    int rolUsuario = 2; // Rol de cliente
                    string fotoRuta;
                    if (Session["fotoTemp"] != null && Session["fotoTemp"].ToString() != "")
                    {
                        fotoRuta = Session["fotoTemp"].ToString();
                    }
                    else
                    {
                        // Si no subió foto, forzamos la ruta por defecto aquí
                        fotoRuta = "/FOTOS/USUARIOS/default.png";
                    }
                    DataSet dsResultado = objUsuario.agregarUsuario(
                        Application["cnnVentas"].ToString(),
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
                        fotoRuta,
                        txtUsuario.Text.Trim(),
                        txtContrasena.Text.Trim()
                    );
                    int resultado = 0;
                    if (dsResultado != null && dsResultado.Tables.Count > 0 && dsResultado.Tables[0].Rows.Count > 0)
                    {
                        if (int.TryParse(dsResultado.Tables[0].Rows[0]["Clave"].ToString(), out resultado))
                        {
                            if (resultado > 0)
                            {
                                Session["fotoTemp"] = null;

                                string script = @"<script type='text/javascript'>
                                    alert('¡Te has registrado exitosamente!');
                                    window.location.href = 'frmIniciarSesion.aspx';
                                </script>";
                                ClientScript.RegisterStartupScript(this.GetType(), "RegistroExitoso", script);
                            }
                            else
                            {
                                ClientScript.RegisterStartupScript(this.GetType(), "ErrorRegistro",
                                    "alert('Error: No se pudo realizar tu registro. Intenta más tarde.');", true);
                            }
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
                    if (fuFoto.PostedFile.ContentLength > 5242880)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "FotoError",
                            "alert('El archivo es demasiado grande. Máximo 5MB.');", true);
                        return;
                    }
                    string extension = Path.GetExtension(fuFoto.FileName).ToLower();
                    if (extension != ".jpg" && extension != ".jpeg" && extension != ".png" && extension != ".gif")
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "FotoError",
                            "alert('Solo se permiten archivos JPG, PNG o GIF.');", true);
                        return;
                    }
                    string rutaCarpeta = Server.MapPath("/FOTOS/USUARIOS/");
                    if (!Directory.Exists(rutaCarpeta))
                        Directory.CreateDirectory(rutaCarpeta);
                    string nombreUnico = "NUEVO_" + DateTime.Now.ToString("yyyyMMddHHmmss") + extension;
                    string rutaGuardar = Path.Combine(rutaCarpeta, nombreUnico);
                    SafeImages.Save(fuFoto.PostedFile, rutaGuardar);
                    string rutaRelativa = "/FOTOS/USUARIOS/" + nombreUnico;
                    imgFotoPerfil.ImageUrl = rutaRelativa;
                    Session["fotoTemp"] = rutaRelativa;
                    ClientScript.RegisterStartupScript(this.GetType(), "FotoOk",
                        "alert('¡Foto subida correctamente!');", true);
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
                    "alert('Debe seleccionar una foto para subir.');", true);
            }
        }

        private string validarDatos()
        {
            string mensaje = "";

            if (string.IsNullOrWhiteSpace(txtNombre.Text))
                mensaje += "- El nombre es obligatorio\\n";

            if (string.IsNullOrWhiteSpace(txtApPaterno.Text))
                mensaje += "- El apellido paterno es obligatorio\\n";

            if (string.IsNullOrWhiteSpace(txtApMaterno.Text))
                mensaje += "- El apellido materno es obligatorio\\n";

            if (string.IsNullOrWhiteSpace(txtEmail.Text))
                mensaje += "- El correo es obligatorio\\n";
            else if (!txtEmail.Text.Contains("@"))
                mensaje += "- El correo debe tener un formato válido\\n";

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

            if (string.IsNullOrWhiteSpace(txtCP.Text))
                mensaje += "- El código postal es obligatorio\\n";
            else
            {
                int cp;
                if (!int.TryParse(txtCP.Text, out cp))
                    mensaje += "- El código postal debe ser numérico\\n";
            }

            if (string.IsNullOrWhiteSpace(txtUsuario.Text))
                mensaje += "- El nombre de usuario es obligatorio\\n";

            if (string.IsNullOrWhiteSpace(txtContrasena.Text))
                mensaje += "- La contraseña es obligatoria\\n";
            else if (txtContrasena.Text.Length < 12 || txtContrasena.Text.Length > 128)
                mensaje += "- La contraseña debe tener entre 12 y 128 caracteres\\n";

            if (string.IsNullOrWhiteSpace(txtConfirmarContrasena.Text))
                mensaje += "- Debe confirmar la contraseña\\n";
            else if (txtContrasena.Text != txtConfirmarContrasena.Text)
                mensaje += "- Las contraseñas no coinciden\\n";
            return mensaje;
        }
    }
}
