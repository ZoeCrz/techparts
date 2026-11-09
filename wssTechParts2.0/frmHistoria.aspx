<%@ Page Title="" Language="C#" MasterPageFile="~/mpPrincipal.Master" AutoEventWireup="true" CodeBehind="frmHistoria.aspx.cs" Inherits="wssTechParts2._0.Formulario_web15" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .history-wrapper {
            padding: 60px 0;
            background: #f9f9ff; /* Fondo muy suave para diferenciar del blanco puro */
            font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }
        /* TARJETAS (Card Style) */
        .history-card {
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
            padding: 40px;
            margin-bottom: 30px;
            border: 1px solid #eee;
        }
        /* --- CONTENIDO PRINCIPAL --- */
        .history-logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .history-logo img {
            max-width: 220px; /* Un poco más grande para presencia de marca */
            height: auto;
        }
        .history-title {
            font-size: 32px;
            font-weight: 800;
            color: #222;
            margin-bottom: 20px;
            line-height: 1.2;
        }
        .history-text p {
            font-size: 16px;
            color: #555;
            line-height: 1.8; /* Mejor legibilidad */
            margin-bottom: 20px;
            text-align: justify;
        }
        /* CITA DESTACADA (MISSION STATEMENT) */
        .history-quote {
            background: #fff8e1; /* Amarillo muy suave */
            border-left: 5px solid #ffba00; /* Color primario */
            border-radius: 4px;
            padding: 25px 30px;
            font-size: 18px;
            font-style: italic;
            color: #444;
            font-weight: 500;
            margin: 30px 0;
            position: relative;
        }
        .history-quote::before {
            content: '"';
            font-size: 60px;
            color: #ffba00;
            opacity: 0.3;
            position: absolute;
            top: -10px;
            left: 10px;
        }
        /* GALERÍA DE IMÁGENES */
        .history-images {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin: 30px 0;
        }
        .history-images img {
            width: 100%;
            height: 200px; /* Altura fija para uniformidad */
            border-radius: 8px;
            object-fit: cover;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .history-images img:hover {
            transform: scale(1.02);
        }
        /* --- SIDEBAR (EQUIPO) --- */
        .sidebar-profile {
            text-align: center;
        }
        .sidebar-profile img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }
        .sidebar-title {
            font-size: 20px;
            font-weight: 700;
            color: #222;
            margin-bottom: 5px;
        }
        .sidebar-subtitle {
            font-size: 14px;
            color: #ffba00; /* Color de marca */
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 15px;
            display: block;
        }
        .sidebar-text {
            font-size: 14px;
            color: #666;
            line-height: 1.6;
        }
        /* RESPONSIVE */
        @media (max-width: 768px) {
            .history-card { padding: 25px; }
            .history-title { font-size: 26px; }
            .history-images { grid-template-columns: 1fr; } /* Una columna en móvil */
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1>Nuestra Historia</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="#">Conócenos</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <section class="history-wrapper">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <div class="history-card">
                        <div class="history-logo">
                            <img src="../FOTOS/logoTP.png" alt="TechParts Logo" class="img-fluid" />
                        </div>
                        <div class="history-text">
                            <h2 class="history-title">TechParts: Tu PC ideal, al alcance de un clic.</h2>
                            <p>
                                <strong>TechParts</strong> nació con una misión clara: revolucionar la forma en que las personas adquieren tecnología. 
                                Nos dimos cuenta de que armar una computadora personalizada solía ser un proceso intimidante, lleno de dudas sobre 
                                compatibilidad y precios excesivos en tiendas tradicionales. Queríamos cambiar eso.
                            </p>
                            <p>
                                Creamos una plataforma intuitiva pensada tanto para entusiastas del hardware como para quienes arman su primera PC. 
                                En TechParts, eliminamos la complejidad del proceso, ofreciendo un catálogo curado de procesadores, tarjetas gráficas, 
                                motherboards y periféricos, garantizando calidad y compatibilidad en cada componente.
                            </p>
                        </div>
                        <div class="history-quote">
                            "Creemos que la tecnología debe ser accesible para todos. En TechParts no solo vendemos componentes, 
                            entregamos la herramienta para que construyas tus sueños, ya sea para jugar, trabajar o crear."
                        </div>

                        <div class="history-images" style="margin-bottom: 0;">
                            <img src="../FOTOS/altaGama.png" alt="Hardware de alta gama" />
                            <img src="../FOTOS/armado.png" alt="Experiencia de armado" />
                        </div>

                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="history-card sidebar-profile">
                        <h4 class="sidebar-title">El Equipo TechParts</h4>
                        <span class="sidebar-subtitle">Apasionados por el Hardware</span>
                        <p class="sidebar-text">
                            Somos un grupo de ingenieros y entusiastas de la tecnología dedicados a simplificar el mundo del hardware para ti.
                        </p>
                        <div style="margin-top: 20px;">
                            <a href="frmContacto.aspx" class="genric-btn primary small" style="border-radius: 30px;">Contáctanos</a>
                        </div>
                    </div>
                    <div class="history-card" style="padding: 30px;">
                        <h5 style="font-weight: 700; margin-bottom: 15px; color:#222;">Nuestros Valores</h5>
                        <ul class="unordered-list sidebar-text">
                            <li>Innovación constante</li>
                            <li>Transparencia en precios</li>
                            <li>Pasión por el servicio</li>
                            <li>Calidad garantizada</li>
                        </ul>
                    </div>
                    <div class="history-card" style="padding: 30px; background-color: #fffbf0; border: 1px solid #ffeec2;">
                        <h5 style="font-weight: 700; margin-bottom: 15px; color:#ffba00;">Nuestro Compromiso</h5>
                        <div class="sidebar-text" style="text-align: justify;">
                            <p style="margin-bottom: 10px;">
                                Más que una tienda en línea, somos tus aliados tecnológicos. Nos esforzamos día a día por ofrecerte la mejor 
                                relación calidad-precio del mercado y envíos seguros a todo México.
                            </p>
                            <p style="margin-bottom: 0;">
                                Ya sea que necesites una estación de trabajo o tu primera PC Gamer, en <strong>TechParts</strong> 
                                encuentras las piezas exactas para hacerlo realidad.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>


</asp:Content>