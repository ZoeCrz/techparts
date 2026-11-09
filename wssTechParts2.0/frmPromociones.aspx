<%@ Page Title="" Language="C#" MasterPageFile="~/mpPrincipal.Master" AutoEventWireup="true" CodeBehind="frmPromociones.aspx.cs" Inherits="wssTechParts2._0.Formulario_web13" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Contenedor principal */
        .promo-container { padding: 50px 0; }
        /* --- TÍTULO IMPACTANTE --- */
        .promo-title-box {
            background: linear-gradient(135deg, #ffba00 0%, #ff8c00 100%);
            padding: 30px;
            border-radius: 10px;
            color: #fff;
            margin-bottom: 50px;
            box-shadow: 0 10px 20px rgba(255, 136, 0, 0.2);
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .promo-title-box h1 {
            color: #fff;
            font-size: 36px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        .promo-title-box p {
            color: #fff;
            font-size: 16px;
            font-weight: 500;
            margin: 0;
        }
        /* --- MENSAJE DE "SIN PROMOCIONES" --- */
        .no-promo-box {
            text-align: center;
            padding: 80px 20px;
            background: #f9f9f9;
            border-radius: 10px;
            border: 2px dashed #ddd;
        }
        .no-promo-box i { font-size: 60px; color: #ccc; margin-bottom: 20px; }
        .no-promo-box h3 { color: #555; font-weight: 700; margin-bottom: 10px; }
        .no-promo-box p { color: #888; font-size: 16px; }
        /* --- ESTILOS ANTERIORES DE TARJETAS --- */
        .discount-badge {
            position: absolute; left: 10px;
            background-color: #ff0000; color: #fff;
            padding: 4px 10px; font-size: 12px; font-weight: bold;
            border-radius: 20px; z-index: 5;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        .price .l-through {
            text-decoration: line-through; color: #cccccc;
            font-size: 14px; margin-left: 10px;
        }
        .promo-banner-text {
            color: #28a745; font-size: 12px; font-weight: 600;
            text-transform: uppercase; margin-bottom: 5px; text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1>Ofertas Especiales</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmPromociones.aspx">Promociones</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <div class="container section_gap">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="promo-title-box">
                    <h1>Descuentos Exclusivos</h1>
                    <p>¡Aprovecha los mejores precios por tiempo limitado antes de que se agoten!</p>
                </div>
            </div>
        </div>
        <asp:Panel ID="pnlListaPromociones" runat="server">
            <div class="row">
                <asp:Repeater ID="rptPromociones" runat="server">
                    <ItemTemplate>
                        <div class="col-lg-3 col-md-6">
                            <div class="single-product">
                                <div class="discount-badge">
                                    <%# Eval("Descuento_Aplicado") %>
                                </div>
                                <img class="img-thumbnail figure-img" src='../<%# Eval("Imagen") %>' alt="" 
                                     style="width: 100%; height: 250px; object-fit: contain;">
                                <div class="product-details">
                                    <div class="promo-banner-text"><%# Eval("Promocion") %></div>
                                    <h6><%# Eval("Producto") %></h6>
                                    <div class="price">
                                        <h6>$<%# Eval("Precio_Final", "{0:0.00}") %></h6>
                                        <h6 class="l-through">$<%# Eval("Precio_Original", "{0:0.00}") %></h6>
                                    </div>
                                    <div class="prd-bottom">
                                        <a href="frmIniciarSesion.aspx" class="social-info">
                                            <span class="ti-bag"></span>
                                            <p class="hover-text">A mi bolsa</p>
                                        </a>
                                        <a href="frmDetalleProducto.aspx?clave=<%# Eval("Clave_Producto") %>" class="social-info">
                                            <span class="lnr lnr-move"></span>
                                            <p class="hover-text">Ver más</p>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlSinPromociones" runat="server" Visible="false">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="no-promo-box">
                        <i class="lnr lnr-hourglass"></i>
                        <h3>¡Ups! No hay ofertas activas en este momento.</h3>
                        <p>Estamos preparando nuevos descuentos para ti. Revisa nuestro catálogo completo mientras tanto.</p>
                        <a href="frmProductos.aspx" class="primary-btn mt-4" style="background:#333;">Ir al Catálogo de Productos</a>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>

</asp:Content>