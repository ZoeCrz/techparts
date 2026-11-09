using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using wssCarritoCompras;

namespace wssTechParts2._0.CLIENTE
{
    public partial class Formulario_web16 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        clsCarrito objCarrito = new clsCarrito();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["clave"] != null)
                {
                    int claveProducto;
                    if (int.TryParse(Request.QueryString["clave"], out claveProducto))
                    {
                        mostrarDetalle(claveProducto);
                    }
                }
            }
        }
        private void mostrarDetalle(int clave)
        {
            DataTable dt = objProducto.mostrarProducto(Application["cnnVentas"].ToString(), clave);

            // 1. Validamos si trajo algo
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Columns.Count == 1 && dt.Rows[0][0].ToString() == "0")
                {
                    // Producto no encontrado o inactivo
                    Response.Write("<script>alert('El producto no existe o no está disponible...'); window.location='frmCliDetVenta.aspx';</script>");
                    return; // Detenemos la ejecución
                }

                // Si pasa la validación anterior, es un producto real y podemos leer sus columnas
                try
                {
                    // Datos básicos
                    lblNombre.Text = dt.Rows[0]["Producto"].ToString();
                    lblCategoria.Text = dt.Rows[0]["Categoria"].ToString();
                    lblDescripcion.Text = dt.Rows[0]["Descripcion"].ToString();
                    lblExistencias.Text = dt.Rows[0]["Existencias"].ToString();

                    // --- LÓGICA DE PRECIOS ---
                    double costoFinal = Convert.ToDouble(dt.Rows[0]["CostoFinal"]);
                    double costoOriginal = Convert.ToDouble(dt.Rows[0]["Costo"]);
                    int tieneDescuento = Convert.ToInt32(dt.Rows[0]["Descuento"]);

                    // Guardamos el precio real
                    ViewState["PrecioReal"] = costoFinal;

                    if (tieneDescuento >= 1)
                    {
                        // HAY OFERTA
                        lblPrecio.Text = "$" + costoFinal.ToString("N2");
                        lblPrecioAnterior.Text = "$" + costoOriginal.ToString("N2");
                        lblPrecioAnterior.Visible = true;

                        // Estilos forzados para el tachado
                        lblPrecioAnterior.Style.Add("text-decoration", "line-through");
                        lblPrecioAnterior.Style.Add("color", "#999");
                    }
                    else
                    {
                        // NO HAY OFERTA
                        lblPrecio.Text = "$" + costoOriginal.ToString("N2");
                        lblPrecioAnterior.Visible = false;
                    }

                    // Imágenes
                    string img = dt.Rows[0]["Imagen"].ToString();
                    string rutaFinal = img.StartsWith("..") ? img : "../" + img;

                    imgProducto1.ImageUrl = rutaFinal;
                    imgProducto2.ImageUrl = rutaFinal;
                    imgProducto3.ImageUrl = rutaFinal;

                    // Habilitar botón por si estaba deshabilitado
                    btnAgregarCarrito.Enabled = true;
                }
                catch (Exception ex)
                {
                    // Error de lectura de columnas (por si cambia el SP en el futuro)
                    Response.Write("<script>alert('Error al leer datos del producto...'); window.location='frmProductos.aspx';</script>");
                }
            }
            else
            {
                // DataTable vacío (Raro con tu SP actual, pero por seguridad)
                Response.Write("<script>alert('Producto no encontrado...'); window.location='frmProductos.aspx';</script>");
            }
        }

        // --- NUEVO: EVENTO PARA EL BOTÓN "A MI BOLSA" ---
        protected void btnAgregarCarrito_Click(object sender, EventArgs e)
        {
            // 1. Validar sesión
            if (Session["cveUsuario"] == null)
            {
                Response.Redirect("../frmIniciarSesion.aspx");
                return;
            }

            try
            {
                int idCliente = int.Parse(Session["cveUsuario"].ToString());
                int idProducto = int.Parse(Request.QueryString["clave"].ToString());
                string cadenaConexion = Application["cnnVentas"].ToString();

                // 2. Obtener cantidad
                int cantidad;
                if (!int.TryParse(txtCantidad.Text, out cantidad) || cantidad < 1) cantidad = 1;

                // 4. GESTIÓN DE VENTA
                string idVentaActual = "0";

                // Verificamos si hay sesión Y si el valor es válido (distinto de "0")
                if (Session["venActual"] != null && Session["venActual"].ToString() != "0")
                {
                    idVentaActual = Session["venActual"].ToString();
                }
                else
                {
                    // Si es nulo O es "0", creamos una nueva venta
                    idVentaActual = objCarrito.insertarVenta(cadenaConexion, idCliente);
                    Session["venActual"] = idVentaActual; // Actualizamos la sesión con el nuevo ID real
                }

                // 5. Insertar Detalle
                if (idVentaActual != "0" && !string.IsNullOrEmpty(idVentaActual))
                {
                    int idVenta = int.Parse(idVentaActual);

                    if (objCarrito.insertarDetalleVenta(cadenaConexion, idVenta, idProducto, cantidad) != "1")
                    {
                        ClientScript.RegisterStartupScript(GetType(), "stock", "alert(\'No se pudo agregar el producto. Verifica el inventario.\');", true);
                        return;
                    }

                    Response.Write("<script>alert('¡El producto ha sido agregado a tu bolsa!'); window.location='frmCliCarrito.aspx';</script>");
                }
                else
                {
                    // Si llega aquí es porque la BD falló al crear la venta inicial
                    Response.Write("<script>alert('Error crítico: No se pudo generar el folio de venta. Contacte al soporte.');</script>");
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Ocurrió un error: " + "No se pudo completar la operación." + "');</script>");
            }
        }
    }
}