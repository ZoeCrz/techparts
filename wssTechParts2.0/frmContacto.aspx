<%@ Page Title="" Language="C#" MasterPageFile="~/mpPrincipal.Master" AutoEventWireup="true" CodeBehind="frmContacto.aspx.cs" Inherits="wssTechParts2._0.Formulario_web18" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Mapa Google Maps Real */
        .map-container {
            width: 100%;
            height: 350px; /* Altura del mapa */
            background: #eee;
            border-radius: 8px; /* Bordes redondeados */
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1); /* Sombra suave */
        }
        .map-container iframe {
            width: 100%;
            height: 100%;
            border: 0;
        }
        /* Títulos de secciones en la info */
        .contact-header {
            font-size: 18px;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            margin-top: 10px;
            border-bottom: 2px solid #ffba00;
            display: inline-block;
            padding-bottom: 5px;
        }
        /* Íconos de Información (Izquierda) */
        .contact_info .info_item {
            position: relative;
            padding-left: 45px;
            margin-bottom: 25px; /* Un poco más de espacio */
        }
        .contact_info .info_item i {
            position: absolute; left: 0; top: 0;
            font-size: 20px; color: #ffba00;
        }
        .contact_info .info_item h6 {
            font-size: 15px; color: #222; margin-bottom: 2px; font-weight: 600;
        }
        .contact_info .info_item p {
            font-size: 13px; color: #777; margin-bottom: 0; line-height: 1.5;
        }
        /* Links en la info para que se noten */
        .contact_info a { color: #444; transition: 0.3s; }
        .contact_info a:hover { color: #ffba00; }
        /* Formulario (Derecha) */
        .contact_form { padding-top: 10px; }
        .contact_form .form-group { margin-bottom: 20px; }
        /* Inputs */
        .form-control {
            border: 1px solid #ced4da;
            border-radius: 0px;
            font-size: 13px;
            padding: 10px 15px;
            height: 45px; /* Un poco más altos para verse modernos */
        }
        .form-control:focus {
            box-shadow: none; border-color: #ffba00;
        }
        textarea.form-control {
            height: 180px !important; resize: none;
        }
        /* Botón */
        .primary-btn {
            background: #ffba00; color: #fff; border: none; border-radius: 0;
            padding: 3px 27px; font-weight: 700; text-transform: uppercase;
            cursor: pointer; transition: all 0.3s ease; font-size: 13px; letter-spacing: 1px;
        }
        .primary-btn:hover { background: #e6a800; color: #fff; }
        .text-right { text-align: right !important; }
        /* Lista de servicios */
        .services-list { list-style: none; padding-left: 0; margin-top: 10px; }
        .services-list li {
            position: relative; padding-left: 20px; margin-bottom: 8px; font-size: 13px; color: #666;
        }
        .services-list li::before {
            content: "•"; color: #ffba00; font-weight: bold; position: absolute; left: 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1>Contáctanos</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmContacto.aspx">Contacto</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <section class="contact_area section_gap_bottom">
        <div class="container">
            <div class="row mb-5">
                <div class="col-md-6 mb-4 mb-md-0">
                    <div class="map-container">
                        <iframe 
                            src="https://maps.google.com/maps?q=20.09824302572352,-98.76841138449747&z=17&output=embed" 
                            width="100%" 
                            height="100%" 
                            style="border:0;" 
                            allowfullscreen="" 
                            loading="lazy">
                        </iframe>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="map-container">
                        <iframe 
                            src="https://maps.google.com/maps?q=19.946440427447847,-98.89005799512402&z=17&output=embed" 
                            width="100%" 
                            height="100%" 
                            style="border:0;" 
                            allowfullscreen="" 
                            loading="lazy">
                        </iframe>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-5 pr-lg-5">
                    <div class="contact_info">
                        <h4 class="contact-header">Nuestras Sucursales</h4>
                        <div class="info_item">
                            <i class="lnr lnr-home"></i>
                            <h6>Galerías Pachuca (Local C-67)</h6>
                            <p>Camino Real de La Plata 102, Zona Plateada, 42083<br>Pachuca de Soto, Hgo.</p>
                        </div>
                        <div class="info_item">
                            <i class="lnr lnr-store"></i>
                            <h6>Sucursal Tolcayuca</h6>
                            <p>Ex Hacienda San Javier, Tolcayuca 1009, 43860<br>Tolcayuca, Hgo.</p>
                        </div>
                        <h4 class="contact-header mt-4">Equipo de Atención</h4>
                        <div class="info_item">
                            <i class="lnr lnr-user"></i>
                            <h6>Zoe Yeray Cruz Cruz (Ventas)</h6>
                            <p>Contacto pendiente de configurar</p>
                        </div>
                        <div class="info_item">
                            <i class="lnr lnr-user"></i>
                            <h6>Fernando H. (Cotizaciones)</h6>
                            <p>Contacto pendiente de configurar</p>
                        </div>
                        <div class="info_item">
                            <i class="lnr lnr-laptop"></i>
                            <h6>Irving A. (Soporte Técnico)</h6>
                            <p>Contacto pendiente de configurar</p>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7">
                    <h3 class="mb-4">Envíanos un mensaje</h3>
                    <p class="mb-4 text-muted">¿Tienes dudas sobre disponibilidad o necesitas una cotización personalizada? Escríbenos y te responderemos a la brevedad.</p>
                    <div class="row contact_form">
                        <div class="col-md-6">
                            <div class="form-group">
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Tu nombre completo"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Tu correo electrónico"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:TextBox ID="txtAsunto" runat="server" CssClass="form-control" placeholder="Asunto del mensaje"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <asp:TextBox ID="txtMensaje" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="1" placeholder="Escribe tu mensaje aquí..."></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-12 text-right">
                            <asp:Button ID="btnEnviarMensaje" runat="server" Text="Enviar Mensaje" CssClass="primary-btn" OnClick="btnEnviarMensaje_Click" />
                        </div>
                        <div class="mt-4">
                            <h6><i class="lnr lnr-cog text-warning mr-2"></i> Servicios en tienda:</h6>
                            <ul class="services-list">
                                <li>Asesoría para armado de PC gamer y profesional.</li>
                                <li>Recomendación de compatibilidad de hardware.</li>
                                <li>Instalación de componentes.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>


</asp:Content>