<%@ Page Title="" Language="C#" MasterPageFile="~/CLIENTE/mpCliente.Master" AutoEventWireup="true" CodeBehind="frmCliProductos.aspx.cs" Inherits="wssTechParts2._0.CLIENTE.Formulario_web15" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- ESTILOS DE FILTRADO --- */
        /* Categoría Seleccionada (Naranja) */
        .active-filter {
            color: #ffba00 !important; /* !important para sobreescribir el gris de la plantilla */
            font-weight: 700 !important;
        }
        /* Categoría Normal (Gris) */
        .normal-filter {
            color: #777;
            transition: 0.3s;
        }
        .normal-filter:hover { color: #ffba00; }
        /* --- ALINEACIÓN PERFECTA DE MARCAS --- */
        /* El contenedor (LinkButton) */
        .brand-link {
            display: flex !important;        /* Activa Flexbox */
            align-items: center !important;  /* Centra verticalmente los elementos hijos */
            justify-content: flex-start !important;
            width: 100%;
            text-decoration: none !important;
            color: #777;
            cursor: pointer;
            padding: 5px 0;
            min-height: 30px; /* Altura mínima para evitar colapsos */
        }
        /* El Círculo (Radio Button) */
        .brand-link input[type="radio"] {
            margin: 0 !important;          /* Quitar márgenes rebeldes */
            margin-right: 10px !important; /* Espacio entre círculo y texto */
            position: relative !important; /* Evitar que flote fuera de lugar */
            top: 0 !important;
            vertical-align: middle !important;
            /* Forzar que no se estire */
            flex-shrink: 0; 
            width: 15px; 
            height: 15px;
        }
        /* El Texto (Label) */
        .brand-label {
            margin: 0 !important;
            padding: 0 !important;
            line-height: 1 !important; /* Ajustar altura de línea para centrar con el círculo */
            cursor: pointer;
            width: auto;
            font-weight: 400;
            color: #777;
            /* Flex para alinear el número entre paréntesis si es necesario */
            display: flex; 
            align-items: center;
        }
        /* Estilo Hover para la marca */
        .brand-link:hover .brand-label {
            color: #ffba00;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


	<!-- Start Banner Area -->
	<section class="banner-area organic-breadcrumb">
		<div class="container">
			<div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
				<div class="col-first">
					<h1>Productos disponbles</h1>
					<nav class="d-flex align-items-center">
						<a href="frmCliPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
						<a href="frmCliProductos.aspx">Productos disponibles</a>
					</nav>
				</div>
			</div>
		</div>
	</section>
	<!-- End Banner Area -->

	<!-- Start Product Area -->
	<div class="container">
		<div class="row mt-5">
			<div class="col-xl-3 col-lg-4 col-md-5">
				<div class="sidebar-categories">
					<div class="head">Categorías</div>
					<ul class="main-categories">
						<li class="main-nav-list">
							<asp:LinkButton ID="lnkVerTodo" runat="server" OnClick="lnkVerTodo_Click" 
								CssClass='<%# (ViewState["FiltroCat"] == null || ViewState["FiltroCat"].ToString() == "0") ? "active-filter" : "normal-filter" %>'>
								<span class="lnr lnr-sync"></span> Ver todos los productos
							</asp:LinkButton>
						</li>
						<asp:Repeater ID="rptCategorias" runat="server">
							<ItemTemplate>
								<li class="main-nav-list">
									<asp:LinkButton ID="lnkFiltroCat" runat="server" 
										CommandArgument='<%# Eval("Clave") %>' 
										OnClick="lnkFiltroCat_Click"
										CssClass='<%# (ViewState["FiltroCat"] != null && ViewState["FiltroCat"].ToString() == Eval("Clave").ToString()) ? "active-filter" : "normal-filter" %>'>
                    
										<span class="lnr lnr-arrow-right"></span>
										<%# Eval("Categoria") %>
										<span class="number">(<%# Eval("Cantidad") %>)</span>
									</asp:LinkButton>
								</li>
							</ItemTemplate>
						</asp:Repeater>
					</ul>
				</div>
				<div class="sidebar-filter mt-50">
					<div class="top-filter-head">Filtrar Productos</div>
					<div class="common-filter">
						<div class="head">Marcas</div>
						<div> 
							<ul>
								<asp:Repeater ID="rptMarcas" runat="server">
									<ItemTemplate>
										<li class="filter-list">
											<asp:LinkButton ID="lnkFiltroMarca" runat="server" 
												CommandArgument='<%# Eval("Clave") %>' 
												OnClick="lnkFiltroMarca_Click" 
												CssClass="brand-link"> 
												<input class="pixel-radio" type="radio" name="brand" 
													   <%# (ViewState["FiltroMar"] != null && ViewState["FiltroMar"].ToString() == Eval("Clave").ToString()) ? "checked" : "" %>>
												<span class="brand-label">
													<%# Eval("Marca") %>&nbsp;<span style="color:#aaa;">(<%# Eval("Cantidad") %>)</span>
												</span>
											</asp:LinkButton>
										</li>
									</ItemTemplate>
								</asp:Repeater>
							</ul>
						</div>
					</div>
				</div>
			</div>

			<div class="col-xl-9 col-lg-8 col-md-7">
				<!-- Start Best Seller -->
				<section class="lattest-product-area pb-40 category-list">
					<div class="row">
						<asp:Repeater ID="rptProductos" runat="server">
							<ItemTemplate>
								<div class="col-lg-4 col-md-6">
									<div class="single-product">
										<asp:Panel ID="pnlOferta" runat="server" Visible='<%# Eval("Descuento").ToString() == "1" %>'>
											<div class="discount-badge" style="position:absolute; top:15px; left:10px; background:#ff0000; color:#fff; padding:4px 10px; border-radius:20px; font-size:12px; font-weight:bold; z-index:5;">
												<%# Eval("EtiquetaDescuento") %>
											</div>
										</asp:Panel>
										<img class="img-thumbnail figure-img" width="2000" height="1470" src='../<%# Eval("Imagen") %>' alt="" />
										<div class="product-details">
											<h6><%# Eval("Productos") %></h6>
											<div class="price">
												<h6>$<%# Eval("CostoFinal", "{0:0.00}") %></h6>

												<span runat="server" visible='<%# Eval("Descuento").ToString() == "1" %>' 
													  style="text-decoration:line-through; color:#999; font-size:13px; margin-left:5px;">
													$<%# Eval("Costo", "{0:0.00}") %>
												</span>
											</div>
											<div class="prd-bottom">
												<asp:LinkButton ID="btnAgregar" runat="server" CssClass="social-info" 
													CommandArgument='<%# Eval("Clave") + "|" + Eval("CostoFinal") %>' 
													OnClick="btnAgregar_Click"> <span class="ti-bag"></span>
													<p class="hover-text">A mi bolsa</p>
												</asp:LinkButton>
												<a href="frmCliDetProducto.aspx?clave=<%# Eval("Clave") %>" class="social-info">
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
				</section>
				<!-- End Best Seller -->

				<!-- Start Filter Bar -->
				<div class="filter-bar d-flex flex-wrap align-items-center">
					<div class="sorting mr-auto">
						<asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="true" CssClass="form-control-sm"
							OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">
							<asp:ListItem Text="Mostrar 6" Value="6" />
							<asp:ListItem Text="Mostrar 9" Value="9" />
							<asp:ListItem Text="Mostrar 12" Value="12" />
						</asp:DropDownList>
					</div>
					<div class="pagination">
						<asp:LinkButton ID="lnkPrev" runat="server" CssClass="prev-arrow" OnClick="lnkPrev_Click">
							<i class="fa fa-long-arrow-left" aria-hidden="true"></i>
						</asp:LinkButton>
						<asp:Label ID="lblPageInfo" runat="server" Text="" CssClass="mx-3 text-white align-middle"></asp:Label>
						<asp:LinkButton ID="lnkNext" runat="server" CssClass="next-arrow" OnClick="lnkNext_Click">
							<i class="fa fa-long-arrow-right" aria-hidden="true"></i>
						</asp:LinkButton>
					</div>
				</div>
				<!-- End Filter Bar -->
			</div>
		</div>
	</div>


</asp:Content>