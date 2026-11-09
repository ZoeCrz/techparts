using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.CLIENTE
{
    public partial class Formulario_web14 : System.Web.UI.Page
    {
        clsUsuario objUsuario = new clsUsuario();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Verifica si hay un usuario en sesión
                if (Session["cveUsuario"] != null && Session["cveUsuario"].ToString() != "0")
                {
                    int claveUsuario = int.Parse(Session["cveUsuario"].ToString());

                    // Ejecuta el procedimiento spBuscarUsuario
                    objUsuario.buscarUsuario(Application["cnnVentas"].ToString(), claveUsuario);

                    txtNombre.Text = objUsuario.NomUsuario;
                    txtApPaterno.Text = objUsuario.ApPat;
                    txtApMaterno.Text = objUsuario.ApMat;
                    txtEmail.Text = objUsuario.Email;
                    txtTelefono.Text = objUsuario.Telefono;
                    txtCalle.Text = objUsuario.Calle;
                    txtNumero.Text = objUsuario.Numero;
                    txtColonia.Text = objUsuario.Colonia;
                    txtCiudad.Text = objUsuario.Ciudad;
                    txtMunicipio.Text = objUsuario.Municipio;
                    txtEstado.Text = objUsuario.Estado;
                    txtCP.Text = objUsuario.CP.ToString();
                    txtUsuario.Text = objUsuario.Usuario;
                    imgFotoPerfil.ImageUrl = objUsuario.Foto;
                    // NO cargar la contraseña - dejar vacío para que el usuario la ingrese
                    txtContrasena.Text = "";
                }
            }
        }
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Validar los datos primero
            string msg = validarDatos();

            if (msg == "")
            {
                try
                {
                    // Valida que haya un usuario en sesión
                    if (Session["cveUsuario"] == null)
                    {
                        Response.Redirect("../frmIniciarSesion.aspx");
                        return;
                    }

                    int claveUsuario = int.Parse(Session["cveUsuario"].ToString());

                    // VALIDAR QUE LA CONTRASEÑA INGRESADA SEA CORRECTA
                    objUsuario.buscarUsuario(Application["cnnVentas"].ToString(), claveUsuario);

                    if (txtContrasena2.Text != txtContrasena.Text)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "ErrorContrasena",
                            "alert('Las contraseñas no coinciden');", true);
                        return;
                    }

                    // Obtiene el rol del usuario (cliente = 2)
                    int rolUsuario = 2;

                    // Llamar el método actualizarInformacionUsuario que retorna DataSet
                    DataSet dsResultado = objUsuario.actualizarInformacionUsuario(
                        Application["cnnVentas"].ToString(),
                        claveUsuario,
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

                    // Verificar el resultado del DataSet
                    int resultado = 0;
                    if (dsResultado != null && dsResultado.Tables.Count > 0 && dsResultado.Tables[0].Rows.Count > 0)
                    {
                        if (int.TryParse(dsResultado.Tables[0].Rows[0]["Clave"].ToString(), out resultado))
                        {
                            if(resultado > 0)
{
                                Session["fotoTemp"] = null;

                                // Actualizar la sesión con el nuevo nombre
                                string nombreCompleto = txtNombre.Text.Trim() + " " +
                                                      txtApPaterno.Text.Trim() + " " +
                                                      txtApMaterno.Text.Trim();
                                Session["nombreUsuario"] = nombreCompleto;

                                txtContrasena.Text = "";

                                Response.Write("<script>alert('¡Información actualizada exitosamente!'); window.location='frmCliPrincipal.aspx';</script>");
                            }



                            else
                            {
                                ClientScript.RegisterStartupScript(this.GetType(), "ErrorActualizacion",
                                    "alert('Error: No se pudo actualizar la información...');", true);
                            }
                        }
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "ErrorBD",
                            "alert('Error: No se recibió respuesta de la base de datos');", true);
                    }
                }
                catch (FormatException)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "ErrorFormato",
                        "alert('Error: El código postal debe ser un número válido');", true);
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "ErrorGeneral",
                        "alert('Error: " + "No se pudo completar la operación.".Replace("'", "\\'") + "');", true);
                }
            }
            else
            {
                // Mostrar errores de validación
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

                    // Carpeta donde se guardarán las fotos
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
                    "alert('Debe seleccionar una foto para subir.');", true);
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

            return mensaje;
        }

    }
}
