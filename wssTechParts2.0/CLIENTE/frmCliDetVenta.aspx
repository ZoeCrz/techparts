<%@ Page Title="" Language="C#" MasterPageFile="~/CLIENTE/mpCliente.Master" AutoEventWireup="true" CodeBehind="frmCliDetVenta.aspx.cs" Inherits="wssTechParts2._0.CLIENTE.Formulario_web17" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
    /* Efecto al pasar el mouse por la imagen del producto */
    .img-link-hover img {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        cursor: pointer;
    }
    .img-link-hover:hover img {
        transform: scale(1.05); /* Crece un poquito */
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1>
                        Detalle de la compra #<asp:Label ID="lblFolioCompra" runat="server"></asp:Label>
                    </h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmCliPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmCliCompras.aspx">Mis compras<span class="lnr lnr-arrow-right"></span></a>
                        <a href="#">Detalle de la compra</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <section class="cart_area">
        <div class="container">
            <div class="cart_inner">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th scope="col">Producto</th>
                                <th scope="col">Precio</th>
                                <th scope="col">Cantidad</th>
                                <th scope="col">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptDetalleVenta" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <div class="media">
                                                <div class="d-flex">
                        
                                                    <a href='frmCliDetProducto.aspx?clave=<%# Eval("CveProducto") %>' class="img-link-hover">
                                                        <img src='<%# Eval("Imagen") %>' 
                                                             alt='<%# Eval("Productos") %>' 
                                                             style="max-width: 100px; max-height: 80px; object-fit: contain; border-radius: 5px;">
                                                    </a>
                                                </div>
                                                <div class="media-body">
                                                    <a href='frmCliDetProducto.aspx?clave=<%# Eval("CveProducto") %>' style="color: inherit; text-decoration: none;">
                                                        <p class="font-weight-bold"><%# Eval("Productos") %></p>
                                                    </a>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <h5><%# Eval("PrecioUnidad", "{0:C}") %></h5>
                                        </td>
                                        <td>
                                            <div class="product_count">
                                                <h5 style="padding-top: 15px;">
                                                    <%# Eval("UnidadesCompradas") %> pza(s)
                                                </h5>
                                            </div>
                                        </td>
                                        <td>
                                            <h5><%# Eval("TotalxUnidades", "{0:C}") %></h5>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                            <tr>
                                <td colspan="2" style="vertical-align: top; padding-top: 20px;">
                                    <div class="shipping-info">
                                        <h5 style="margin-bottom: 10px; color: #555;">Detalles de entrega</h5>
            
                                        <p style="margin-bottom: 5px; color: #777;">
                                            <i class="fa fa-map-marker" style="color: #ffba00; margin-right: 5px;"></i>
                                            <strong>Dirección: </strong> 
                                            <asp:Label ID="lblDireccionEnvio" runat="server" Text="Cargando..."></asp:Label>
                                        </p>
                                        <p style="color: #777;">
                                            <i class="fa fa-credit-card" style="color: #28a745; margin-right: 5px;"></i>
                                            <strong>Pago: </strong> 
                                            <asp:Label ID="lblMetodoPago" runat="server" Text="Cargando..."></asp:Label>
                                        </p>
                                    </div>
                                </td>
                                <td>
                                    <h5>Subtotal</h5>
                                    <h5>I.V.A (16%)</h5>
                                    <h4>Total</h4>
                                </td>
                                <td>
                                    <h5><asp:Label ID="lblSubtotal" runat="server" Text="$0.00"></asp:Label></h5>
                                    <h5><asp:Label ID="lblIVA" runat="server" Text="$0.00"></asp:Label></h5>
                                    <h4><asp:Label ID="lblTotal" runat="server" Text="$0.00"></asp:Label></h4>
                                </td>
                            </tr>
                            <tr class="out_button_area">
                                <td colspan="4"> <div class="checkout_btn_inner d-flex align-items-center justify-content-end">
                                        <a class="gray_btn" href="frmCliCompras.aspx">Volver a mis compras</a>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>


</asp:Content>