<%@ Page Title="" Language="C#" MasterPageFile="~/mpPrincipal.Master" AutoEventWireup="true" CodeBehind="frmPrincipal.aspx.cs" Inherits="wssTechParts2._0.Formulario_web1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Reducimos el padding original de la plantilla para juntar las secciones */
        .section_gap {
            padding: 30px 0 !important; 
        }
        /* Ajustes específicos para los carruseles para quitar margenes extra */
        .active-product-area {
            margin-top: 20px !important;
            margin-bottom: 20px !important;
        }
        /* --- MOSAICO DE IMÁGENES Y OSCURECIMIENTO --- */
        .single-deal {
            position: relative;
            margin-bottom: 20px; /* Reducción el margen inferior entre cuadros */
            overflow: hidden;
        }
        /* Clase para que todas las imágenes midan lo mismo y se vean ordenadas */
        .img-cover {
            height: 260px;        
            object-fit: cover;   
            object-position: center;
            width: 100%;
            display: block;
        }
        /* --- OSCURECER IMAGEN PARA LEER TEXTO --- */
        .single-deal .overlay {
            background-color: rgba(0, 0, 0, 0.4); /* Negro al 40% de opacidad */
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            z-index: 1; /* Se pone encima de la imagen */
            transition: all 0.3s ease;
        }
        /* Efecto Hover: Al pasar el mouse se oscurece un poco más */
        .single-deal:hover .overlay {
            background-color: rgba(0, 0, 0, 0.6);
        }
        /* Asegurar que el texto esté ENCIMA de la capa oscura */
        .deal-details {
            position: absolute;
            top: 50%;
            left: 0;
            width: 100%;
            transform: translateY(-50%);
            z-index: 2; /* Encima del overlay */
            text-align: center;
        }
        /* Texto blanco con sombra para máxima legibilidad */
        .deal-title {
            color: #ffffff !important;
            font-weight: 700;
            text-transform: uppercase;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.8); /* Sombra negra al texto */
        }
        /* Zoom suave en la imagen al pasar el mouse */
        .single-deal:hover .img-cover {
            transform: scale(1.1);
            transition: transform 0.5s ease;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


	<!-- start banner Area -->
	<section class="banner-area">
		<div class="container">
			<div class="row fullscreen align-items-center justify-content-start">
				<div class="col-lg-12">
					<!-- Carrusel dinámico de noticias -->
					<div class="active-banner-slider owl-carousel">
						<asp:Repeater ID="rptNoticias" runat="server">
							<ItemTemplate>
								<div class="row single-slide align-items-center d-flex">
									<div class="col-lg-5 col-md-6">
										<div class="banner-content align-content-center">
											<h2><%# Eval("Titulo") %></h2>
											<p><%# Eval("Contenido") %></p>
											<div class="add-bag d-flex align-items-center">
												<a class="add-btn" href='<%# Eval("URL") %>'>
													<span class="lnr lnr-select"></span>
												</a>
												<span class="add-text text-uppercase">Ver noticia</span>
											</div>
										</div>
									</div>
									<div class="col-lg-7">
										<div class="banner-img" style="text-align: center;"> <img src='<%# Eval("Imagen") %>' 
												 alt="Noticia" 
												 class="img-fluid"
												 style="width: auto; height: 390px; object-fit: contain; border-radius: 8px;" />
										</div>
									</div>
								</div>
							</ItemTemplate>
						</asp:Repeater>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- End banner Area -->


	<!-- start features Area -->
	<section class="features-area section_gap">
		<div class="container">
			<div class="row features-inner">
				<!-- single features -->
				<div class="col-lg-3 col-md-6 col-sm-6">
					<div class="single-features">
						<div class="f-icon">
							<img src="Plantilla/img/features/f-icon1.png" alt="">
						</div>
						<h6>Envío gratuito</h6>
						<p>Envío gratuito a todo el país</p>
					</div>
				</div>
				<!-- single features -->
				<div class="col-lg-3 col-md-6 col-sm-6">
					<div class="single-features">
						<div class="f-icon">
							<img src="Plantilla/img/features/f-icon2.png" alt="">
						</div>
						<h6>Política de devolución</h6>
						<p>Devolución fácil y rápida</p>
					</div>
				</div>
				<!-- single features -->
				<div class="col-lg-3 col-md-6 col-sm-6">
					<div class="single-features">
						<div class="f-icon">
							<img src="Plantilla/img/features/f-icon3.png" alt="">
						</div>
						<h6>Soporte 24/7</h6>
						<p>Seguimiento de pedidos 24/7</p>
					</div>
				</div>
				<!-- single features -->
				<div class="col-lg-3 col-md-6 col-sm-6">
					<div class="single-features">
						<div class="f-icon">
							<img src="Plantilla/img/features/f-icon4.png" alt="">
						</div>
						<h6>Pago seguro</h6>
						<p>Todos los métodos de pago seguros</p>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- end features Area -->

	<!-- start product Area -->
	<section class="owl-carousel active-product-area section_gap">
		<!-- REPEATER PADRE: Crea cada diapositiva (Slide) -->
		<asp:Repeater ID="rptSliderProductos" runat="server">
			<ItemTemplate>
				<div class="single-product-slider">
					<div class="container">
						<!-- Título de la sección (Se repite en cada slide) -->
						<div class="row justify-content-center">
							<div class="col-lg-6 text-center">
								<div class="section-title">
									<h1>Productos nuevos</h1>
									<p>¡Explora los nuevos componentes de última generación y arma tu PC ideal con las mejores ofertas de la temporada en TechParts!</p>
								</div>
							</div>
						</div>
						<!-- Fila de productos -->
						<div class="row">
							<!-- REPEATER HIJO: Pinta los 4 productos de este grupo -->
							<asp:Repeater ID="rptProdInterno" runat="server" DataSource='<%# Container.DataItem %>'>
								<ItemTemplate>
									<div class="col-lg-3 col-md-6">
										<div class="single-product">

											<asp:Panel ID="pnlOferta" runat="server" Visible='<%# Eval("Descuento").ToString() == "1" %>'>
												<div class="discount-badge" style="position:absolute; top:10px; left:10px; background:red; color:white; padding:3px 8px; border-radius:4px; font-size:12px; font-weight:bold; z-index:10;">
													<%# Eval("EtiquetaDescuento") %>
												</div>
											</asp:Panel>
											<img class="img-fluid" 
												 src='<%# Eval("Imagen") %>' 
												 alt='<%# Eval("Productos") %>'
												 style="height: 200px; object-fit: contain; width: 100%;"> 
											<div class="product-details">
												<h6><%# Eval("Productos") %></h6>
												<div class="price">
													<h6><%# Eval("CostoFinal", "{0:C}") %></h6>
													<span runat="server" visible='<%# Eval("Descuento").ToString() == "1" %>' 
														  style="text-decoration:line-through; color:#999; font-size:13px; margin-left:5px;">
														<%# Eval("Costo", "{0:C}") %>
													</span>
												</div>
												<div class="prd-bottom">
													<!-- Botón Agregar a Bolsa (Ejemplo pasando ID) -->
													<a href="frmIniciarSesion.aspx" class="social-info">
														<span class="ti-bag"></span>
														<p class="hover-text">A mi bolsa</p>
													</a>
													<a href="frmDetalleProducto.aspx?clave=<%# Eval("Clave") %>" class="social-info">
														<span class="lnr lnr-move"></span>
														<p class="hover-text">Ver más</p>
													</a>
												</div>
											</div>
										</div>
									</div>
								</ItemTemplate>
							</asp:Repeater>
							<!-- Fin Repeater Hijo -->
						</div>
					</div>
				</div>
			</ItemTemplate>
		</asp:Repeater>
		<!-- Fin Repeater Padre -->
	</section>
	<!-- end product Area -->


	<!-- Start exclusive deal Area -->
	<section class="exclusive-deal-area">
		<div class="container-fluid">
			<div class="row justify-content-center align-items-center">
				<div class="col-lg-6 no-padding exclusive-left">
					<div class="row clock_sec clockdiv" id="clockdiv">
						<div class="col-lg-12">
							<h1>¡Aprovecha nuestras ofertas exclusivas por tiempo limitado!</h1>
							<p>Equipa tu PC con los mejores componentes a precios especiales antes de que se agoten.</p>
						</div>
						<div class="col-lg-12">
							<div class="row clock-wrap">
								<div class="col clockinner1 clockinner">
									<h1 class="days">150</h1>
									<span class="smalltext">Días</span>
								</div>
								<div class="col clockinner clockinner1">
									<h1 class="hours">23</h1>
									<span class="smalltext">Horas</span>
								</div>
								<div class="col clockinner clockinner1">
									<h1 class="minutes">47</h1>
									<span class="smalltext">Minutos</span>
								</div>
								<div class="col clockinner clockinner1">
									<h1 class="seconds">59</h1>
									<span class="smalltext">Segundos</span>
								</div>
							</div>
						</div>
					</div>
					<a href="frmPromociones.aspx" class="primary-btn">Ir a comprar ahora</a>
				</div>
				<div class="col-lg-6 no-padding exclusive-right">
					<div id="divCarruselPromociones" runat="server" class="active-exclusive-product-slider">
						<asp:Repeater ID="rptPromociones" runat="server">
							<ItemTemplate>
								<div class="single-exclusive-slider">
									<img class="img-fluid" src='<%# Eval("Imagen") %>' alt='<%# Eval("Producto") %>'
										 style="max-height: 280px; object-fit: contain;">
									<div class="product-details">
										<div class="price">
											<h6><%# Eval("Precio_Final", "{0:C}") %></h6>
											<h6 class="l-through"><%# Eval("Precio_Original", "{0:C}") %></h6>
										</div>
										<h4><%# Eval("Producto") %></h4>
										<div class="add-bag d-flex align-items-center justify-content-center">
											<a class="add-btn" href="frmIniciarSesion.aspx"><span class="ti-bag"></span></a>
											<span class="add-text text-uppercase">A mi bolsa</span>
										</div>
									</div>
								</div>
							</ItemTemplate>
						</asp:Repeater>
					</div>
					<asp:Panel ID="pnlSinPromociones" runat="server" Visible="false">
						<div style="text-align: center; padding: 100px 20px; background: #fff; height: 100%;">
							<i class="lnr lnr-sad" style="font-size: 40px; color: #ccc;"></i>
							<h3 style="margin-top: 20px; color: #555;">Por el momento no hay ofertas activas.</h3>
							<p style="color: #777;">¡Mantente atento! Pronto publicaremos nuevos descuentos.</p>
							<a href="frmProductos.aspx" class="primary-btn mt-3">Ir al Catálogo de Productos</a>
						</div>
					</asp:Panel>
				</div>
			</div>
		</div>
	</section>
	<!-- End exclusive deal Area -->

	<!-- Start Brand Area (Estilo Product Area) -->
	<section class="owl-carousel active-product-area section_gap m-5">
		<!-- REPEATER EXTERNO: Genera los "Slides" (Grupos de 4) -->
		<asp:Repeater ID="rptSliderMarcas" runat="server">
			<ItemTemplate>
				<div class="single-product-slider">
					<div class="container">
						<!-- Título de la sección (Se repite en cada slide por diseño del template) -->
						<div class="row justify-content-center">
							<div class="col-lg-6 text-center">
								<div class="section-title">
									<h1>Nuestras Marcas</h1>
								</div>
							</div>
						</div>
						<!-- Fila de las marcas -->
						<div class="row">
							<!-- REPEATER INTERNO: Genera las 4 marcas dentro de este slide -->
							<asp:Repeater ID="rptItemsMarca" runat="server" DataSource='<%# Container.DataItem %>'>
								<ItemTemplate>
									<div class="col-lg-3 col-md-6">
										<div class="single-product">
											<!-- Enlace a productos de la marca -->
											<a class="d-block text-center">
												<img class="img-fluid" 
													 src='<%# Eval("Logo") %>' 
													 alt='<%# Eval("Marca") %>' 
													 style="max-height: 100px; max-width: 200px;"> <!-- Ajuste de estilo para logos -->
											</a>
										</div>
									</div>
								</ItemTemplate>
							</asp:Repeater>
							<!-- Fin Repeater Interno -->
						</div>
					</div>
				</div>
			</ItemTemplate>
		</asp:Repeater>
		<!-- Fin Repeater Externo -->
	</section>
	<!-- End Brand Area -->


</asp:Content>