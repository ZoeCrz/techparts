<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="frmAdmRepoMenosVendidos.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.Formulario_web18" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- VARIABLES DE TEMA --- */
        :root {
            --primary-yellow: #ffba00;
            --text-dark: #333333;
            --text-grey: #6c757d;
            --bg-light: #f8f9fa;
            --border-light: #ececec;
        }
        .repo-wrapper { padding: 50px 0; background: var(--bg-light); min-height: 80vh; }
        .repo-card { background: #fff; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); padding: 35px; margin-bottom: 30px; border: 1px solid #f0f0f0; }
        .repo-header { border-bottom: 2px solid var(--primary-yellow); padding-bottom: 15px; margin-bottom: 20px; display: flex; align-items: center; }
        .repo-header h2 { margin: 0; font-size: 24px; font-weight: 700; color: var(--text-dark); text-transform: uppercase; }
        .table-custom { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .table-custom th { background-color: #fff; color: var(--text-grey); font-weight: 700; font-size: 12px; padding: 15px; border-bottom: 2px solid var(--border-light); text-align: left; text-transform: uppercase; }
        .table-custom td { padding: 15px; vertical-align: middle; color: var(--text-dark); font-size: 14px; border-bottom: 1px solid #f5f5f5; }
        /* Efecto Cebra (Filas alternas) */
        .table-custom tr:nth-child(even) {
            background-color: #fcfcfc;
        }
        .table-custom tr:hover { background-color: #fff9e6; transition: background-color 0.2s ease; }
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
        /* --- ESTILOS PARA LOS BADGES DE ESTATUS --- */
        .badge-status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px; /* Ajusté un poco para que quepa mejor en tabla */
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-activo {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .badge-inactivo {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        /* Badges de Situación de Ventas */
        .badge-situacion-danger { background-color: #dc3545; color: white; padding: 4px 8px; border-radius: 4px; font-size: 10px; font-weight: bold; }
        .badge-situacion-warning { background-color: #ffc107; color: #212529; padding: 4px 8px; border-radius: 4px; font-size: 10px; font-weight: bold; }
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
                    <h1>Inventario Estancado</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="#">Menos Vendidos</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <div class="repo-wrapper">
        <div class="container">
            <div class="repo-card">
                <div class="repo-header">
                    <h2><i class="fa fa-exclamation-circle" style="color:#dc3545; margin-right:10px;"></i> Productos Menos Vendidos</h2>
                </div>
                <p style="color: #6c757d; margin: 0;">
                    Análisis de productos con baja rotación. Verifica si es necesario crear una oferta para liberar stock.
                </p>
            </div>
            <div class="repo-card">
                <div class="table-responsive">
                    <asp:GridView ID="gvMenosVendidos" runat="server"
                        AutoGenerateColumns="False" CssClass="table-custom" GridLines="None" 
                        EmptyDataText="No hay información disponible.">
                        <Columns>
                            <asp:TemplateField HeaderText="Producto">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center">
                                        <img src='<%# Eval("Imagen") %>' alt="" 
                                             style="width:40px; height:40px; object-fit:contain; margin-right:15px; border-radius:4px; background:#fff; border:1px solid #eee;">
                                        <div>
                                            <h6 class="m-0" style="font-size:14px; font-weight:600;"><%# Eval("Producto") %></h6>
                                            <small style="color:#888;"><%# Eval("Categoria") %> | <%# Eval("Marca") %></small>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="StockActual" HeaderText="Stock Actual">
                                <ItemStyle Font-Bold="true" HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="TotalUnidadesVendidas" HeaderText="Ventas Históricas">
                                <ItemStyle Font-Bold="true" ForeColor="#dc3545" HorizontalAlign="Center" />
                            </asp:BoundField>
                            <%-- COLUMNA NUEVA: ESTATUS DEL CATÁLOGO --%>
                            <asp:TemplateField HeaderText="Estatus Catálogo">
                                <ItemTemplate>
                                    <span class='<%# Eval("Estatus").ToString() == "ACTIVO" ? "badge-status badge-activo" : "badge-status badge-inactivo" %>'>
                                        <%# Eval("Estatus") %>
                                    </span>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <%-- COLUMNA: SITUACIÓN DE VENTA (Análisis) --%>
                            <asp:TemplateField HeaderText="Diagnóstico">
                                <ItemTemplate>
                                    <%# Convert.ToInt32(Eval("TotalUnidadesVendidas")) == 0 ? 
                                        "<span class='badge-situacion-danger'>SIN VENTAS</span>" : 
                                        "<span class='badge-situacion-warning'>BAJAS VENTAS</span>" %>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="TotalIngresos" HeaderText="Ingresos">
                                <ItemStyle HorizontalAlign="Right" ForeColor="#999" font-size="12px" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>


</asp:Content>