<%@ Page Title="" Language="C#" MasterPageFile="~/CLIENTE/mpCliente.Master" AutoEventWireup="true" CodeBehind="frmCliDetProducto.aspx.cs" Inherits="wssTechParts2._0.CLIENTE.Formulario_web16" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Estilo para el input numérico (Pequeño y centrado) */
        .quantity-input {
            width: 70px !important;
            text-align: center;
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ced4da;
            margin-right: 10px; /* Espacio con las flechitas si las usas */
        }
        /* Estilo para el botón rectangular moderno */
        .btn-rect {
            display: inline-block;
            padding: 12px 40px;
            border-radius: 0; /* Rectangular */
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: none;
            cursor: pointer;
            transition: 0.3s;
            text-align: center;
            text-decoration: none;
        }
        .btn-primary-rect {
            background: #ffba00; /* Tu color amarillo primario */
            color: #fff;
        }
        .btn-primary-rect:hover {
            background: #e6a800; /* Color hover */
            color: #fff;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .precio-tachado {
            text-decoration: line-through;
            color: #ff6a00;
            font-size: 0.6em;  /* Más pequeño que el precio principal */
            margin-left: 15px; /* Separación */
            font-weight: normal;
        }
        /* Ajuste para alinear input y botón */
        .product_count { display: flex; align-items: center; margin-bottom: 20px; }
        .product_count label { margin-right: 15px; font-weight: bold; color: #555; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <!-- Start Banner Area -->
	<section class="banner-area organic-breadcrumb">
		<div class="container">
			<div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
				<div class="col-first">
					<h1>Detalles del producto</h1>
					<nav class="d-flex align-items-center">
						<a href="frmCliPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
						<a href="frmCliProductos.aspx">Catálogo de productos<span class="lnr lnr-arrow-right"></span></a>
                        <a href="#">Detalles del producto</a>
					</nav>
				</div>
			</div>
		</div>
	</section>
	<!-- End Banner Area -->

    <!--================Single Product Area =================-->
    <div class="product_image_area">
        <div class="container">
            <div class="row s_product_inner">
                <div class="col-lg-6">
                    <div class="s_Product_carousel">
                        <div class="single-prd-item">
                            <asp:Image ID="imgProducto1" CssClass="img-fluid" width="500" runat="server" />
                        </div>
                        <div class="single-prd-item">
                            <asp:Image ID="imgProducto2" CssClass="img-fluid" width="500" runat="server" />
                        </div>
                        <div class="single-prd-item">
                            <asp:Image ID="imgProducto3" CssClass="img-fluid" width="500" runat="server" />
                        </div>
                    </div>
                </div>
                <div class="col-lg-5 offset-lg-1">
                    <div class="s_product_text">
                        <h3><asp:Label ID="lblNombre" runat="server" Text=""></asp:Label></h3>
                        <h2>
                            <asp:Label ID="lblPrecio" runat="server" Text=""></asp:Label>
                            <asp:Label ID="lblPrecioAnterior" runat="server" Text="" Visible="false" CssClass="precio-tachado"></asp:Label>
                        </h2>
                        <ul class="list">
                            <li><a class="active"><span>Categoría</span> : 
                                <asp:Label ID="lblCategoria" runat="server"></asp:Label></a></li>
                            <li><a><span>Disponibilidad</span> : 
                                <asp:Label ID="lblExistencias" runat="server"></asp:Label></a></li>
                        </ul>
                        <p><asp:Label ID="lblDescripcion" runat="server"></asp:Label></p>
                       <div class="product_count">
                            <label for="qty">Cantidad:</label>
    
                            <asp:TextBox ID="txtCantidad" runat="server" 
                                Text="1" TextMode="Number" min="1" max="50"
                                CssClass="quantity-input" ClientIDMode="Static">
                            </asp:TextBox>
                        </div>
                        <div class="card_area d-flex align-items-center m-5">
                            <asp:Button ID="btnAgregarCarrito" runat="server" Text="A mi bolsa" 
                                CssClass="btn-rect btn-primary-rect" 
                                OnClick="btnAgregarCarrito_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--================End Single Product Area =================-->


</asp:Content>
