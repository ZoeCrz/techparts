<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="frmAdmRepoGeneral.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.WebForm5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --primary-yellow: #ffba00;
            --primary-hover: #e6a800;
            --text-dark: #333333;
            --text-grey: #6c757d;
            --border-light: #ececec;
        }
        .repo-wrapper { padding: 40px 0; background: #f8f9fa; font-family: "Segoe UI", Roboto, Arial, sans-serif; }
        .repo-card { background: #fff; border-radius: 4px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); padding: 25px; margin-bottom: 25px; }
        .repo-header { border-bottom: 2px solid var(--primary-yellow); padding-bottom: 15px; margin-bottom: 25px; }
        .repo-header h2 { margin: 0; font-size: 28px; font-weight: 700; color: var(--text-dark); }
        .table-custom { width: 100%; border-collapse: collapse; }
        .table-custom th { background-color: #fff; color: var(--text-grey); font-weight: 700; padding: 15px; border-bottom: 1px solid var(--border-light); text-align: center; font-size: 13px; }
        .table-custom tr { background-color: #fffbf0; }
        .table-custom tr:nth-child(even) { background-color: #fff; }
        .table-custom td { padding: 15px; color: var(--text-dark); font-size: 14px; border-bottom: 1px solid #f0f0f0; text-align: center; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1>Reporte General</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmAdmRepoGeneral.aspx">Reporte General</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <div class="repo-wrapper">
        <div class="container">
            <div class="repo-card">
                <div class="repo-header">
                    <h2>Ventas generales</h2>
                </div>
                <p style="color: #6c757d; margin: 0;">
                    Última actualización: <strong><asp:Label ID="lblFechaActualizacion" runat="server" Text=""></asp:Label></strong>
                </p>
            </div>
            <div class="repo-card">
                <div class="table-responsive">
                    <asp:GridView ID="gvVentasPorDia" runat="server"
                        AutoGenerateColumns="False" CssClass="table-custom" GridLines="None" 
                        EmptyDataText="Sin datos disponibles">
                        <Columns>
                            <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="CantidadVentas" HeaderText="Total de Ventas">
                                <ItemStyle Font-Bold="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="VentasConfirmadas" HeaderText="Confirmadas">
                                <ItemStyle ForeColor="Green" Font-Bold="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="VentasPendientes" HeaderText="En Proceso">
                                <ItemStyle ForeColor="Orange" Font-Bold="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="VentasCanceladas" HeaderText="Canceladas">
                                <ItemStyle ForeColor="Red" Font-Bold="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="TotalDia" HeaderText="Total ($)" DataFormatString="{0:C}">
                                <ItemStyle HorizontalAlign="Right" Font-Bold="true" ForeColor="#ffba00" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
