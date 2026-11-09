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
    public partial class WebForm5 : System.Web.UI.Page
    {
        clsCarrito objCarrito = new clsCarrito();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
                Response.Cache.SetNoStore();
                lblFechaActualizacion.Text = DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss");
                CargarVentasPorDia();
            }
        }
        private void CargarVentasPorDia()
        {
            try
            {
                string conexion = Application["cnnVentas"].ToString();
                DataSet dsVentas = objCarrito.listarVentasPorDia(conexion);
                DataTable dtVentasPorDia = new DataTable();
                dtVentasPorDia.Columns.Add("Fecha", typeof(DateTime));
                dtVentasPorDia.Columns.Add("CantidadVentas", typeof(int));
                dtVentasPorDia.Columns.Add("VentasConfirmadas", typeof(int));
                dtVentasPorDia.Columns.Add("VentasPendientes", typeof(int));
                dtVentasPorDia.Columns.Add("VentasCanceladas", typeof(int));
                dtVentasPorDia.Columns.Add("TotalDia", typeof(double));

                if (dsVentas != null && dsVentas.Tables.Count > 0)
                {
                    DataTable dtVentas = dsVentas.Tables[0];

                    if (dtVentas != null && dtVentas.Rows.Count > 0)
                    {
                        foreach (DataRow row in dtVentas.Rows)
                        {
                            DataRow newRow = dtVentasPorDia.NewRow();
                            newRow["Fecha"] = Convert.ToDateTime(row["Fecha"]);
                            newRow["CantidadVentas"] = Convert.ToInt32(row["CantidadVentas"]);
                            newRow["VentasConfirmadas"] = Convert.ToInt32(row["VentasConfirmadas"]);
                            newRow["VentasPendientes"] = Convert.ToInt32(row["VentasPendientes"]);
                            newRow["VentasCanceladas"] = Convert.ToInt32(row["VentasCanceladas"]);
                            newRow["TotalDia"] = Convert.ToDouble(row["TotalDia"]);
                            dtVentasPorDia.Rows.Add(newRow);
                        }
                    }
                }
                gvVentasPorDia.DataSource = dtVentasPorDia;
                gvVentasPorDia.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en CargarVentasPorDia: " + "No se pudo completar la operación." + " - " + ex.StackTrace);
            }
        }
    }
}