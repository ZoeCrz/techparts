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
    public partial class Formulario_web12 : System.Web.UI.Page
    {
        clsCarrito objCarrito = new clsCarrito();
        // VARIABLE QUE RECIBE A LOS REGISTROS PARA MOSTRARLOS EN EL GRIDVIEW
        DataSet ds;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ventasRealizadas();
            }
        }
        // 1. Llenar ventas realizadas del cliente
        void ventasRealizadas()
        {
            string id = "";
            ds = new DataSet();
            ds = objCarrito.listarVentasCliente(Application["cnnVentas"].ToString(), int.Parse(Session["cveUsuario"].ToString()));
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                id = dr["ClaveCompra"].ToString();
                break;
            }
            if (id != "0" && id != "")
            {
                // Pasa los datos de la BD al gridview
                gvComprasAnteriores.DataSource = ds;
                // Usa el alias del método de la clase en la función fill
                gvComprasAnteriores.DataMember = "VentasRealizadas";
                // Permite que los datos sean visibles en dg
                gvComprasAnteriores.DataBind();
            }
            else
            {
                lblVenta.Text = "Por el momento no haz realizado ninguna compra";
                lblVenta.Visible = true;
            }
        }
        protected void gvComprasAnteriores_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // Se genera la nueva página de datos
            gvComprasAnteriores.PageIndex = e.NewPageIndex;
            // Se llena de registros la página
            ventasRealizadas();
        }
        protected void gvComprasAnteriores_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            // 1. Obtenemos el índice de la fila seleccionada
            int index = e.NewSelectedIndex;
            // 2. Recuperamos los datos usando DataKeys (Mucho más seguro que usar Cells[0].Text)
            // El DataKeyNames en el HTML nos permite hacer esto:
            string claveCompra = gvComprasAnteriores.DataKeys[index].Values["ClaveCompra"].ToString();
            string estatusCompra = gvComprasAnteriores.DataKeys[index].Values["Estatus"].ToString();
            // 3. Guardamos la clave en sesión
            Session["selCompra"] = claveCompra;
            // 4. Validamos el estatus con un IF/ELSE normal
            if (estatusCompra == "CONFIRMADA")
            {
                Response.Redirect("frmCliDetVenta.aspx");
            }
            else if (estatusCompra == "CANCELADA")
            {
                Response.Write("<script language = 'javascript'>alert('La venta no contiene productos, verifica su estatus...');document.location.href='frmCliCompras.aspx';</script>");
            }
            else
            {
                Response.Write("<script language = 'javascript'>alert('La venta no ha sido confirmada, por lo tanto no puedes ver el detalle de la misma...');document.location.href='frmCliCompras.aspx';</script>");
            }
        }
    }
}