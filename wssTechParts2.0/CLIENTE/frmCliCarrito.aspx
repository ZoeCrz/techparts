<%@ Page Title="" Language="C#" MasterPageFile="~/CLIENTE/mpCliente.Master" AutoEventWireup="true" CodeBehind="frmCliCarrito.aspx.cs" Inherits="wssTechParts2._0.CLIENTE.Formulario_web13" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --primary-yellow: #ffba00;
            --primary-hover: #e6a800;
            --text-dark: #333;
            --text-grey: #777;
            --bg-light: #f9f9ff;
            --border-color: #eee;
        }
        .gv-wrapper { padding: 50px 0; background-color: var(--bg-light); }
        .gv-card { background: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        /* --- HEADER --- */
        .gv-header { border-bottom: 2px solid var(--primary-yellow); padding-bottom: 15px; margin-bottom: 30px; }
        .gv-header h3 { font-weight: 700; color: var(--text-dark); }
        /* --- TABLA --- */
        .table-custom { width: 100%; vertical-align: middle; }
        .table-custom th { background: #f9f9f9; padding: 15px; color: var(--text-grey); font-weight: 600; text-align: center; border: none; }
        .table-custom td { padding: 20px; vertical-align: middle !important; text-align: center; border-bottom: 1px solid var(--border-color); }
        .img-product-link { display: block; overflow: hidden; border-radius: 8px; transition: transform 0.3s ease; }
        .img-product-link:hover { transform: scale(1.05); cursor: pointer; }
        .btn-delete { color: #ff4444; font-size: 18px; padding: 5px; border: 1px solid #ff4444; border-radius: 50%; width: 35px; height: 35px; display: inline-flex; align-items: center; justify-content: center; transition: 0.3s; }
        .btn-delete:hover { background: #ff4444; color: #fff; text-decoration: none; }
        /* --- DIRECCIONES (Selectores Tarjeta) --- */
        .address-selector {
            display: block; position: relative; padding: 15px 20px; margin-bottom: 15px;
            border: 1px solid #ddd; border-radius: 6px; cursor: pointer; transition: all 0.3s ease; background: #fff;
        }
        .address-selector:has(input:checked), .address-selector.active {
            border: 2px solid var(--primary-yellow); background-color: #fffbf0;
        }
        .address-selector label { margin-bottom: 0; font-weight: 600; color: var(--text-dark); cursor: pointer; width: 100%; display: block; }
        .address-selector small { display: block; color: var(--text-grey); margin-top: 5px; font-weight: normal; }
        .custom-radio input[type="radio"] { accent-color: var(--primary-yellow); transform: scale(1.2); margin-right: 10px; }
        /* --- CAJA DE PAGO --- */
        .payment-box { 
            background: #f9f9f9; 
            padding: 25px; 
            border-radius: 8px; 
            height: 100%; 
            display: flex;       /* Flex para organizar verticalmente */
            flex-direction: column; 
        }
        .payment-icons { margin-bottom: 15px; }
        .payment-icons i { margin-right: 10px; font-size: 24px; color: #555; }
        .custom-select {
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 4px; background-color: #fff; margin-top: 5px; margin-bottom: 20px; /* Margen abajo para empujar los totales */
        }
        /* --- ÁREA DE TOTALES --- */
        .totals-area { 
            width: 100%;
            border-top: 1px solid #ddd;
            padding-top: 20px;
            margin-top: auto;
        }
        /* Filas de totales más robustas */
        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
            width: 100%;
        }
        .total-row h5 { font-size: 15px; margin: 0; color: #555; }
        .total-row.final h4 { font-size: 22px; font-weight: 800; color: var(--primary-yellow); margin: 0; }
        .total-row.final h4.label { color: #333; font-size: 18px; }
        /* --- BOTONES --- */
        .action-buttons { display: flex; gap: 10px; margin-top: 25px; width: 100%; }
        .btn-rect { flex: 1; padding: 12px 0; border-radius: 0; font-weight: 700; text-transform: uppercase; border: none; cursor: pointer; transition: 0.3s; text-align: center; }
        .btn-primary-rect { background: var(--primary-yellow); color: #fff; }
        .btn-primary-rect:hover { background: var(--primary-hover); color: #fff; }
        .btn-gray-rect { background: #e0e0e0; color: #333; }
        .btn-gray-rect:hover { background: #ccc; color: #333; }
        /* Estilo para el input de cantidad */
        .quantity-input {
            width: 70px !important;    /* Ancho fijo pequeño */
            text-align: center;        /* Número centrado */
            padding: 5px;              /* Espaciado interno */
            border-radius: 4px;
            border: 1px solid #ced4da;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1>Mi bolsa</h1>
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
                            <h3><asp:Label ID="lblVenta" runat="server" Text="Tu Carrito de Compras"></asp:Label></h3>
                        </div>
                        <div class="table-responsive mb-4">
                            <asp:GridView ID="gvCarrito" runat="server" 
                                AutoGenerateColumns="False" 
                                CssClass="table-custom" 
                                GridLines="None"
                                OnRowCommand="gvCarrito_RowCommand"
                                OnRowDataBound="gvCarrito_RowDataBound"
                                ShowHeaderWhenEmpty="true">
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEliminar" runat="server" 
                                                CommandName="EliminarProducto" 
                                                CommandArgument='<%# Eval("CveProducto") + "|" + Eval("UnidadesCompradas") %>'
                                                CssClass="btn-delete">
                                                <span class="lnr lnr-trash"></span>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Producto">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center justify-content-center flex-column">
                                                <a href='frmCliDetProducto.aspx?clave=<%# Eval("CveProducto") %>' class="img-product-link mb-2">
                                                    <img src='<%# Eval("Imagen") %>' alt="" style="width:80px; height:auto;">
                                                </a>
                                                <p class="m-0 font-weight-bold"><%# Eval("Productos") %></p>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Precio">
                                        <ItemTemplate>
                                            <h6 class="m-0"><%# Eval("PrecioUnidad", "{0:C}") %></h6>
                                            <asp:Panel ID="pnlAhorro" runat="server" 
                                                        Visible='<%# Convert.ToDouble(Eval("PrecioUnidad")) < Convert.ToDouble(Eval("PrecioOriginal")) %>'>
                                                <small style="text-decoration:line-through; color:#999;">
                                                    <%# Eval("PrecioOriginal", "{0:C}") %>
                                                </small>
                                            </asp:Panel>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Cantidad">
                                        <ItemTemplate>
                                            <div class="d-flex justify-content-center">
                                                <asp:TextBox ID="txtCantidad" runat="server" 
                                                    TextMode="Number"
                                                    CssClass="form-control quantity-input" 
                                                    Text='<%# Bind("UnidadesCompradas") %>'
                                                    OnTextChanged="txtCantidad_TextChanged"
                                                    AutoPostBack="true"
                                                    min="1" max="50">
                                                </asp:TextBox>
                                            </div>
                                            <asp:HiddenField ID="hfCveProducto" runat="server" Value='<%# Eval("CveProducto") %>' />
                                            <asp:HiddenField ID="hfPrecio" runat="server" Value='<%# Eval("PrecioUnidad") %>' />
                                            <asp:HiddenField ID="hfCantidadActual" runat="server" Value='<%# Eval("UnidadesCompradas") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="TotalxUnidades" HeaderText="Total" DataFormatString="{0:C}" />
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="text-center p-5 text-muted">
                                        <h4><span class="ti-bag"></span></h4>
                                        <p>Tu bolsa está vacía.</p>
                                        <a href="frmCliProductos.aspx" class="genric-btn primary small mt-3">Ir a comprar</a>
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                            <asp:Panel ID="pnlOpcionesCompra" runat="server" Visible="false">
                                <div class="row">
                                    <div class="col-lg-7 mb-4">
                                        <h4 class="mb-3">Dirección de envío</h4>
                                        <div class="address-selector custom-radio">
                                            <asp:RadioButton ID="rbMiDireccion" runat="server" GroupName="envio" Checked="true" />
                                            <label for='<%= rbMiDireccion.ClientID %>'>
                                                Enviar a mi domicilio registrado
                                                <small><asp:Label ID="lblDireccionCliente" runat="server" Text="(Cargando...)"></asp:Label></small>
                                            </label>
                                        </div>
                                        <div class="address-selector custom-radio">
                                            <asp:RadioButton ID="rbSucursal1" runat="server" GroupName="envio" />
                                            <label for='<%= rbSucursal1.ClientID %>'>
                                                Recoger en Sucursal Tolcayuca
                                                <small>Ex Hacienda San Javier, Tolcayuca 1009, 43860 Tolcayuca, Hgo.</small>
                                            </label>
                                        </div>
                                        <div class="address-selector custom-radio">
                                            <asp:RadioButton ID="rbSucursal2" runat="server" GroupName="envio" />
                                            <label for='<%= rbSucursal2.ClientID %>'>
                                                Recoger en Sucursal Pachuca
                                                <small>Camino Real de La Plata 102, Zona Plateada, 42083 Pachuca de Soto, Hgo.</small>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-lg-5">
                                        <div class="payment-box">
                                            <h4 class="mb-3">Resumen de Pago</h4>
                                        
                                            <div class="payment-icons">
                                                <i class="fa fa-credit-card" style="color:#0056b3;"></i>
                                                <i class="fa fa-cc-paypal" style="color:#003087;"></i>
                                                <i class="fa fa-money" style="color:#28a745;"></i>
                                                <span style="font-size:12px; color:#999; margin-left:5px;">Aceptamos</span>
                                            </div>
                                            <h6 class="text-muted">Método de pago:</h6>
                                            <asp:DropDownList ID="ddlMetodoPago" runat="server">
                                                <asp:ListItem Value="Tarjeta de Crédito">Tarjeta de Crédito</asp:ListItem>
                                                <asp:ListItem Value="Tarjeta de Débito">Tarjeta de Débito</asp:ListItem>
                                                <asp:ListItem Value="PayPal">PayPal</asp:ListItem>
                                                <asp:ListItem Value="OXXO Pay (Efectivo)">OXXO Pay (Efectivo)</asp:ListItem>
                                            </asp:DropDownList>
                                            <div class="totals-area">
                                                <div class="total-row">
                                                    <h5>Subtotal:</h5>
                                                    <h5><asp:Label ID="lblSubtotal" runat="server" Text="$0.00"></asp:Label></h5>
                                                </div>
                                                <div class="total-row">
                                                    <h5>I.V.A (16%):</h5>
                                                    <h5><asp:Label ID="lblIVA" runat="server" Text="$0.00"></asp:Label></h5>
                                                </div>
                                                <div class="total-row final mt-3">
                                                    <h4 class="label">Total a Pagar:</h4>
                                                    <h4><asp:Label ID="lblTotal" runat="server" Text="$0.00"></asp:Label></h4>
                                                </div>
                                            </div>
                                            <div class="action-buttons">
                                                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" 
                                                    CssClass="btn-rect btn-gray-rect" OnClick="btnCancelar_Click" />
                                                <asp:Button ID="btnConfirmar" runat="server" Text="Confirmar Compra" 
                                                    CssClass="btn-rect btn-primary-rect" OnClick="btnConfirmar_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>


</asp:Content>