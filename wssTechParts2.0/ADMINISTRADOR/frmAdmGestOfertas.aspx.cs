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
    public partial class Formulario_web16 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarProductos();
                LimpiarFormulario();
            }
        }
        private void CargarProductos()
        {
            DataTable dt = objProducto.listarProductos(Application["cnnVentas"].ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlProductos.DataSource = dt;
                ddlProductos.DataTextField = "Productos";
                ddlProductos.DataValueField = "Clave";
                ddlProductos.DataBind();
                ddlProductos.Items.Insert(0, new ListItem("-- Seleccione un producto --", "0"));
            }
        }
        // EVENTO AL CAMBIAR PRODUCTO
        protected void ddlProductos_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idProducto = int.Parse(ddlProductos.SelectedValue);

            if (idProducto > 0)
            {
                // 1. Obtener datos del producto para saber su PRECIO (Para validación)
                DataSet dsProd = objProducto.buscarProducto(Application["cnnVentas"].ToString(), idProducto);
                if (dsProd != null && dsProd.Tables.Count > 0 && dsProd.Tables[0].Rows.Count > 0)
                {
                    string precioStr = dsProd.Tables[0].Rows[0]["Costo"].ToString();
                    hfPrecioProducto.Value = precioStr; // Guardamos en HiddenField para el JS
                }
                // 2. Verificar si ya tiene oferta
                DataSet dsPromo = objProducto.obtenerPromocionPorProducto(Application["cnnVentas"].ToString(), idProducto);

                if (dsPromo != null && dsPromo.Tables.Count > 0 && dsPromo.Tables[0].Rows.Count > 0)
                {
                    // MODO EDICIÓN
                    DataRow row = dsPromo.Tables[0].Rows[0];
                    hfIdPromocion.Value = row["ROM_Clave"].ToString();
                    txtTitulo.Text = row["ROM_Titulo"].ToString();
                    txtDescripcion.Text = row["ROM_Descripcion"].ToString();
                    ddlTipo.SelectedValue = row["ROM_TipoPromocion"].ToString();
                    txtDescuento.Text = row["ROM_Descuento"].ToString();
                    DateTime inicio = DateTime.Parse(row["ROM_FechaInicio"].ToString());
                    DateTime fin = DateTime.Parse(row["ROM_FechaFin"].ToString());
                    txtFechaInicio.Text = inicio.ToString("yyyy-MM-dd");
                    txtFechaFin.Text = fin.ToString("yyyy-MM-dd");
                    string img = row["ROM_ImagenBanner"].ToString();
                    if (!string.IsNullOrEmpty(img)) imgBanner.ImageUrl = img;

                    btnGuardarPromo.Text = "Actualizar Oferta";
                }
                else
                {
                    // MODO CREACIÓN (Limpio, pero manteniendo el precio en hfPrecioProducto)
                    LimpiarFormulario(false);
                }
            }
            else
            {
                LimpiarFormulario(true);
            }
        }
        private void LimpiarFormulario(bool borrarTodo = true)
        {
            hfIdPromocion.Value = "0";
            if (borrarTodo) hfPrecioProducto.Value = "0"; // Si reseteamos todo, precio es 0
            txtTitulo.Text = "";
            txtDescripcion.Text = "";
            txtDescuento.Text = "";
            txtFechaInicio.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtFechaFin.Text = DateTime.Now.AddDays(7).ToString("yyyy-MM-dd");
            imgBanner.ImageUrl = "../FOTOS/BANNERS/default.jpg";
            btnGuardarPromo.Text = "Guardar Oferta";
        }
        protected void btnSubirImagen_Click(object sender, EventArgs e)
        {
            if (fuBanner.HasFile)
            {
                try
                {
                    // Validar tamaño (5 MB)
                    if (fuBanner.PostedFile.ContentLength > 5242880)
                    {
                        MostrarAlerta("El archivo es demasiado grande. Máximo 5MB.");
                        return;
                    }

                    // Validar extensión
                    string extension = Path.GetExtension(fuBanner.FileName).ToLower();
                    string[] permitidas = { ".jpg", ".jpeg", ".png", ".gif" };

                    if (!permitidas.Contains(extension))
                    {
                        MostrarAlerta("Formato no válido. Solo JPG, PNG o GIF.");
                        return;
                    }

                    // Guardar archivo
                    string rutaCarpeta = Server.MapPath("../FOTOS/BANNERS/");
                    if (!Directory.Exists(rutaCarpeta)) Directory.CreateDirectory(rutaCarpeta);

                    // Nombre único para evitar conflictos
                    string nombreArchivo = "PROMO_TEMP_" + DateTime.Now.Ticks + extension;
                    string rutaGuardar = Path.Combine(rutaCarpeta, nombreArchivo);

                    SafeImages.Save(fuBanner.PostedFile, rutaGuardar);

                    // Mostrar en el control Image
                    imgBanner.ImageUrl = "../FOTOS/BANNERS/" + nombreArchivo;

                    MostrarAlerta("¡Imagen cargada correctamente!");
                }
                catch (Exception ex)
                {
                    MostrarAlerta("Error al subir imagen: " + "No se pudo completar la operación.");
                }
            }
            else
            {
                MostrarAlerta("Por favor, seleccione un archivo primero.");
            }
        }
        protected void btnGuardarPromo_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddlProductos.SelectedValue == "0") { MostrarAlerta("Seleccione un producto"); return; }

                string tipo = ddlTipo.SelectedValue;
                float descuento = float.Parse(txtDescuento.Text);
                float precioProducto = float.Parse(hfPrecioProducto.Value);

                // --- VALIDACIÓN DE SEGURIDAD (BACKEND) ---
                if (tipo == "Porcentaje" && descuento > 100)
                {
                    MostrarAlerta("Error: El porcentaje no puede ser mayor a 100.");
                    return;
                }
                if (tipo == "MontoFijo" && descuento >= precioProducto)
                {
                    MostrarAlerta("Error: El descuento ($" + descuento + ") no puede superar el precio del producto ($" + precioProducto + ").");
                    return;
                }
                // ... Recolección de datos ...
                int idProducto = int.Parse(ddlProductos.SelectedValue);
                int idPromo = int.Parse(hfIdPromocion.Value);
                string titulo = txtTitulo.Text.Trim();
                string descripcion = txtDescripcion.Text.Trim();
                DateTime fechaInicio = DateTime.Parse(txtFechaInicio.Text);
                DateTime fechaFin = DateTime.Parse(txtFechaFin.Text);
                string imagen = imgBanner.ImageUrl; // Mantener la actual por defecto
                if (fuBanner.HasFile)
                {
                    string ext = Path.GetExtension(fuBanner.FileName);
                    string nombreArchivo = "PROMO_" + idProducto + "_" + DateTime.Now.Ticks + ext;
                    string ruta = Server.MapPath("../FOTOS/BANNERS/");
                    if (!Directory.Exists(ruta)) Directory.CreateDirectory(ruta);
                    SafeImages.Save(fuBanner.PostedFile, ruta + nombreArchivo);
                    imagen = "../FOTOS/BANNERS/" + nombreArchivo;
                }
                int resultado = 0;
                if (idPromo == 0)
                {
                    resultado = objProducto.registrarPromocion(Application["cnnVentas"].ToString(), idProducto, titulo, descripcion, tipo, descuento, fechaInicio, fechaFin, imagen, 1);
                }
                else
                {
                    resultado = objProducto.actualizarPromocion(Application["cnnVentas"].ToString(), idPromo, titulo, descripcion, tipo, descuento, fechaInicio, fechaFin, imagen);
                }

                if (resultado == 1)
                {
                    Response.Write("<script>alert('¡Oferta guardada correctamente!'); window.location='frmAdmGestProductos.aspx';</script>");
                }
                else
                {
                    MostrarAlerta("No se pudo guardar la oferta...");
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error: " + "No se pudo completar la operación.");
            }
        }
        private void MostrarAlerta(string msg)
        {
            msg = System.Web.HttpUtility.JavaScriptStringEncode(msg);
            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{msg}');", true);
        }
    }
}