<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="frmAdmPrincipal.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.Formulario_web1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- 1. REDUCCIÓN DE ESPACIOS EN BLANCO --- */
        .section_gap {
            padding: 30px 0 !important; 
        }
        /* Ajustes específicos para los carruseles para quitar margenes extra */
        .active-product-area {
            margin-top: 20px !important;
            margin-bottom: 20px !important;
        }
        /* --- 2. MOSAICO DE IMÁGENES Y OSCURECIMIENTO --- */
        .single-deal {
            position: relative;
            margin-bottom: 20px; /* Reduje el margen inferior entre cuadros */
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
        /* --- EL TRUCO: OSCURECER IMAGEN PARA LEER TEXTO --- */
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


    <!-- Start Banner Area -->
	<section class="banner-area organic-breadcrumb">
		<div class="container">
			<div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
				<div class="col-first">
					<h1>Bienvenid@!</h1>
					<h2><asp:Label ID="lblAdministrador" runat="server" Text="" ForeColor="White"></asp:Label></h2>
					<nav class="d-flex align-items-center">
						<a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
						<a href="frmAdmInformacion.aspx">Gestionar perfil</a>
					</nav>
				</div>
			</div>
		</div>
	</section>
	<!-- End Banner Area -->

	<!-- start banner Area -->
	<section>
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

    <!-- Start category Area -->
	<section class="category-area section_gap">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 col-md-12">
                    <div class="row">
                        <div class="col-lg-6 col-md-6">
                            <div class="single-deal">
                                <div class="overlay"></div>
                                <img class="img-fluid w-100 img-cover" src="../FOTOS/gestUsu.png" alt="">
                                <a href="frmAdmGestUsuarios.aspx">
                                    <div class="deal-details">
                                        <h6 class="deal-title">Gestión de Usuarios</h6>
                                    </div>
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6">
                            <div class="single-deal">
                                <div class="overlay"></div>
                                <img class="img-fluid w-100 img-cover" src="../FOTOS/gestProd.png" alt="">
                                <a href="frmAdmGestProductos.aspx">
                                    <div class="deal-details">
                                        <h6 class="deal-title">Gestión de Productos</h6>
                                    </div>
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6">
                            <div class="single-deal">
                                <div class="overlay"></div>
                                <img class="img-fluid w-100 img-cover" src="../FOTOS/gestProv.png" alt="">
                                <a href="frmAdmGestProveedores.aspx">
                                    <div class="deal-details">
                                        <h6 class="deal-title">Gestión de Proveedores</h6>
                                    </div>
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6">
                            <div class="single-deal">
                                <div class="overlay"></div>
                                <img class="img-fluid w-100 img-cover" src="../FOTOS/gestNoticias.png" alt="">
                                <a href="frmAdmGestNoticias.aspx">
                                    <div class="deal-details">
                                        <h6 class="deal-title">Gestión de Noticias</h6>
                                    </div>
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6">
                            <div class="single-deal">
                                <div class="overlay"></div>
                                <img class="img-fluid w-100 img-cover" src="../FOTOS/repoMasVendidos.png" alt="">
                                <a href="frmAdmRepoMasVendidos.aspx">
                                    <div class="deal-details">
                                        <h6 class="deal-title">Productos Más Vendidos</h6>
                                    </div>
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6">
                            <div class="single-deal">
                                <div class="overlay"></div>
                                <img class="img-fluid w-100 img-cover" src="../FOTOS/repoMenosVendidos.png" alt="">
                                <a href="frmAdmRepoMenosVendidos.aspx">
                                    <div class="deal-details">
                                        <h6 class="deal-title">Productos Menos Vendidos</h6>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-12">
                    <div class="row">
                        <div class="col-lg-12 col-md-6">
                            <div class="single-deal">
                                <div class="overlay"></div>
                                <img class="img-fluid w-100 img-cover" src="../FOTOS/gestInfo.png" alt="">
                                <a href="frmAdmInformacion.aspx">
                                    <div class="deal-details">
                                        <h6 class="deal-title">Mi Información</h6>
                                    </div>
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-12 col-md-6">
                            <div class="single-deal">
                                <div class="overlay"></div>
                                <img class="img-fluid w-100 img-cover" src="../FOTOS/repoInd.png" alt="">
                                <a href="frmAdmRepoIndividual.aspx">
                                    <div class="deal-details">
                                        <h6 class="deal-title">Ventas por Usuario</h6>
                                    </div>
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-12 col-md-6">
                            <div class="single-deal">
                                <div class="overlay"></div>
                                <img class="img-fluid w-100 img-cover" src="../FOTOS/repoGen.png" alt="">
                                <a href="frmAdmRepoGeneral.aspx">
                                    <div class="deal-details">
                                        <h6 class="deal-title">Ventas Diarias (General)</h6>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
	<!-- End category Area -->

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
