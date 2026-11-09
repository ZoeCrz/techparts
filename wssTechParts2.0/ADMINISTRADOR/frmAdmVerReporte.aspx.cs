using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using wssCarritoCompras;

namespace wssTechParts2._0.ADMINISTRADOR
{
    public partial class frmAdmVerReporte : System.Web.UI.Page
    {
        clsCarrito objCarrito = new clsCarrito();
        DataSet ds;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Evitar caché para alertas y contenido actualizado
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
                Response.Cache.SetNoStore();

                CargarClaveUsuarioYVentas();
            }
        }
        private void CargarClaveUsuarioYVentas()
        {
            if (Request.QueryString["claveUsuario"] != null)
            {
                int claveUsuario;
                if (int.TryParse(Request.QueryString["claveUsuario"], out claveUsuario))
                {
                    Session["claveUsuarioReporte"] = claveUsuario;
                    CargarVentasUsuario(claveUsuario);
                }
                else
                {
                    Response.Redirect("frmAdmRepoIndividual.aspx");
                }
            }
            else if (Session["claveUsuarioReporte"] != null)
            {
                int claveUsuario = int.Parse(Session["claveUsuarioReporte"].ToString());
                CargarVentasUsuario(claveUsuario);
            }
            else
            {
                Response.Redirect("frmAdmRepoIndividual.aspx");
            }
        }

        void CargarVentasUsuario(int claveUsuario)
        {
            string id = "";
            ds = new DataSet();
            ds = objCarrito.listarVentasCliente(Application["cnnVentas"].ToString(), claveUsuario);

            if (ds != null && ds.Tables.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    id = dr["ClaveCompra"].ToString();
                    break;
                }

                if (id != "0" && id != "")
                {
                    gvVentas.DataSource = ds;
                    gvVentas.DataMember = "VentasRealizadas";
                    gvVentas.DataBind();
                    lblVenta.Text = "Historial de ventas del usuario";
                }
                else
                {
                    lblVenta.Text = "Este usuario no ha realizado ninguna venta";
                    gvVentas.DataSource = null;
                    gvVentas.DataBind();
                    LimpiarProductos();
                }
            }
            else
            {
                lblVenta.Text = "Este usuario no ha realizado ninguna venta";
                gvVentas.DataSource = null;
                gvVentas.DataBind();
                LimpiarProductos();
            }
        }
        protected void gvVentas_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvVentas.PageIndex = e.NewPageIndex;
            int claveUsuario = int.Parse(Session["claveUsuarioReporte"].ToString());
            CargarVentasUsuario(claveUsuario);
            LimpiarProductos();
        }
        protected void gvVentas_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            int index = e.NewSelectedIndex;
            string claveCompra = gvVentas.DataKeys[index].Values["ClaveCompra"].ToString();
            string estatusCompra = gvVentas.DataKeys[index].Values["Estatus"].ToString();

            Session["selCompra"] = claveCompra;

            if (estatusCompra == "CONFIRMADA")
            {
                CargarProductosVenta(int.Parse(claveCompra));
            }
            else if (estatusCompra == "CANCELADA")
            {
                LimpiarProductos();
                Response.Write("<script>alert('La venta ha sido cancelada y no contiene detalles disponibles...'); window.location='frmAdmVerReporte.aspx';</script>");
            }
            else
            {
                LimpiarProductos();
                Response.Write("<script>alert('La venta no ha sido confirmada aún, por lo tanto no puedes ver el detalle de la misma...'); window.location='frmAdmVerReporte.aspx';</script>");
            }
        }

        protected void gvVentas_RowClick(object sender, GridViewSelectEventArgs e)
        {
            int index = e.NewSelectedIndex;
            string claveCompra = gvVentas.DataKeys[index].Values["ClaveCompra"].ToString();
            string estatusCompra = gvVentas.DataKeys[index].Values["Estatus"].ToString();

            if (estatusCompra == "CONFIRMADA")
            {
                CargarProductosVenta(int.Parse(claveCompra));
            }
            else
            {
                LimpiarProductos();
            }
        }

        private void CargarProductosVenta(int idCompra)
        {
            DataSet dsProductos = objCarrito.listarDetalleVenta(Application["cnnVentas"].ToString(), idCompra);

            if (dsProductos != null && dsProductos.Tables["VentaActual"].Rows.Count > 0)
            {
                DataTable dt = dsProductos.Tables["VentaActual"];
                gvProductosVenta.DataSource = dt;
                gvProductosVenta.DataBind();

                double subtotal = 0;
                foreach (DataRow row in dt.Rows)
                {
                    subtotal += Convert.ToDouble(row["TotalxUnidades"]);
                }

                double iva = subtotal * 0.16;
                double total = subtotal + iva;

                lblSubtotalProd.Text = subtotal.ToString("C");
                lblIVAProd.Text = iva.ToString("C");
                lblTotalProd.Text = total.ToString("C");

                gvProductosVenta.Visible = true;
                lblProductosVacios.Visible = false;
            }
            else
            {
                LimpiarProductos();
            }
        }
        private void LimpiarProductos()
        {
            gvProductosVenta.DataSource = null;
            gvProductosVenta.DataBind();
            gvProductosVenta.Visible = false;
            lblProductosVacios.Visible = true;

            lblSubtotalProd.Text = "$0.00";
            lblIVAProd.Text = "$0.00";
            lblTotalProd.Text = "$0.00";
        }
        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("frmAdmRepoIndividual.aspx");
        }
    }
}
