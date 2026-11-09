<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="frmAdmVerReporte.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.frmAdmVerReporte" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- CONFIGURACIÓN DE COLORES Y FUENTES --- */
        :root {
            --primary-yellow: #ffba00;
            --primary-hover: #e6a800;
            --row-cream: #fffbf0;
            --text-dark: #333333;
            --text-grey: #6c757d;
            --border-light: #ececec;
        }
        .gv-wrapper {
            padding: 40px 0;
            background: #f8f9fa;
            font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        /* --- CONTENEDOR TIPO CARD --- */
        .gv-card {
            background: #fff;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 30px;
            margin-bottom: 30px;
        }
        /* --- HEADER CON LINEA AMARILLA --- */
        .gv-header {
            border-bottom: 2px solid var(--primary-yellow);
            padding-bottom: 15px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .gv-header h3 {
            margin: 0;
            font-size: 22px;
            font-weight: 700;
            color: var(--text-dark);
        }
        .btn-volver {
            background-color: #6c757d;
            color: #fff !important;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            cursor: pointer;
            box-shadow: 0 3px 6px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .btn-volver:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.3);
            color: #fff;
        }
        /* --- ESTILOS DE LA TABLA (GRIDVIEW) --- */
        .table-custom {
            width: 100%;
            border-collapse: collapse;
            border: none;
        }
        /* Encabezados de columna */
        .table-custom th {
            background-color: #fff;
            color: var(--text-grey);
            font-weight: 700;
            text-transform: capitalize;
            padding: 15px;
            border-bottom: 1px solid var(--border-light);
            text-align: center;
            font-size: 14px;
        }
        /* Filas normales */
        .table-custom tr {
            background-color: var(--row-cream);
            border-bottom: 1px solid transparent;
        }
        /* Filas alternas */
        .table-custom tr:nth-child(even) {
            background-color: #fff;
        }
        .table-custom td {
            padding: 20px 15px;
            vertical-align: middle;
            color: var(--text-dark);
            font-weight: 500;
            font-size: 15px;
            text-align: center;
            border-top: 1px solid #f0f0f0;
        }
        /* --- BOTÓN DE ACCIÓN --- */
        .btn-detalles {
            background-color: var(--primary-yellow);
            color: #fff !important;
            border: none;
            padding: 8px 20px;
            border-radius: 5px;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            cursor: pointer;
            box-shadow: 0 3px 6px rgba(255, 186, 0, 0.3);
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .btn-detalles:hover {
            background-color: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(255, 186, 0, 0.4);
            color: #fff;
        }
        /* --- BADGES DE ESTATUS --- */
        .badge-status {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-confirmada {
            background: #d4edda;
            color: #155724;
        }
        .badge-pendiente {
            background: #ffe38c;
            color: #856404;
        }
        .badge-cancelada {
            background: #f8d7da;
            color: #721c24;
        }
        /* Paginación */
        .pagination-custom td {
            padding: 10px;
            border: none;
            background: transparent !important;
        }
        .pagination-custom a, .pagination-custom span {
            padding: 5px 10px;
            border-radius: 3px;
            margin: 0 2px;
            text-decoration: none;
            font-weight: bold;
        }
        .pagination-custom span {
            background: var(--primary-yellow);
            color: white;
        }
        .pagination-custom a {
            background: #eee;
            color: #333;
        }
        /* --- LAYOUT DOS COLUMNAS --- */
        .reporte-container {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 30px;
            align-items: start;
        }
        .ventas-izquierda {
            grid-column: 1;
        }
        /* --- PANEL STICKY DERECHO --- */
        .productos-derecha {
            grid-column: 2;
            position: sticky;
            top: 120px;
            height: fit-content;
        }
        .productos-panel {
            background: #fff;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 20px;
            border-left: 4px solid var(--primary-yellow);
        }
        .productos-panel h4 {
            margin: 0 0 15px 0;
            font-size: 16px;
            font-weight: 700;
            color: var(--text-dark);
            border-bottom: 2px solid var(--primary-yellow);
            padding-bottom: 10px;
        }
        .productos-vacio {
            text-align: center;
            color: var(--text-grey);
            padding: 40px 20px;
            font-size: 14px;
        }
        .productos-vacio i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.3;
        }
        /* --- TABLA PRODUCTOS STICKY --- */
        .table-productos-sticky {
            width: 100%;
            border-collapse: collapse;
            border: none;
            font-size: 13px;
        }
        .table-productos-sticky th {
            background-color: #f8f9fa;
            color: var(--text-grey);
            font-weight: 700;
            padding: 10px 8px;
            border-bottom: 1px solid var(--border-light);
            text-align: left;
            font-size: 12px;
            text-transform: uppercase;
        }
        .table-productos-sticky tr {
            background-color: transparent;
            border-bottom: 1px solid var(--border-light);
        }
        .table-productos-sticky tr:last-child {
            border-bottom: none;
        }
        .table-productos-sticky td {
            padding: 10px 8px;
            vertical-align: middle;
            color: var(--text-dark);
        }
        .producto-nombre {
            font-weight: 600;
            word-break: break-word;
        }
        .producto-cantidad {
            color: #fff;
            padding: 3px 8px;
            border-radius: 12px;
            text-align: center;
            font-weight: 600;
        }
        /* Totales productos */
        .totales-productos {
            margin-top: 20px;
            padding-top: 15px;
            border-top: 2px solid var(--primary-yellow);
        }
        .total-item {
            display: flex;
            justify-content: space-between;
            margin: 8px 0;
            font-size: 13px;
        }
        .total-item.total-final {
            font-weight: 700;
            font-size: 15px;
            color: var(--primary-yellow);
            margin-top: 12px;
            padding-top: 10px;
            border-top: 1px solid var(--border-light);
        }
        .total-label {
            font-weight: 600;
        }
        .total-valor {
            text-align: right;
        }
        /* Scroll para tabla de productos */
        .productos-scroll {
            max-height: 400px;
            overflow-y: auto;
            overflow-x: hidden;
        }
        .productos-scroll::-webkit-scrollbar {
            width: 6px;
        }
        .productos-scroll::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        .productos-scroll::-webkit-scrollbar-thumb {
            background: var(--primary-yellow);
            border-radius: 10px;
        }
        .productos-scroll::-webkit-scrollbar-thumb:hover {
            background: var(--primary-hover);
        }
        /* Responsive */
        @media (max-width: 1200px) {
            .reporte-container {
                grid-template-columns: 1fr;
            }

            .productos-derecha {
                grid-column: 1;
                position: static;
            }
        }
        @media (max-width: 768px) {
            .gv-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            .btn-volver {
                width: 100%;
                text-align: center;
            }
            .reporte-container {
                grid-template-columns: 1fr;
                gap: 20px;
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
                    <h1>Ventas al usuario</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmAdmRepoIndividual.aspx">Reportes por usuario<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmAdmVerReporte.aspx">Detalle de ventas</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>
    <!-- End Banner Area -->

    <div class="gv-wrapper">
        <div class="container">
            <div class="reporte-container">
                <!-- COLUMNA IZQUIERDA: GRIDVIEW DE VENTAS -->
                <div class="ventas-izquierda">
                    <div class="gv-card">
                        <!-- Header con título y botón volver -->
                        <div class="gv-header">
                            <h3>
                                <asp:Label ID="lblVenta" runat="server" Text="Historial de Ventas"></asp:Label>
                            </h3>
                            <asp:Button ID="btnVolver" runat="server" 
                                Text=" Volver a Reportes" 
                                CssClass="btn-volver"
                                OnClick="btnVolver_Click" />
                        </div>
                        <!-- Tabla GridView -->
                        <div class="table-responsive">
                            <asp:GridView ID="gvVentas" runat="server"
                                DataKeyNames="ClaveCompra,Estatus"
                                CssClass="table-custom"
                                AllowPaging="True"
                                AutoGenerateColumns="False"
                                PageSize="8"
                                OnPageIndexChanging="gvVentas_PageIndexChanging"
                                OnSelectedIndexChanging="gvVentas_SelectedIndexChanging"
                                OnRowClick="gvVentas_RowClick"
                                GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="ClaveCompra" HeaderText="Clave de la venta">
                                        <ItemStyle Font-Bold="true" ForeColor="#333333" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="FechaCompra" HeaderText="Fecha" />
                                    <asp:BoundField DataField="Total" HeaderText="Total ($)" DataFormatString="{0:C}" />
                                    <asp:TemplateField HeaderText="Estatus">
                                        <ItemTemplate>
                                            <span class='<%# 
                                                Eval("Estatus").ToString() == "CONFIRMADA" ? "badge-status badge-confirmada" :
                                                Eval("Estatus").ToString() == "EN PROCESO" ? "badge-status badge-pendiente" : "badge-status badge-cancelada"
                                                %>'>
                                                <%# Eval("Estatus") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:CommandField
                                        ButtonType="Button"
                                        ShowSelectButton="True"
                                        SelectText="VER"
                                        ControlStyle-CssClass="btn-detalles" />
                                </Columns>
                                <PagerStyle HorizontalAlign="Center" CssClass="pagination-custom" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <!-- COLUMNA DERECHA: PANEL STICKY CON PRODUCTOS -->
                <div class="productos-derecha">
                    <div class="productos-panel">
                        <h4>Productos de la Venta</h4>
                        <div id="productosContainer" class="productos-scroll">
                            <div class="table-responsive">
                                <asp:GridView ID="gvProductosVenta" runat="server"
                                    AutoGenerateColumns="False"
                                    CssClass="table-productos-sticky"
                                    GridLines="None"
                                    ShowHeader="True">
                                    <Columns>
                                        <asp:BoundField DataField="Productos" HeaderText="Producto">
                                            <ItemStyle CssClass="producto-nombre" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="UnidadesCompradas" HeaderText="Cant.">
                                            <ItemStyle CssClass="producto-cantidad" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="PrecioUnidad" HeaderText="Precio" DataFormatString="{0:C}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <asp:Label ID="lblProductosVacios" runat="server" CssClass="productos-vacio" Visible="false">
                                <div class="productos-vacio">
                                    <i class="fa fa-inbox"></i><br/>
                                    Selecciona una venta para ver sus productos
                                </div>
                            </asp:Label>
                        </div>
                        <!-- Totales -->
                        <div class="totales-productos">
                            <div class="total-item">
                                <span class="total-label">Subtotal:</span>
                                <span class="total-valor"><asp:Label ID="lblSubtotalProd" runat="server" Text="$0.00"></asp:Label></span>
                            </div>
                            <div class="total-item">
                                <span class="total-label">IVA (16%):</span>
                                <span class="total-valor"><asp:Label ID="lblIVAProd" runat="server" Text="$0.00"></asp:Label></span>
                            </div>
                            <div class="total-item total-final">
                                <span class="total-label">Total:</span>
                                <span class="total-valor"><asp:Label ID="lblTotalProd" runat="server" Text="$0.00"></asp:Label></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


</asp:Content>