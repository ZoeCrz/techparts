using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0
{
    public partial class Formulario_web11 : System.Web.UI.Page
    {
        // COPIA E INSTANCIA DE LA CLASE
        clsUsuario objUsu = new clsUsuario();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnIniciarSesion_Click(object sender, EventArgs e)
        {
            try
            {
                // 3. Validar que los controles tengan datos
                if (txtUsuario.Text != "" && txtContrasena.Text != "")
                {
                    // 3.1 Asignar los valores a las propiedades de la clase
                    objUsu.Usuario = txtUsuario.Text;
                    objUsu.Contra = txtContrasena.Text;
                    // 3.2 Ejecutar el método de la clase que valida el acceso
                    objUsu.validarAcceso(Application["cnnVentas"].ToString());
                    // 3.3 Si permite el acceso o no al sistema
                    if (objUsu.Clave != 0)
                    {
                        // Se asignan los datos a las variables de sesión
                        Session["cveUsuario"] = objUsu.Clave;
                        Session["nombreUsuario"] = objUsu.NomUsuario;
                        Session["Rol"] = objUsu.Rol;
                        if (objUsu.Rol.ToUpper() == "ADMINISTRADOR")
                        {
                            Response.Write("<script language = 'javascript'>alert('Bienvenid@ " + System.Web.HttpUtility.JavaScriptStringEncode(objUsu.NomUsuario) + ", estás accediendo como " + System.Web.HttpUtility.JavaScriptStringEncode(objUsu.Rol) + ".');document.location.href='ADMINISTRADOR/frmAdmPrincipal.aspx';</script>");
                        }
                        else if (objUsu.Rol.ToUpper() == "CLIENTE")
                        {
                            Response.Write("<script language = 'javascript'>alert('Bienvenid@ " + System.Web.HttpUtility.JavaScriptStringEncode(objUsu.NomUsuario) + ", estás accediendo como " + System.Web.HttpUtility.JavaScriptStringEncode(objUsu.Rol) + ".');document.location.href='CLIENTE/frmCliPrincipal.aspx';</script>");
                        }
                    }
                    else
                    {
                        Response.Write("<script language = 'javascript'>alert('Error: Las credenciales de acceso son incorrectas o el usuario está dado de baja...');</script>");
                        txtContrasena.Focus();
                    }
                }
                else
                {
                    Response.Write("<script language = 'javascript'>alert('Debes ingresar el usuario y contraseña de acceso...');</script>");
                    txtUsuario.Focus();
                }
            }
            catch (Exception)
            {
                Response.Write("<script language = 'javascript'>alert('Verificar la cadena de conexión y datos de conexión...');</script>");
            }
        }
    }
}