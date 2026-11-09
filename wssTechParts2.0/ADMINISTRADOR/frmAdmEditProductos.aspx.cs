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
    public partial class frmAdmEditProductos : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        private int claveProducto = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["cveSel"] != null)
                {
                    claveProducto = int.Parse(Session["cveSel"].ToString());
                    cargarCategorias();
                    cargarMarcas();
                    cargarDatosProducto();
                }
                else
                {
                    Response.Redirect("frmAdmGestProductos.aspx");
                }
            }
            // Recuperamos la clave en cada PostBack si ya estaba en sesión
            else if (Session["cveSel"] != null)
            {
                claveProducto = int.Parse(Session["cveSel"].ToString());
            }
        }
        private void cargarDatosProducto()
        {
            try
            {
                if (claveProducto <= 0)
                {
                    Response.Write("<script>alert('Error: No se ha seleccionado un producto válido...'); window.location='frmAdmGestProductos.aspx';</script>");
                    return;
                }
                DataSet ds = objProducto.buscarProducto(Application["cnnVentas"].ToString(), claveProducto);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    // 1. VALIDACIÓN SI EL PRODUCTO NO EXISTE (store procedure regresa 0)
                    if (ds.Tables[0].Rows[0][0].ToString() == "0")
                    {
                        Response.Write("<script>alert('El producto no puede ser editado ya que se encuentra INACTIVO...'); window.location='frmAdmGestProductos.aspx';</script>");
                        return;
                    }
                    // Leemos la fila
                    DataRow row = ds.Tables[0].Rows[0];
                    // 2. VALIDACIÓN SI EL PRODUCTO ESTÁ INACTIVO
                    // El SP devuelve la columna "Estatus" como "ACTIVO" o "INACTIVO"
                    string estatus = row["Estatus"].ToString();
                    if (estatus == "INACTIVO")
                    {
                        // A) Mandamos la alerta
                        Response.Write("<script>alert('El producto no puede ser editado ya que se encuentra INACTIVO...'); window.location='frmAdmGestProductos.aspx';</script>");

                        // B) Bloqueamos los controles para que no pueda editar
                        DeshabilitarControles();
                    }

                    // 3. CARGAR DATOS (Se cargan igual, esté activo o inactivo, para que el usuario los vea)
                    string catNombre = row["Categoria"].ToString();
                    string marNombre = row["Marca"].ToString();
                    txtCodigo.Text = row["Codigo"].ToString();
                    txtNombre.Text = row["Producto"].ToString();
                    txtDescripcion.Text = row["Descripcion"].ToString();
                    txtPrecio.Text = row["Costo"].ToString();
                    txtStock.Text = row["Existencias"].ToString();
                    imgProducto.ImageUrl = row["Imagen"].ToString();
                    ddlCategoria.SelectedValue = obtenerClaveCategoria(catNombre);
                    ddlMarca.SelectedValue = obtenerClaveMarca(marNombre);
                }
                else
                {
                    MostrarAlerta("Error: No se obtuvieron datos del servidor.", "error");
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error al cargar el producto: " + "No se pudo completar la operación.", "error");
            }
        }
        // --- MÉTODO AUXILIAR PARA BLOQUEAR EL FORMULARIO ---
        private void DeshabilitarControles()
        {
            // Deshabilitamos campos de texto
            txtCodigo.Enabled = false;
            txtNombre.Enabled = false;
            txtDescripcion.Enabled = false;
            txtPrecio.Enabled = false;
            txtStock.Enabled = false;
            // Deshabilitamos DropDowns
            ddlCategoria.Enabled = false;
            ddlMarca.Enabled = false;
            // Ocultamos o deshabilitamos botones de acción
            btnActualizar.Enabled = false;
            btnActualizar.Visible = false;
            btnSubirImagen.Enabled = false;
            fuImagen.Enabled = false;
        }
        private string obtenerClaveCategoria(string nombreCategoria)
        {
            try
            {
                DataSet ds = objProducto.listarCategoriasDS(Application["cnnVentas"].ToString());
                
                if (ds != null && ds.Tables.Count > 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        if (row["Categoria"].ToString() == nombreCategoria)
                        {
                            return row["Clave"].ToString();
                        }
                    }
                }
            }
            catch { }
            return "0";
        }
        private string obtenerClaveMarca(string nombreMarca)
        {
            try
            {
                DataSet ds = objProducto.listarMarcasDS(Application["cnnVentas"].ToString());
                if (ds != null && ds.Tables.Count > 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        if (row["Marca"].ToString() == nombreMarca)
                        {
                            return row["Clave"].ToString();
                        }
                    }
                }
            }
            catch { }
            return "0";
        }
        protected void btnSubirImagen_Click(object sender, EventArgs e)
        {
            if (fuImagen.HasFile)
            {
                string extension = Path.GetExtension(fuImagen.FileName).ToLower();
                long tamano = fuImagen.PostedFile.ContentLength;
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
                    MostrarAlerta("¡Imagen actualizada correctamente!", "success");
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
        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            if (!ValidarDatos()) return;
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
                int idProducto = int.Parse(Session["cveSel"].ToString());
                DataSet resultado = objProducto.actualizarProducto(
                    Application["cnnVentas"].ToString(),
                    idProducto,
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
                    int resultCode = int.Parse(resultado.Tables[0].Rows[0][0].ToString());

                    if (resultCode == 1)
                    {
                        Response.Write("<script>alert('¡Producto actualizado correctamente!'); window.location='frmAdmGestProductos.aspx';</script>");
                    }
                    else // AQUÍ ENTRA SI EL SP REGRESA 0
                    {
                        MostrarAlerta("No se pudieron guardar los cambios. Verifique que el producto siga existiendo...", "warning");
                    }
                }
                else
                {
                    MostrarAlerta("Error al conectar con la base de datos", "error");
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error crítico: " + "No se pudo completar la operación.", "error");
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
            return true;
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
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorCategorias",
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
