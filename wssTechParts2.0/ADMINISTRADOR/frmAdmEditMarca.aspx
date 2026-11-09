<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="WebForm3.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.WebForm3" %>
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
        .form-group-wrapper.full {
            grid-template-columns: 1fr;
        }
        .form-group-item { position: relative; }
        .form-group-item label {
            display: block; font-size: 13px; font-weight: 600; color: #555; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .form-group-item input, .form-group-item textarea {
            width: 100%; padding: 12px 15px; border: 1px solid #e0e0e0; border-radius: 4px; font-size: 14px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; transition: all 0.3s ease; background-color: #f9f9f9;
        }
        .form-group-item input:focus, .form-group-item textarea:focus {
            outline: none; border-color: #ffba00; background-color: #fff; box-shadow: 0 0 0 3px rgba(255, 186, 0, 0.1);
        }
        .input-icon-wrapper { position: relative; }
        .input-icon-wrapper i {
            position: absolute; left: 15px; top: 70%; transform: translateY(-50%); color: #ffba00; font-size: 16px; pointer-events: none;
        }
        .input-icon-wrapper input { padding-left: 45px; }
        .button-group {
            display: flex; gap: 15px; margin-top: 40px; justify-content: flex-start;
        }
        .btn-submit {
            background: linear-gradient(135deg, #ffba00 0%, #e5a800 100%);
            color: #fff; padding: 14px 40px; border: none; border-radius: 4px; font-size: 14px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(255, 186, 0, 0.3);
        }
        .btn-submit:hover {
            background: linear-gradient(135deg, #e5a800 0%, #cc8f00 100%); box-shadow: 0 6px 20px rgba(255, 186, 0, 0.4); transform: translateY(-2px);
        }
        .btn-cancel {
            background: #f5f5f5; color: #555; padding: 14px 40px; border: 1px solid #e0e0e0; border-radius: 4px; font-size: 14px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; cursor: pointer; transition: all 0.3s ease; text-decoration: none; display: inline-block; text-align:center;
        }
        .btn-cancel:hover { background: #efefef; border-color: #ccc; color: #333; }
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
                    <h1>Editar marca</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmAdmGestProveedores.aspx">Gestión de marcas<span class="lnr lnr-arrow-right"></span></a>
                        <a href="#">Editar marca</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <section class="contact-page-area section-gap" style="background: #f5f5f5;">
        <div class="container">
            <div class="form-section">
                <h3>Editar datos de la marca</h3>
                <div class="form-group-wrapper">
                    <div class="form-group-item input-icon-wrapper">
                        <label>Nombre de Marca</label>
                        <i class="fa fa-tag"></i>
                        <asp:TextBox ID="txtNombre" runat="server" placeholder="Nombre de la marca"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group-wrapper full">
                    <div class="form-group-item">
                        <label>Logo de Marca * (Obligatorio)</label>
                        <div style="display: flex; flex-direction: column; align-items: center; gap: 15px; margin-top: 10px;">
                            <asp:Image ID="imgLogo" runat="server" 
                                ImageUrl="../FOTOS/MARCAS/default.png" 
                                Width="200px" 
                                Height="200px" 
                                style="border-radius: 8px; border: 2px solid #e0e0e0; object-fit: contain; background: #fff;" />
                            <div style="width: 100%; max-width: 500px;">
                                <asp:FileUpload ID="fuLogo" runat="server" 
                                    accept="image/*"
                                    style="margin-bottom: 10px;" />
                                <asp:Button ID="btnSubirLogo" runat="server" 
                                    Text="Previsualizar Logo" 
                                    CssClass="btn-submit" 
                                    OnClick="btnSubirLogo_Click"
                                    style="padding: 10px 25px; font-size: 13px; width: 100%;" />
                                <p style="font-size: 12px; color: #999; margin-top: 8px; margin-bottom: 0; text-align: center;">
                                    Formatos: JPG, PNG, GIF (máx. 5MB)
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="button-group">
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar Cambios" CssClass="btn-submit" OnClick="btnGuardar_Click" />
                    <a href="frmAdmGestProveedores.aspx" class="btn-cancel">Cancelar</a>
                </div>
            </div>
        </div>
    </section>


</asp:Content>