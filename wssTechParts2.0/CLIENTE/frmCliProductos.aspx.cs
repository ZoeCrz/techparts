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
    public partial class Formulario_web15 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        clsCarrito objCarrito = new clsCarrito();
        DataTable dt;
        // Variables para la paginación
        private static int pageSize = 6; // productos por página

        // Propiedades para mantener el estado de la página y filtros
        public int CurrentPage
        {
            get { return ViewState["PageNum"] != null ? (int)ViewState["PageNum"] : 1; }
            set { ViewState["PageNum"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Inicializamos filtros en 0 (sin filtro)
                ViewState["FiltroCat"] = "0";
                ViewState["FiltroMar"] = "0";

                cargarMarcas();
                cargarCategorias();
                CargarProductos();
            }
        }
        void CargarProductos()
        {
            dt = new DataTable();
            dt = objProducto.listarProductos(Application["cnnVentas"].ToString());

            if (dt.Rows.Count > 0)
            {
                // 2. APLICAMOS FILTROS USANDO LINQ
                var query = dt.AsEnumerable();

                // Filtrar por Categoría
                if (ViewState["FiltroCat"] != null && ViewState["FiltroCat"].ToString() != "0")
                {
                    int catId = int.Parse(ViewState["FiltroCat"].ToString());
                    // Asegúrate que tu SP devuelva la columna 'CatId' (o el nombre que tenga la FK)
                    query = query.Where(r => r.Field<int>("CatId") == catId);
                }

                // Filtrar por Marca
                if (ViewState["FiltroMar"] != null && ViewState["FiltroMar"].ToString() != "0")
                {
                    int marId = int.Parse(ViewState["FiltroMar"].ToString());
                    // Asegúrate que tu SP devuelva la columna 'MarId'
                    query = query.Where(r => r.Field<int>("MarId") == marId);
                }

                // 3. CREAMOS LA TABLA FINAL FILTRADA
                DataTable dtFiltrada;
                if (query.Any())
                    dtFiltrada = query.CopyToDataTable();
                else
                    dtFiltrada = new DataTable(); // Vacía

                // 4. PAGINACIÓN (Sobre los resultados filtrados)
                if (dtFiltrada.Rows.Count > 0)
                {
                    int totalProductos = dtFiltrada.Rows.Count;
                    int totalPaginas = (int)Math.Ceiling((double)totalProductos / pageSize);

                    if (CurrentPage > totalPaginas) CurrentPage = 1;

                    var productosPagina = dtFiltrada.AsEnumerable()
                        .Skip((CurrentPage - 1) * pageSize)
                        .Take(pageSize);

                    if (productosPagina.Any())
                    {
                        rptProductos.DataSource = productosPagina.CopyToDataTable();
                        rptProductos.DataBind();
                        lblPageInfo.Text = $"Página {CurrentPage} de {totalPaginas} ({totalProductos} prod)";

                        lnkPrev.Enabled = CurrentPage > 1;
                        lnkNext.Enabled = CurrentPage < totalPaginas;
                    }
                }
                else
                {
                    // No hay productos con esos filtros
                    rptProductos.DataSource = null;
                    rptProductos.DataBind();
                    lblPageInfo.Text = "No se encontraron productos";
                    lnkPrev.Enabled = false;
                    lnkNext.Enabled = false;
                }
            }
            else
            {
                rptProductos.DataSource = null;
                rptProductos.DataBind();
                lblPageInfo.Text = "No hay productos disponibles.";
            }
        }
        void cargarCategorias()
        {
            string conexion = Application["cnnVentas"].ToString();
            DataTable dtCategorias = new DataTable();
            dtCategorias = objProducto.listarCategorias(conexion);
            rptCategorias.DataSource = dtCategorias;
            rptCategorias.DataBind();
        }
        void cargarMarcas()
        {
            string conexion = Application["cnnVentas"].ToString();
            DataTable dtCategorias = new DataTable();

            dtCategorias = objProducto.listarMarcas(conexion);

            rptMarcas.DataSource = dtCategorias;
            rptMarcas.DataBind();
        }

        // --- EVENTOS DE CLICK EN FILTROS ---
        protected void lnkFiltroCat_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            ViewState["FiltroCat"] = btn.CommandArgument; // Guardamos el ID seleccionado
            ViewState["FiltroMar"] = "0"; // Reiniciamos marca (opcional)
            CurrentPage = 1;

            CargarProductos(); // Recarga la lista de productos

            // Recargamos el menú lateral para que se aplique el color naranja a la nueva selección
            cargarCategorias();
        }
        protected void lnkFiltroMarca_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            ViewState["FiltroMar"] = btn.CommandArgument; // Guardamos ID Marca
            CurrentPage = 1;

            CargarProductos();

            // Recargamos las marcas para que el radio button se pinte de naranja (checked)
            cargarMarcas();
        }
        protected void lnkVerTodo_Click(object sender, EventArgs e)
        {
            ViewState["FiltroCat"] = "0";
            ViewState["FiltroMar"] = "0";
            CurrentPage = 1;
            CargarProductos();
            cargarMarcas();

            // Recargamos para que "Ver todo" se ponga naranja y las demás gris
            cargarCategorias();
        }

        // --- PAGINACIÓN ---
        protected void lnkPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                CargarProductos();
            }
        }
        protected void lnkNext_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            CargarProductos();
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            pageSize = int.Parse(ddlPageSize.SelectedValue);
            CurrentPage = 1;
            CargarProductos();
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