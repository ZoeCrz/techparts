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
    public partial class Formulario_web18 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        clsCarrito objCarrito = new clsCarrito();
        protected void Page_Load(object sender, EventArgs e)
        {
            CargarPromociones();
        }
        private void CargarPromociones()
        {
            DataTable dt = objProducto.listarProductosDescuento(Application["cnnVentas"].ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                rptPromociones.DataSource = dt;
                rptPromociones.DataBind();

                pnlListaPromociones.Visible = true;
                pnlSinPromociones.Visible = false;
            }
            else
            {
                // NO HAY DATOS: Ocultamos la lista, mostramos el mensaje
                pnlListaPromociones.Visible = false;
                pnlSinPromociones.Visible = true;
            }
        }
        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string[] argumentos = btn.CommandArgument.ToString().Split('|');
            int idProducto = int.Parse(argumentos[0]);
            // El ID del cliente logueado está en Session["cveUsuario"]
            // LÓGICA DE SEGURIDAD
            string idVentaActual = "";
            if (Session["venActual"] != null)
            {
                idVentaActual = Session["venActual"].ToString();
            }
            // Si no hay sesión O el ID es inválido/cero, creamos una nueva venta
            if (string.IsNullOrEmpty(idVentaActual) || idVentaActual == "0")
            {
                // IMPORTANTE: Asegúrate de tener el ID del cliente logueado
                int idCliente = int.Parse(Session["cveUsuario"].ToString());

                idVentaActual = objCarrito.insertarVenta(Application["cnnVentas"].ToString(), idCliente);
                Session["venActual"] = idVentaActual; // Guardamos el nuevo ID válido
            }
            // Verificación final antes de insertar detalle
            if (idVentaActual != "0")
            {
                int idVenta = int.Parse(idVentaActual);
                // Ahora sí, insertar detalle es seguro porque idVenta existe en la BD
                if (objCarrito.insertarDetalleVenta(Application["cnnVentas"].ToString(), idVenta, idProducto, 1) != "1")
                {
                    ClientScript.RegisterStartupScript(GetType(), "stock", "alert(\'No se pudo agregar el producto. Verifica el inventario.\');", true);
                    return;
                }

                Response.Write("<script>alert('¡El producto ha sido agregado a tu bolsa!'); window.location='frmCliCarrito.aspx';</script>");
            }
            else
            {
                Response.Write("<script>alert('Error: No se pudo crear la venta. Intente iniciar sesión nuevamente...');</script>");
            }
        }
    }
}