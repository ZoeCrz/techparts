using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                cargarCategorias();
                cargarMarcas();
            }
        }
        protected void btnSubirImagen_Click(object sender, EventArgs e)
        {
            if (fuImagen.HasFile)
            {
                string extension = Path.GetExtension(fuImagen.FileName).ToLower();
                long tamaño = fuImagen.PostedFile.ContentLength;
                int maxTamaño = 5 * 1024 * 1024;

                if (tamaño > maxTamaño)
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
                    // Obtener la ruta según la categoría
                    string rutaCategoria = obtenerRutaCategoria(ddlCategoria.SelectedValue);
                    
                    if (string.IsNullOrEmpty(rutaCategoria))
                    {
                        MostrarAlerta("Error: Categoría no válida", "error");
                        return;
                    }
                    string nombreArchivo = Guid.NewGuid().ToString() + extension;
                    string rutaCompleta = Server.MapPath(rutaCategoria);
                    if (!Directory.Exists(rutaCompleta))
                    {
                        Directory.CreateDirectory(rutaCompleta);
                    }
                    SafeImages.Save(fuImagen.PostedFile, Path.Combine(rutaCompleta, nombreArchivo));
                    imgProducto.ImageUrl = rutaCategoria + nombreArchivo;
                    MostrarAlerta("¡Imagen subida correctamente!", "success");
                }
                catch (Exception ex)
                {
                    MostrarAlerta("Error al subir imagen: " + "No se pudo completar la operación.", "error");
                }
            }
            else
            {
                MostrarAlerta("Por favor selecciona una imagen", "warning");
            }
        }
        private string obtenerRutaCategoria(string claveCategoria)
        {
            switch (claveCategoria)
            {
                case "1":
                    return "../PRODUCTOS/RAM/";
                case "2":
                    return "../PRODUCTOS/MOTHERBOARDS/";
                case "3":
                    return "../PRODUCTOS/FUENTES DE PODER/";
                case "4":
                    return "../PRODUCTOS/GRAFICAS/";
                case "5":
                    return "../PRODUCTOS/PROCESADORES/";
                case "6":
                    return "../PRODUCTOS/GABINETES/";
                default:
                    return null;
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
                int categoria = int.Parse(ddlCategoria.SelectedValue);
                int marca = int.Parse(ddlMarca.SelectedValue);
                string codigo = txtCodigo.Text.Trim();
                string nombre = txtNombre.Text.Trim();
                string descripcion = txtDescripcion.Text.Trim();
                float precio = float.Parse(txtPrecio.Text.Trim());
                int stock = int.Parse(txtStock.Text.Trim());
                string imagen = imgProducto.ImageUrl;
                DataSet resultado = objProducto.agregarProducto(
                    Application["cnnVentas"].ToString(),
                    categoria,
                    marca,
                    codigo,
                    nombre,
                    descripcion,
                    precio,
                    stock,
                    imagen
                );
                if (resultado != null && resultado.Tables.Count > 0 && resultado.Tables[0].Rows.Count > 0)
                {
                    string mensaje = resultado.Tables[0].Rows[0][0].ToString();
                    if (mensaje.Contains("éxito") || mensaje.Contains("exitoso"))
                    {
                        Response.Write("<script>alert('¡Producto guardado correctamente!'); window.location='frmAdmGestProductos.aspx';</script>");
                        LimpiarFormulario();
                    }
                    else
                    {
                        MostrarAlerta("Error al guardar: " + mensaje, "error");
                    }
                }
                else
                {
                    MostrarAlerta("Error al guardar el producto...", "error");
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error: " + "No se pudo completar la operación.".Replace("'", "\\'"), "error");
            }
        }
        private bool ValidarDatos()
        {
            if (ddlCategoria.SelectedValue == "0")
            {
                MostrarAlerta("Por favor selecciona una categoría", "warning");
                return false;
            }

            if (ddlMarca.SelectedValue == "0")
            {
                MostrarAlerta("Por favor selecciona una marca", "warning");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtCodigo.Text))
            {
                MostrarAlerta("El código del producto es obligatorio", "warning");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtNombre.Text))
            {
                MostrarAlerta("El nombre del producto es obligatorio", "warning");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDescripcion.Text))
            {
                MostrarAlerta("La descripción del producto es obligatoria", "warning");
                return false;
            }

            if (!float.TryParse(txtPrecio.Text, out float precio) || precio <= 0)
            {
                MostrarAlerta("El precio debe ser un número válido mayor a 0", "warning");
                return false;
            }

            if (!int.TryParse(txtStock.Text, out int stock) || stock < 0)
            {
                MostrarAlerta("El stock debe ser un número válido", "warning");
                return false;
            }

            if (imgProducto.ImageUrl == "../PRODUCTOS/default.png")
            {
                MostrarAlerta("Por favor sube una imagen del producto", "warning");
                return false;
            }

            return true;
        }
        private void LimpiarFormulario()
        {
            ddlCategoria.SelectedValue = "0";
            ddlMarca.SelectedValue = "0";
            txtCodigo.Text = string.Empty;
            txtNombre.Text = string.Empty;
            txtDescripcion.Text = string.Empty;
            txtPrecio.Text = string.Empty;
            txtStock.Text = string.Empty;
            imgProducto.ImageUrl = "../PRODUCTOS/default.png";
            fuImagen.FileBytes.ToString();
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
        private void cargarCategorias()
        {
            try
            {
                DataSet ds = objProducto.listarCategoriasDS(Application["cnnVentas"].ToString());

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ddlCategoria.DataSource = ds.Tables[0];
                    ddlCategoria.DataTextField = "Categoria";
                    ddlCategoria.DataValueField = "Clave";
                    ddlCategoria.DataBind();

                    ddlCategoria.Items.Insert(0, new ListItem("-- Selecciona la categoría del producto --", "0"));
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorRoles",
                    "alert('Error al cargar categorías: " + "No se pudo completar la operación.".Replace("'", "\\'") + "');", true);
            }
        }
        private void cargarMarcas()
        {
            try
            {
                DataTable dt = objProducto.listarMarcas(Application["cnnVentas"].ToString());

                if (dt != null && dt.Rows.Count > 0)
                {
                    ddlMarca.DataSource = dt;
                    ddlMarca.DataTextField = "Marca";
                    ddlMarca.DataValueField = "Clave";
                    ddlMarca.DataBind();
                    ddlMarca.Items.Insert(0, new ListItem("-- Selecciona la marca del producto --", "0"));
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorMarcas",
                    "alert('Error al cargar marcas: " + "No se pudo completar la operación.".Replace("'", "\\'") + "');", true);
            }
        }
    }
}