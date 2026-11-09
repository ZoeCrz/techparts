<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="frmAdmRepoMasVendidos.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.Formulario_web17" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- VARIABLES DE TEMA --- */
        :root {
            --primary-yellow: #ffba00;
            --primary-hover: #e6a800;
            --text-dark: #333333;
            --text-grey: #6c757d;
            --bg-light: #f8f9fa;
            --border-light: #ececec;
            --danger-color: #dc3545;
            --success-color: #28a745;
            --warning-color: #ffc107;
        }
        /* --- ESTRUCTURA PRINCIPAL --- */
        .repo-wrapper {
            padding: 50px 0;
            background: var(--bg-light);
            font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            min-height: 80vh;
        }
        /* TARJETA CONTENEDORA */
        .repo-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05); /* Sombra suave */
            padding: 35px;
            margin-bottom: 30px;
            border: 1px solid #f0f0f0;
        }
        /* ENCABEZADO DE LA TARJETA */
        .repo-header {
            border-bottom: 2px solid var(--primary-yellow);
            padding-bottom: 15px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        .repo-header h2 {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
            color: var(--text-dark);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        /* --- TABLA PERSONALIZADA --- */
        .table-custom {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        /* Encabezados */
        .table-custom th {
            background-color: #fff;
            color: var(--text-grey);
            font-weight: 700;
            text-transform: uppercase;
            font-size: 12px;
            padding: 15px;
            border-bottom: 2px solid var(--border-light);
            text-align: left; /* Alineación general a la izquierda */
        }
        /* Filas */
        .table-custom td {
            padding: 15px;
            vertical-align: middle;
            color: var(--text-dark);
            font-size: 14px;
            border-bottom: 1px solid #f5f5f5;
        }
        /* Efecto Cebra (Filas alternas) */
        .table-custom tr:nth-child(even) {
            background-color: #fcfcfc;
        }
        .table-custom tr:hover {
            background-color: #fff9e6; /* Color crema al pasar el mouse */
            transition: background-color 0.2s ease;
        }
        /* Ajuste para imágenes dentro de la tabla */
        .table-custom img {
            background: #fff;
            padding: 2px;
            border: 1px solid #eee;
            border-radius: 6px;
        }
        /* --- BADGES (ETIQUETAS DE ESTATUS) --- */
        .badge {
            display: inline-block;
            padding: 5px 10px;
            font-size: 11px;
            font-weight: 700;
            border-radius: 4px;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
        }
        .badge-danger {
            color: #fff;
            background-color: var(--danger-color);
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
        }
        .badge-warning {
            color: #212529;
            background-color: var(--warning-color);
            box-shadow: 0 2px 4px rgba(255, 193, 7, 0.3);
        }
        .badge-success {
            color: #fff;
            background-color: var(--success-color);
        }
        /* --- RESPONSIVE --- */
        @media (max-width: 768px) {
            .repo-card { padding: 20px; }
            .table-custom th, .table-custom td { padding: 10px 5px; font-size: 12px; }
            .badge { padding: 3px 6px; font-size: 10px; }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1>Top Productos</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="#">Más Vendidos</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <div class="repo-wrapper">
        <div class="container">
            <div class="repo-card">
                <div class="repo-header">
                    <h2><i class="fa fa-trophy" style="color:#ffba00; margin-right:10px;"></i> Productos Más Vendidos</h2>
                </div>
                <p style="color: #6c757d; margin: 0;">
                    Listado de los 10 productos con mayor volumen de ventas confirmadas.
                </p>
            </div>
            <div class="repo-card">
                <div class="table-responsive">
                    <asp:GridView ID="gvMasVendidos" runat="server"
                        AutoGenerateColumns="False" CssClass="table-custom" GridLines="None" 
                        EmptyDataText="No hay datos de ventas registrados aún.">
                        <Columns>
                            <asp:TemplateField HeaderText="Producto">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center">
                                        <img src='<%# Eval("Imagen") %>' alt="" style="width:50px; height:50px; object-fit:contain; margin-right:15px; border:1px solid #eee; border-radius:4px;">
                                        <div>
                                            <h6 class="m-0" style="font-size:14px;"><%# Eval("Producto") %></h6>
                                            <small class="text-muted"><%# Eval("Marca") %> - <%# Eval("Categoria") %></small>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="TotalUnidadesVendidas" HeaderText="Unidades Vendidas">
                                <ItemStyle Font-Bold="true" Font-Size="16px" ForeColor="#28a745" />
                            </asp:BoundField>
                            <asp:BoundField DataField="TotalIngresos" HeaderText="Ingresos Generados">
                                <ItemStyle HorizontalAlign="Right" Font-Bold="true" ForeColor="#333" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>


</asp:Content>