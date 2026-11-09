using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wssTechParts2._0
{
    public partial class Formulario_web12 : System.Web.UI.Page
    {
        clsProducto objProducto = new clsProducto();
        DataTable dt;
        // Variables para la paginación
        private static int currentPage = 1;
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

            // Supongamos que tienes un método que devuelve las categorías
            // Cada categoría tendrá: IdCategoria, NombreCategoria, TotalProductos
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

            // --- ESTA ES LA SOLUCIÓN ---
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

            // --- ESTA ES LA SOLUCIÓN ---
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
            Response.Redirect("frmIniciarSesion.aspx");
        }
    }
}