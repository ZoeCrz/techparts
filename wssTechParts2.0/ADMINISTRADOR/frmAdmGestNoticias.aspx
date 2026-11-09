<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="frmAdmGestNoticias.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.Formulario_web19" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --primary-color: #ffba00;
            --primary-hover: #e5a800;
            --border-color: #e0e0e0;
            --row-hover: #fff9e6;
        }
        .gv-wrapper { padding: 40px 0; background: #f8f9fa; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
        .gv-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); padding: 30px; margin-bottom: 30px; }
        .gv-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 20px; border-bottom: 2px solid var(--primary-color); }
        .gv-header h3 { margin: 0; font-size: 24px; font-weight: 600; color: #333; }
        .btn-add-product {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
            color: #fff; padding: 12px 30px; border: none; border-radius: 6px;
            font-size: 14px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;
            cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 12px rgba(255, 186, 0, 0.3);
            display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-add-product:hover { background: linear-gradient(135deg, var(--primary-hover) 0%, #cc8f00 100%); transform: translateY(-2px); }
        /* Tabla */
        .gv-container .table { margin-bottom: 0; background: #fff; border: none; border-collapse: separate; border-spacing: 0; width: 100%; }
        .gv-container .table thead th { background: var(--primary-color) !important; color: #fff; font-weight: 600; text-transform: uppercase; font-size: 12px; padding: 15px 12px; border: none; vertical-align: middle; white-space: nowrap; }
        .gv-container .table thead th:first-child { border-top-left-radius: 8px; }
        .gv-container .table thead th:last-child { border-top-right-radius: 8px; }
        .gv-container .table td { padding: 16px 12px; vertical-align: middle; font-size: 14px; color: #333; border-bottom: 1px solid #f0f0f0; }
        .gv-container .table tbody tr:nth-of-type(even) { background-color: #fafafa; }
        .gv-container .table tbody tr:hover { background-color: var(--row-hover) !important; cursor: pointer; }
        /* Botones de acción */
        .btn-action { width: 28px; height: 28px; object-fit: contain; opacity: 0.7; transition: all 0.3s ease; cursor: pointer; }
        .btn-action:hover { opacity: 1; transform: scale(1.15); }
        /* Imagen Noticia */
        .gv-container .table td img { border-radius: 4px; border: 1px solid #eee; object-fit: cover; max-width: 100%; max-height: 60px; }
        /* Badges */
        .badge-status { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 11px; font-weight: 600; text-transform: uppercase; }
        .badge-activo { background: #d4edda; color: #155724; }
        .badge-inactivo { background: #f8d7da; color: #721c24; }
        /* Paginación */
        .pagination-custom td { padding: 10px; border: none; }
        .pagination-custom span { background: var(--primary-color); color: #fff; padding: 5px 10px; border-radius: 4px; }
        .pagination-custom a { background: #f5f5f5; color: #333; padding: 5px 10px; border-radius: 4px; text-decoration: none; }
        /* Columnas */
        .col-acciones { width: 100px; text-align: center; }
        .col-id { width: 60px; text-align: center; font-weight: bold; }
        .col-imagen { width: 100px; text-align: center; }
        .col-estatus { width: 100px; text-align: center; }
        @media (max-width: 768px) {
            .gv-header { flex-direction: column; gap: 15px; align-items: stretch; }
            .btn-add-product { width: 100%; justify-content: center; }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1>Gestión de noticias</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="#">Gestión de Noticias</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <div class="gv-wrapper">
        <div class="container gv-container">
            <div class="row justify-content-center">
                <div class="col-12">
                    <div class="gv-card">
                        <div class="gv-header">
                            <h3>Noticias Publicadas</h3>
                            <asp:Button ID="btnAgregarNoticia" runat="server" 
                                Text="Agregar nueva noticia" 
                                CssClass="btn-add-product" 
                                OnClick="btnAgregarNoticia_Click" />
                        </div>
                        <div class="table-responsive">
                            <asp:GridView ID="gvNoticias" runat="server" 
                                CssClass="table" AllowPaging="True" AutoGenerateColumns="False" 
                                PageSize="8" GridLines="None"
                                OnPageIndexChanging="gvNoticias_PageIndexChanging"
                                OnRowCommand="gvNoticias_RowCommand"
                                OnRowDataBound="gvNoticias_RowDataBound"
                                EmptyDataText="No hay noticias registradas.">
                                <Columns>
                                    <asp:TemplateField HeaderText="Editar" ItemStyle-CssClass="col-acciones">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="btnEditar" runat="server" 
                                                ImageUrl="../FOTOS/seleccionar.png" 
                                                CommandName="Editar" 
                                                CommandArgument='<%# Eval("Clave") %>'
                                                CssClass="btn-action" ToolTip="Editar Noticia" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Baja" ItemStyle-CssClass="col-acciones">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="btnEliminar" runat="server" 
                                                ImageUrl="../FOTOS/eliminar.png" 
                                                CommandName="Eliminar"
                                                CommandArgument='<%# Eval("Clave") %>'
                                                CssClass="btn-action" ToolTip="Dar de baja"
                                                OnClientClick="return confirm('¿Seguro que deseas desactivar esta noticia?');" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Clave" HeaderText="ID" ItemStyle-CssClass="col-id" />
                                    <asp:ImageField DataImageUrlField="Imagen" HeaderText="Imagen">
                                        <ControlStyle Width="80px" Height="50px" />
                                        <ItemStyle CssClass="col-imagen" />
                                    </asp:ImageField>
                                    <asp:BoundField DataField="Titulo" HeaderText="Título" ItemStyle-Font-Bold="true" />
                                    <asp:BoundField DataField="Fecha" HeaderText="Fecha Publicación" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}" />
                                    <asp:TemplateField HeaderText="Estatus" ItemStyle-CssClass="col-estatus">
                                        <ItemTemplate>
                                            <span class='<%# Eval("Estatus").ToString() == "ACTIVA" ? "badge-status badge-activo" : "badge-status badge-inactivo" %>'>
                                                <%# Eval("Estatus") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField >
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