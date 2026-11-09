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
    public partial class Formulario_web13 : System.Web.UI.Page
    {
        clsCarrito objCarrito = new clsCarrito();
        clsUsuario objUsuario = new clsUsuario();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCarrito();
                // VALIDAR SESIÓN DE USUARIO
                if (Session["cveUsuario"] != null)
                {
                    int idUser = int.Parse(Session["cveUsuario"].ToString());
                    string conexion = Application["cnnVentas"].ToString();
                    // Llamamos al método nuevo que lee spBuscarUsuario
                    string direccionCompleta = objUsuario.obtenerDireccionCliente(conexion, idUser);
                    // Asignamos al Label
                    lblDireccionCliente.Text = direccionCompleta;
                }
                else
                {
                    lblDireccionCliente.Text = "Inicia sesión para usar tu dirección...";
                }
            }
        }
        void CargarCarrito()
        {
            if (Session["venActual"] != null && int.Parse(Session["venActual"].ToString()) != 0)
            {
                int idVenta = int.Parse(Session["venActual"].ToString());
                lblVenta.Text = "Compra #" + idVenta;

                // 1. Obtener items
                DataSet ds = objCarrito.listarDetalleVenta(Application["cnnVentas"].ToString(), idVenta);

                if (ds != null && ds.Tables["VentaActual"].Rows.Count > 0)
                {
                    DataTable dt = ds.Tables["VentaActual"];
                    gvCarrito.DataSource = dt;
                    gvCarrito.DataBind();

                    // 2. Calcular Totales
                    decimal subtotal = 0m;
                    foreach (DataRow row in dt.Rows)
                    {
                        subtotal += Convert.ToDecimal(row["TotalxUnidades"]);
                    }

                    decimal iva = Math.Round(subtotal * 0.16m, 2, MidpointRounding.AwayFromZero);
                    decimal total = subtotal + iva;

                    lblSubtotal.Text = subtotal.ToString("C");
                    lblIVA.Text = iva.ToString("C");
                    lblTotal.Text = total.ToString("C");

                    // Como SÍ hay productos, mostramos las opciones de pago y dirección
                    pnlOpcionesCompra.Visible = true;
                }
                else
                {
                    // Carrito vacío visualmente
                    gvCarrito.DataSource = null;
                    gvCarrito.DataBind();
                    lblSubtotal.Text = "$0.00"; lblIVA.Text = "$0.00"; lblTotal.Text = "$0.00";

                    // Como NO hay productos, ocultamos todo el panel inferior
                    pnlOpcionesCompra.Visible = false;
                }
            }
            else
            {
                lblVenta.Text = "Tu bolsa está vacía";
                gvCarrito.DataSource = null;
                gvCarrito.DataBind();

                // Ocultamos panel
                pnlOpcionesCompra.Visible = false;
            }
        }

        // Evento para cargar el DropdownList en cada fila
        protected void gvCarrito_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Encontrar controles
                DropDownList ddl = (DropDownList)e.Row.FindControl("ddlCantidad");
                HiddenField hfCant = (HiddenField)e.Row.FindControl("hfCantidadActual");

                if (ddl != null && hfCant != null)
                {
                    // Llenar el dropdown del 1 al 10 (o al stock disponible si quisieras validar más)
                    for (int i = 1; i <= 10; i++)
                    {
                        ddl.Items.Add(new ListItem(i.ToString(), i.ToString()));
                    }

                    // Seleccionar la cantidad actual que viene de la BD
                    ddl.SelectedValue = hfCant.Value;
                }
            }
        }

        // Evento al cambiar cantidad (Input Numérico)
        protected void txtCantidad_TextChanged(object sender, EventArgs e)
        {
            // 1. Identificar el control que disparó el evento
            TextBox txt = (TextBox)sender;
            GridViewRow row = (GridViewRow)txt.NamingContainer;

            // 2. Obtener datos de los HiddenFields
            int idVenta = int.Parse(Session["venActual"].ToString());
            int idProd = int.Parse(((HiddenField)row.FindControl("hfCveProducto")).Value);

            // 3. Obtener la nueva cantidad escrita
            // Usamos int.TryParse para evitar errores si el usuario deja el campo vacío
            int nuevaCant;
            if (!int.TryParse(txt.Text, out nuevaCant) || nuevaCant < 1)
            {
                nuevaCant = 1; // Si escriben 0 o nada, forzamos a 1
            }

            // 4. Actualizar en BD
            string cadenaConexion = Application["cnnVentas"].ToString(); // O tu variable de conexión
            objCarrito.actualizarCantidadCarrito(cadenaConexion, idVenta, idProd, nuevaCant);

            // 5. Recargar carrito para ver nuevos totales
            CargarCarrito();
        }

        // Evento para eliminar producto (Botón de la primera columna)
        protected void gvCarrito_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EliminarProducto")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                int idProducto = int.Parse(args[0]);
                int idVenta = int.Parse(Session["venActual"].ToString());

                // Llamar a tu método de eliminar
                objCarrito.eliminarProductoDetalleVenta(Application["cnnVentas"].ToString(), idVenta, idProducto);

                CargarCarrito();
            }
        }

        // Confirmar Compra
        protected void btnConfirmar_Click(object sender, EventArgs e)
        {
            // VALIDACIÓN: Verificar si el carrito está vacío
            if (gvCarrito.Rows.Count == 0)
            {
                Response.Write("<script>alert('No puedes confirmar una compra vacía. Agrega productos primero...');</script>");
                return;
            }

            if (Session["venActual"] != null)
            {
                int idVenta = int.Parse(Session["venActual"].ToString());
                string cadenaConexion = Application["cnnVentas"].ToString();

                // 1. CAPTURAR DATOS DE ENVÍO Y PAGO
                string direccionEnvio = "";
                string metodoPago = ddlMetodoPago.SelectedValue;

                if (rbMiDireccion.Checked)
                    direccionEnvio = lblDireccionCliente.Text;
                else if (rbSucursal1.Checked)
                    direccionEnvio = "Ex Hacienda San Javier, Tolcayuca 1009, 43860 Tolcayuca, Hgo.";
                else if (rbSucursal2.Checked)
                    direccionEnvio = "Camino Real de La Plata 102, Zona Plateada, 42083 Pachuca de Soto, Hgo.";

                // 3. CONFIRMAR VENTA (Todo en un solo paso)
                string resultado = objCarrito.confirmarVenta(cadenaConexion, idVenta, direccionEnvio, metodoPago);

                if (resultado == "1")
                {
                    Session["venActual"] = null; // Limpiar sesión
                    Response.Write("<script>alert('¡Compra confirmada con éxito! Se enviará a: " + System.Web.HttpUtility.JavaScriptStringEncode(direccionEnvio) + "'); window.location='frmCliCompras.aspx';</script>");
                }
                else
                {
                    Response.Write("<script>alert('Error: El carrito está vacío o la venta no es válida...');</script>");
                }
            }
        }

        // Cancelar Compra
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            if (Session["venActual"] != null)
            {
                int idVenta = int.Parse(Session["venActual"].ToString());
                objCarrito.cancelarVenta(Application["cnnVentas"].ToString(), idVenta);
                Session["venActual"] = null;
                Response.Write("<script language = 'javascript'>alert('La compra ha sido cancelada...');document.location.href='frmCliCompras.aspx';</script>");
            }
        }
    }
}