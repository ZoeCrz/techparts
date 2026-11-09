<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="frmAdmRepoIndividual.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.WebForm4" %>
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
        /* Botón Ver Reporte */
        .btn-reporte {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
            color: #fff;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(255, 186, 0, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-reporte:hover {
            background: linear-gradient(135deg, var(--primary-hover) 0%, #cc8f00 100%);
            box-shadow: 0 4px 12px rgba(255, 186, 0, 0.4);
            transform: translateY(-2px);
            text-decoration: none;
            color: #fff;
        }
        /* Foto de perfil en tabla */
        .gv-container .table td img[src*="FotosUsuarios"],
        .gv-container .table td img[src*="default-avatar"] {
            border-radius: 8px;
            border: 2px solid var(--border-color);
            object-fit: cover;
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
        .badge-activo {
            background: #d4edda;
            color: #155724;
        }
        .badge-inactivo {
            background: #f8d7da;
            color: #721c24;
        }
        /* Columnas específicas */
        .col-acciones { width: 160px; text-align: center; }
        .col-clave { width: 80px; text-align: center; }
        .col-foto { width: 120px; text-align: center; }
        .col-usuario { width: 180px; text-align: center; }
        .col-rol { width: 150px; text-align: center; }
        .col-estatus { width: 120px; text-align: center; }
        /* Responsive */
        @media (max-width: 768px) {
            .gv-header {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
            .gv-card {
                padding: 20px;
            }
            .btn-reporte {
                width: 100%;
                justify-content: center;
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
                    <h1>Reportes por usuario</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmAdmRepoIndividual.aspx">Reportes por usuario</a>
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
                        <!-- Header con título -->
                        <div class="gv-header">
                            <h3>Selecciona un usuario para ver su reporte de ventas</h3>
                        </div>
                        <!-- Tabla GridView -->
                        <div class="table-responsive">
                            <asp:GridView ID="gvUsuarios" runat="server" 
                                CssClass="table"
                                AllowPaging="True" 
                                AutoGenerateColumns="False" 
                                PageSize="8" 
                                OnPageIndexChanging="gvUsuarios_PageIndexChanging"
                                OnRowDataBound="gvUsuarios_RowDataBound"
                                GridLines="None">
                                <Columns>
                                    <asp:TemplateField HeaderText="Ver Reporte">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnVerReporte" runat="server" 
                                                CssClass="btn-reporte"
                                                CommandName="VerReporte"
                                                CommandArgument='<%# Eval("Clave") %>'>
                                                <i class="fa "></i> Ver Reporte
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="col-acciones" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Clave" HeaderText="ID">
                                        <ItemStyle CssClass="col-clave" Font-Bold="true" />
                                    </asp:BoundField>
                                    <asp:ImageField DataImageUrlField="Foto" HeaderText="Foto">
                                        <ControlStyle Width="80px" Height="80px" />
                                        <ItemStyle CssClass="col-foto" />
                                    </asp:ImageField>
                                    <asp:BoundField DataField="Usuario" HeaderText="Usuario">
                                        <ItemStyle CssClass="col-usuario" Font-Bold="true" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Rol" HeaderText="Rol">
                                        <ItemStyle CssClass="col-rol" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Estatus">
                                        <ItemTemplate>
                                            <span class='<%# Eval("Estatus").ToString() == "ACTIVO" ? "badge-status badge-activo" : "badge-status badge-inactivo" %>'>
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
