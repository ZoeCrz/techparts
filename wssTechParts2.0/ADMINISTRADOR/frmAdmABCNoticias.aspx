<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="frmAdmABCNoticias.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.Formulario_web110" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-section {
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            padding: 40px;
            margin-bottom: 30px;
        }
        .form-section h3 {
            font-size: 28px;
            font-weight: 600;
            color: #333;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #ffba00;
        }
        .form-group-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }
        .form-group-wrapper.full { grid-template-columns: 1fr; }
        .form-group-item { position: relative; }
        .form-group-item label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .form-group-item input,
        .form-group-item textarea {
            width: 100%;
            padding: 12px 15px;
            padding-left: 45px; /* Espacio para el icono */
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
        }
        .form-group-item input:focus,
        .form-group-item textarea:focus {
            outline: none;
            border-color: #ffba00;
            background-color: #fff;
            box-shadow: 0 0 0 3px rgba(255, 186, 0, 0.1);
        }
        /* Iconos */
        .input-icon-wrapper i {
            position: absolute;
            left: 15px;
            top: 47px; /* Ajuste vertical */
            color: #ffba00;
            font-size: 16px;
            pointer-events: none;
        }
        /* Botones */
        .button-group {
            display: flex; gap: 15px; margin-top: 40px; justify-content: flex-start;
        }
        .btn-submit {
            background: linear-gradient(135deg, #ffba00 0%, #e5a800 100%);
            color: #fff; padding: 14px 40px; border: none; border-radius: 4px;
            font-size: 14px; font-weight: 600; text-transform: uppercase;
            cursor: pointer; box-shadow: 0 4px 15px rgba(255, 186, 0, 0.3); transition: 0.3s;
        }
        .btn-submit:hover {
            background: linear-gradient(135deg, #e5a800 0%, #cc8f00 100%);
            transform: translateY(-2px);
        }
        .btn-cancel {
            background: #f5f5f5;
            color: #555; /* Gris inicial */
            padding: 14px 40px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none !important; /* Sin subrayado */
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .btn-cancel:hover {
            background: #efefef;
            border-color: #ccc;
            /* Forzamos el color gris oscuro al hacer hover */
            color: #333 !important; 
            text-decoration: none !important;
        }
        @media (max-width: 768px) {
            .form-group-wrapper { grid-template-columns: 1fr; }
            .button-group { flex-direction: column; }
            .btn-submit, .btn-cancel { width: 100%; }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1><asp:Label ID="lblTituloPagina" runat="server" Text="Registro de nueva noticia"></asp:Label></h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmAdmGestNoticias.aspx">Noticias<span class="lnr lnr-arrow-right"></span></a>
                        <a href="#">Nueva noticia</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <section class="contact-page-area section-gap" style="background: #f5f5f5;">
        <div class="container">
            <div class="form-section">
                <h3>Información de la Noticia</h3>
                <div class="form-group-wrapper full">
                    <div class="form-group-item input-icon-wrapper">
                        <label>Título del Artículo</label>
                        <i class="fa fa-header"></i>
                        <asp:TextBox ID="txtTitulo" runat="server" placeholder="Ej: Lanzamiento de nuevas RTX 5090"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group-wrapper full">
                    <div class="form-group-item input-icon-wrapper">
                        <label>Contenido</label>
                        <i class="fa fa-align-left"></i>
                        <asp:TextBox ID="txtContenido" runat="server" TextMode="MultiLine" Rows="6" placeholder="Escribe aquí el cuerpo de la noticia..."></asp:TextBox>
                    </div>
                </div>
                <div class="form-group-wrapper full">
                    <div class="form-group-item input-icon-wrapper">
                        <label>URL Externa (Opcional)</label>
                        <i class="fa fa-link"></i>
                        <asp:TextBox ID="txtURL" runat="server" placeholder="Ej: https://techparts.mx/promo-especial"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group-wrapper full">
                    <div class="form-group-item">
                        <label>Imagen de Portada</label>
                        <div style="display: flex; flex-direction: column; align-items: center; gap: 15px; margin-top: 10px;">
                            <asp:Image ID="imgNoticia" runat="server" 
                                ImageUrl="../NOTICIAS/default.jpg" 
                                Width="300px" Height="150px" 
                                style="border-radius: 8px; border: 2px solid #e0e0e0; object-fit: cover;" />
                            <div style="width: 100%; max-width: 500px;">
                                <asp:FileUpload ID="fuImagen" runat="server" CssClass="form-control" accept="image/*" style="margin-bottom: 10px; padding:10px;" />
                                <asp:Button ID="btnSubirImagen" runat="server" 
                                    Text="Subir Imagen" 
                                    CssClass="btn-submit" 
                                    OnClick="btnSubirImagen_Click"
                                    style="padding: 10px 25px; font-size: 13px; width: 100%;" />
                                <p style="font-size: 12px; color: #999; margin-top: 8px; margin-bottom: 0; text-align: center;">
                                    Formatos: JPG, PNG (máx. 5MB)
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="button-group">
                    <asp:Button ID="btnGuardar" runat="server" Text="Publicar Noticia" CssClass="btn-submit" OnClick="btnGuardar_Click" />
                    <a href="frmAdmGestNoticias.aspx" class="btn-cancel">Cancelar</a>
                </div>
            </div>
        </div>
    </section>


</asp:Content>