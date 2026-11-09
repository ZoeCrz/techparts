<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="frmAdmGestProductos.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.Formulario_web14" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Variables de color */
        :root {
            --primary-color: #ffba00;
            --primary-hover: #e5a800;
            --border-color: #e0e0e0;
            --row-hover: #fff9e6;
        }
        /* Contenedor principal */
        .gv-wrapper { 
            padding: 40px 0; 
            background: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        /* Card contenedor */
        .gv-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 30px;
        }
        /* Header de la sección */
        .gv-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--primary-color);
        }
        .gv-header h3 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
            color: #333;
        }
        /* Botón agregar producto */
        .btn-add-product {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
            color: #fff;
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(255, 186, 0, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-add-product:hover {
            background: linear-gradient(135deg, var(--primary-hover) 0%, #cc8f00 100%);
            box-shadow: 0 6px 16px rgba(255, 186, 0, 0.4);
            transform: translateY(-2px);
        }
        .btn-add-product i {
            font-size: 16px;
        }
        /* Tabla principal */
        .gv-container .table {
            margin-bottom: 0;
            background: #fff;
            border: none;
            border-collapse: separate;
            border-spacing: 0;
        }
        /* Header de tabla */
        .gv-container .table thead th {
            background: var(--primary-color) !important;
            color: #fff;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
            padding: 15px 12px;
            border: none;
            vertical-align: middle;
            white-space: nowrap;
        }
        .gv-container .table thead th:first-child {
            border-top-left-radius: 8px;
        }
        .gv-container .table thead th:last-child {
            border-top-right-radius: 8px;
        }
        /* Celdas de tabla */
        .gv-container .table td {
            padding: 16px 12px;
            vertical-align: middle;
            font-size: 14px;
            color: #333;
            border-bottom: 1px solid #f0f0f0;
            border-left: none;
            border-right: none;
        }
        /* Filas alternadas */
        .gv-container .table tbody tr:nth-of-type(odd) { 
            background-color: #fff; 
        }
        .gv-container .table tbody tr:nth-of-type(even) { 
            background-color: #fafafa; 
        }
        /* Hover sobre filas */
        .gv-container .table tbody tr:hover {
            background-color: var(--row-hover) !important;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        /* Última fila sin borde */
        .gv-container .table tbody tr:last-child td {
            border-bottom: none;
        }
        /* Imágenes de acción */
        .btn-action {
            width: 28px;
            height: 28px;
            object-fit: contain;
            opacity: 0.7;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .btn-action:hover {
            opacity: 1;
            transform: scale(1.15);
        }
        /* Imagen de producto en tabla */
        .gv-container .table td img[src*="FotosProductos"],
        .gv-container .table td img[src*="default-product"] {
            border-radius: 8px;
            border: 2px solid var(--border-color);
            object-fit: contain;
            max-width: 100%;
            max-height: 80px;
        }
        /* Paginación personalizada */
        .gv-container .table + table {
            margin-top: 20px;
            width: 100%;
        }
        .gv-container .table + table td {
            padding: 15px;
            text-align: center;
            background: #fff;
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }
        .gv-container .table + table a,
        .gv-container .table + table span {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 3px;
            border-radius: 5px;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .gv-container .table + table a {
            background: #f5f5f5;
            color: #333;
            text-decoration: none;
        }
        .gv-container .table + table a:hover {
            background: var(--primary-color);
            color: #fff;
        }
        .gv-container .table + table span {
            background: var(--primary-color);
            color: #fff;
        }
        /* Badge de estatus */
        .badge-status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .badge-disponible {
            background: #d4edda;
            color: #155724;
        }
        .badge-agotado {
            background: #f8d7da;
            color: #721c24;
        }
        .badge-descontinuado {
            background: #fff3cd;
            color: #856404;
        }
        .badge-activo {
            background: #d4edda;
            color: #155724;
            font-weight: 600;
        }
        .badge-inactivo {
            background: #f8d7da;
            color: #721c24;
            font-weight: 600;
        }
        /* Columnas específicas */
        .col-acciones { width: 140px; text-align: center; }
        .col-id { width: 80px; text-align: center; }
        .col-imagen { width: 120px; text-align: center; }
        .col-nombre { width: 250px; }
        .col-categoria { width: 150px; text-align: center; }
        .col-precio { width: 120px; text-align: right; font-weight: bold; }
        .col-stock { width: 100px; text-align: center; }
        .col-estatus { width: 120px; text-align: center; }
        /* Responsive */
        @media (max-width: 768px) {
            .gv-header {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
            .btn-add-product {
                width: 100%;
                justify-content: center;
            }
            .gv-card {
                padding: 20px;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <!-- Start Banner Area -->
    <section class="banner-area organic-breadcrumb">
	    <div class="container">
		    <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
			    <div class="col-first">
				    <h1>Gestión de productos</h1>
				    <nav class="d-flex align-items-center">
					    <a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
					    <a href="frmAdmGestProductos.aspx">Gestión de productos</a>
				    </nav>
			    </div>
		    </div>
	    </div>
    </section>
    <!-- End Banner Area -->


    <!-- Wrapper with proper spacing -->
    <div class="gv-wrapper">
        <div class="container gv-container">
            <div class="row justify-content-center">
                <div class="col-12">
                    <div class="gv-card">
                        <!-- Header con título y botón -->
                        <div class="gv-header">
                            <h3>Productos en venta</h3>
                            <div style="display:flex; gap:10px;">
                                <asp:Button ID="btnOfertas" runat="server" 
                                    Text="Crear/Actualizar Oferta" 
                                    CssClass="btn-add-product" 
                                    PostBackUrl="frmAdmGestOfertas.aspx" />

                                <asp:Button ID="btnAgregarProducto" runat="server" 
                                    Text="Agregar nuevo producto" 
                                    CssClass="btn-add-product" 
                                    OnClick="btnAgregarProducto_Click" />
                            </div>
                        </div>
                        <!-- Tabla GridView -->
                        <div class="table-responsive">
                            <asp:GridView ID="gvProductos" runat="server" 
                                CssClass="table"
                                AllowPaging="True" 
                                AutoGenerateColumns="False" 
                                PageSize="8" 
                                OnPageIndexChanging="gvProductos_PageIndexChanging"
                                OnSelectedIndexChanged="gvProductos_SelectedIndexChanged"
                                OnRowDeleting="gvProductos_RowDeleting"
                                OnRowDataBound="gvProductos_RowDataBound"
                                OnRowDeleted="gvProductos_RowDeleted" 
                                OnRowEditing="gvProductos_RowEditing" 
                                OnSelectedIndexChanging="gvProductos_SelectedIndexChanging"
                                GridLines="None">
                                <Columns>
                                    <asp:TemplateField HeaderText="Ver Detalles">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="btnVerDetalle" runat="server" 
                                                ImageUrl="../FOTOS/seleccionar.png" 
                                                CommandName="Select"
                                                CssClass="btn-action" 
                                                ToolTip="Ver detalles del producto" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="col-acciones" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Eliminar">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="btnEliminar" runat="server" 
                                                ImageUrl="../FOTOS/eliminar.png" 
                                                CommandName="Delete"
                                                CssClass="btn-action" 
                                                ToolTip="Marcar como inactivo"
                                                OnClientClick="return confirm('¿Desea marcar este producto como inactivo?');" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="col-acciones" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Clave" HeaderText="ID">
                                        <ItemStyle CssClass="col-id" Font-Bold="true" />
                                    </asp:BoundField>
                                    <asp:ImageField DataImageUrlField="Imagen" HeaderText="Imagen">
                                        <ControlStyle Width="80px" Height="80px" />
                                        <ItemStyle CssClass="col-imagen" />
                                    </asp:ImageField>
                                    <asp:BoundField DataField="Productos" HeaderText="Nombre del Producto">
                                        <ItemStyle CssClass="col-nombre" Font-Bold="true" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Categoria" HeaderText="Categoría">
                                        <ItemStyle CssClass="col-categoria" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Costo Base">
                                        <ItemTemplate>
                                            <span style='<%# Eval("Descuento").ToString() == "1" ? "text-decoration:line-through; color:red;" : "" %>'>
                                                <%# Eval("Costo", "{0:C}") %>
                                            </span>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="col-precio" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Costo Final">
                                        <ItemTemplate>
                                            <span style="font-weight:bold; color:green;">
                                                <%# Eval("CostoFinal", "{0:C}") %>
                                            </span>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="col-precio" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Existencias" HeaderText="Stock">
                                        <ItemStyle CssClass="col-stock" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Estatus">
                                        <ItemTemplate>
                                            <span class='<%# Eval("Estatus").ToString().Trim() == "ACTIVO" ? "badge-status badge-activo" : "badge-status badge-inactivo" %>'>
                                                <%# Eval("Estatus") %>
                                            </span>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="col-estatus" />
                                    </asp:TemplateField>
                                </Columns>
                                <PagerStyle HorizontalAlign="Center" CssClass="pagination-custom" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


</asp:Content>