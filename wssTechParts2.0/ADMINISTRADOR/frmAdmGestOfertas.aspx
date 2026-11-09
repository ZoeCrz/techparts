<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="frmAdmGestOfertas.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.Formulario_web16" %>
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
        .form-group-item label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        /* --- INPUTS Y SELECTS --- */
        .input-icon-wrapper {
            position: relative;
            background-color: #f9f9f9;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            transition: all 0.3s ease;
        }
        .input-icon-wrapper:focus-within {
            border-color: #ffba00;
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(255, 186, 0, 0.1);
        }
        /* Icono */
        .input-icon-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #ffba00;
            font-size: 16px;
            pointer-events: none;
            transition: opacity 0.2s ease;
        }
        /* Input/Select */
        .form-group-item input,
        .form-group-item textarea,
        .form-group-item select {
            width: 100%;
            padding: 12px 15px;
            padding-left: 45px; /* Espacio para el icono */
            background-color: transparent !important; 
            border: none !important;
            border-radius: 4px;
            font-size: 14px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 45px;
            position: relative;
            cursor: pointer;
        }
        .form-group-item input:focus,
        .form-group-item select:focus {
            outline: none;
        }
        .form-group-item textarea { height: auto; }
        /* Clase para ocultar icono con JS */
        .icono-oculto {
            opacity: 0 !important;
            visibility: hidden !important;
        }
        /* --- BOTONES --- */
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
            color: #555; /* Color gris oscuro inicial */
            padding: 14px 40px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none !important; /* Quita subrayado forzosamente */
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .btn-cancel:hover {
            background: #efefef;
            border-color: #ccc;
            color: #333 !important; /* Forzamos color gris más oscuro al hover, NUNCA AZUL */
            text-decoration: none !important;
        }
        @media (max-width: 768px) {
            .form-group-wrapper { grid-template-columns: 1fr; }
            .button-group { flex-direction: column; }
            .btn-submit, .btn-cancel { width: 100%; }
        }
    </style>

    <script type="text/javascript">
        // 1. Script para ocultar iconos al abrir dropdowns
        document.addEventListener("DOMContentLoaded", function () {
            var dropDowns = document.querySelectorAll('.input-icon-wrapper select');
            dropDowns.forEach(function (ddl) {
                ddl.addEventListener('focus', function () {
                    var icon = this.parentElement.querySelector('i');
                    if (icon) icon.classList.add('icono-oculto');
                });
                ddl.addEventListener('blur', function () {
                    var icon = this.parentElement.querySelector('i');
                    if (icon) icon.classList.remove('icono-oculto');
                });
                ddl.addEventListener('change', function () { this.blur(); });
            });
        });
        // 2. Validación de Descuentos
        function validarDescuento() {
            var ddlTipo = document.getElementById('<%= ddlTipo.ClientID %>');
            var txtDescuento = document.getElementById('<%= txtDescuento.ClientID %>');
            var hfPrecio = document.getElementById('<%= hfPrecioProducto.ClientID %>');

            var tipo = ddlTipo.value;
            var descuento = parseFloat(txtDescuento.value);
            var precioProducto = parseFloat(hfPrecio.value);

            if (isNaN(descuento) || descuento <= 0) {
                alert("Por favor ingrese un valor de descuento válido.");
                return false;
            }
            if (tipo === "Porcentaje" && descuento > 100) {
                alert("El porcentaje no puede ser mayor al 100%.");
                txtDescuento.value = ""; txtDescuento.focus(); return false;
            }
            if (tipo === "MontoFijo") {
                if (isNaN(precioProducto) || precioProducto === 0) {
                    alert("Seleccione primero un producto válido."); return false;
                }
                if (descuento >= precioProducto) {
                    alert("El descuento ($" + descuento + ") no puede superar el precio ($" + precioProducto + ").");
                    txtDescuento.value = ""; txtDescuento.focus(); return false;
                }
            }
            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <section class="banner-area organic-breadcrumb">
        <div class="container">
            <div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
                <div class="col-first">
                    <h1>Gestión de ofertas</h1>
                    <nav class="d-flex align-items-center">
                        <a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
                        <a href="frmAdmGestProductos.aspx">Gestión de productos<span class="lnr lnr-arrow-right"></span></a>
                        <a href="#">Nueva oferta</a>
                    </nav>
                </div>
            </div>
        </div>
    </section>

    <section class="contact-page-area section-gap" style="background: #f5f5f5;">
        <div class="container">
            <div class="form-section">
                <h3>Registrar Oferta Especial</h3>
                <asp:HiddenField ID="hfIdPromocion" runat="server" Value="0" />
                <asp:HiddenField ID="hfPrecioProducto" runat="server" Value="0" />
                <div class="form-group-wrapper full">
                    <div class="form-group-item">
                        <label>Seleccionar Producto</label>
                        <div class="input-icon-wrapper">
                            <asp:DropDownList ID="ddlProductos" runat="server" 
                                AutoPostBack="true" 
                                OnSelectedIndexChanged="ddlProductos_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="form-group-wrapper full">
                    <div class="form-group-item">
                        <label>Título de la Promoción</label>
                        <div class="input-icon-wrapper">
                            <i class="fa fa-tag"></i>
                            <asp:TextBox ID="txtTitulo" runat="server" placeholder="Ej. Black Friday..."></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="form-group-wrapper full">
                    <div class="form-group-item">
                        <label>Descripción</label>
                        <div class="input-icon-wrapper">
                            <i class="fa fa-align-left"></i>
                            <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="3" placeholder="Detalles de la oferta"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="form-group-wrapper">
                    <div class="form-group-item">
                        <label>Tipo de Descuento</label>
                        <div class="input-icon-wrapper">
                            <asp:DropDownList ID="ddlTipo" runat="server">
                                <asp:ListItem Value="Porcentaje">Porcentaje (%)</asp:ListItem>
                                <asp:ListItem Value="MontoFijo">Monto Fijo ($)</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group-item">
                        <label>Valor Descuento</label>
                        <div class="input-icon-wrapper">
                            <i class="fa fa-money"></i>
                            <asp:TextBox ID="txtDescuento" runat="server" TextMode="Number" placeholder="Ej: 15"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="form-group-wrapper">
                    <div class="form-group-item">
                        <label>Fecha Inicio</label>
                        <div class="input-icon-wrapper">
                            <i class="fa fa-calendar"></i>
                            <asp:TextBox ID="txtFechaInicio" runat="server" TextMode="Date"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group-item">
                        <label>Fecha Fin</label>
                        <div class="input-icon-wrapper">
                            <i class="fa fa-calendar-check-o"></i>
                            <asp:TextBox ID="txtFechaFin" runat="server" TextMode="Date"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="form-group-wrapper full">
                    <div class="form-group-item">
                        <label>Banner Promocional (Opcional)</label>
                        <div style="display: flex; flex-direction: column; align-items: center; gap: 15px; margin-top: 10px;">
                            <asp:Image ID="imgBanner" runat="server" 
                                ImageUrl="../FOTOS/BANNERS/default.jpg" 
                                Width="300px" Height="150px" 
                                style="border-radius: 8px; border: 2px solid #e0e0e0; object-fit: cover;" />
                            <div style="width: 100%; max-width: 500px;">
                                <asp:FileUpload ID="fuBanner" runat="server" 
                                    CssClass="form-control" 
                                    accept="image/*"
                                    style="margin-bottom: 10px; padding: 10px;" />
                                <asp:Button ID="btnSubirImagen" runat="server" 
                                    Text="Subir Imagen" 
                                    CssClass="btn-submit" 
                                    OnClick="btnSubirImagen_Click"
                                    style="padding: 10px 25px; font-size: 13px; width: 100%; margin-bottom:5px;" />
                                <p style="font-size: 12px; color: #999; margin-top: 5px; margin-bottom: 0; text-align: center;">
                                    Formatos: JPG, PNG (máx. 5MB)
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="button-group">
                    <asp:Button ID="btnGuardarPromo" runat="server" Text="Guardar Oferta" 
                        CssClass="btn-submit" 
                        OnClientClick="return validarDescuento();" 
                        OnClick="btnGuardarPromo_Click" />
                    <a href="frmAdmGestProductos.aspx" class="btn-cancel">Cancelar</a>
                </div>
            </div>
        </div>
    </section>


</asp:Content>