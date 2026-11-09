<%@ Page Title="" Language="C#" MasterPageFile="~/CLIENTE/mpCliente.Master" AutoEventWireup="true" CodeBehind="frmCliCompras.aspx.cs" Inherits="wssTechParts2._0.CLIENTE.Formulario_web12" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- CONFIGURACIÓN DE COLORES Y FUENTES --- */
        :root {
            --primary-yellow: #ffba00;     /* Amarillo del botón */
            --primary-hover: #e6a800;
            --row-cream: #fffbf0;          /* Fondo crema de las filas (como en la imagen) */
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
            border-radius: 4px; /* Bordes más rectos como en la imagen */
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 30px;
            margin-bottom: 30px;
        }
        /* --- HEADER CON LINEA AMARILLA --- */
        .gv-header {
            border-bottom: 2px solid var(--primary-yellow); /* La línea amarilla debajo del título */
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .gv-header h3 {
            margin: 0;
            font-size: 22px;
            font-weight: 700;
            color: var(--text-dark);
        }
        /* --- ESTILOS DE LA TABLA (GRIDVIEW) --- */
        .table-custom {
            width: 100%;
            border-collapse: collapse;
            border: none;
        }
        /* Encabezados de columna (Texto gris, fondo blanco, sin bloque amarillo) */
        .table-custom th {
            background-color: #fff;
            color: var(--text-grey);
            font-weight: 700;
            text-transform: capitalize; /* O 'uppercase' si prefieres */
            padding: 15px;
            border-bottom: 1px solid var(--border-light);
            text-align: center;
            font-size: 14px;
        }
        /* Filas normales (Fondo crema suave) */
        .table-custom tr {
            background-color: var(--row-cream); 
            border-bottom: 1px solid transparent; 
        }
        /* Filas alternas (Fondo blanco) - Para lograr el efecto rayado de la imagen */
        .table-custom tr:nth-child(even) {
            background-color: #fff;
        }
        .table-custom td {
            padding: 20px 15px; /* Espaciado generoso como en la imagen */
            vertical-align: middle;
            color: var(--text-dark);
            font-weight: 500;
            font-size: 15px;
            text-align: center;
            border-top: 1px solid #f0f0f0; /* Línea sutil entre filas */
        }
        /* --- BOTÓN DE ACCIÓN (ESTILO "AGREGAR USUARIO") --- */
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
        /* --- BADGES DE ESTATUS (ESTILO PÍLDORA) --- */
        .badge-status {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-confirmada { background: #d4edda; color: #155724; } /* Verde - ACTIVO */
        .badge-pendiente  { background: #ffe38c; color: #856404; } /* Amarillo */
        .badge-cancelada  { background: #f8d7da; color: #721c24; } /* Rojo */
        /* Paginación */
        .pagination-custom td { padding: 10px; border: none; background: transparent !important; }
        .pagination-custom a, .pagination-custom span {
            padding: 5px 10px;
            border-radius: 3px;
            margin: 0 2px;
            text-decoration: none;
            font-weight: bold;
        }
        .pagination-custom span { background: var(--primary-yellow); color: white; }
        .pagination-custom a { background: #eee; color: #333; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1>Mis compras</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmCliPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmCliCompras.aspx">Mis compras<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmCliCarrito.aspx">Mi bolsa</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <div class="gv-wrapper">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12">
                    <div class="gv-card">
                        <div class="gv-header">
                            <h3>
                                <asp:Label ID="lblVenta" runat="server" Text="Mi historial de compras"></asp:Label>
                            </h3>
                        </div>
                        <div class="table-responsive">
                            <asp:GridView ID="gvComprasAnteriores" runat="server" 
                                DataKeyNames="ClaveCompra,Estatus"
                                CssClass="table-custom"
                                AllowPaging="True" 
                                AutoGenerateColumns="False" 
                                PageSize="8" 
                                OnPageIndexChanging="gvComprasAnteriores_PageIndexChanging"
                                GridLines="None" OnSelectedIndexChanging="gvComprasAnteriores_SelectedIndexChanging">
                                <Columns>
                                    <asp:BoundField DataField="ClaveCompra" HeaderText="Clave de la compra">
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
                                        SelectText="DETALLE DE LA COMPRA" 
                                        ControlStyle-CssClass="btn-detalles" />

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