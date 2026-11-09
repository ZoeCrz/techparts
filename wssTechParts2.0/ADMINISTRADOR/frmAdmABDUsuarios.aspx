<%@ Page Title="" Language="C#" MasterPageFile="~/ADMINISTRADOR/mpAdministrador.Master" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="wssTechParts2._0.ADMINISTRADOR.WebForm1" %>
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
		.form-group-item {
			position: relative;
		}
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
		.form-group-item input::placeholder,
		.form-group-item textarea::placeholder {
			color: #999;
		}
		.input-icon-wrapper {
			position: relative;
		}
		.input-icon-wrapper i {
			position: absolute;
			left: 15px;
			top: 70%;
			transform: translateY(-50%);
			color: #ffba00;
			font-size: 16px;
			pointer-events: none;
		}
		.input-icon-wrapper input {
			padding-left: 45px;
		}
		.form-section-divider {
			display: flex;
			align-items: center;
			margin: 40px 0;
			gap: 15px;
		}
		.form-section-divider .line {
			flex: 1;
			height: 1px;
			background: #e0e0e0;
		}
		.form-section-divider span {
			color: #999;
			font-size: 12px;
			text-transform: uppercase;
			font-weight: 600;
		}
		.button-group {
			display: flex;
			gap: 15px;
			margin-top: 40px;
			justify-content: flex-start;
		}
		.btn-submit {
			background: linear-gradient(135deg, #ffba00 0%, #e5a800 100%);
			color: #fff;
			padding: 14px 40px;
			border: none;
			border-radius: 4px;
			font-size: 14px;
			font-weight: 600;
			text-transform: uppercase;
			letter-spacing: 0.5px;
			cursor: pointer;
			transition: all 0.3s ease;
			box-shadow: 0 4px 15px rgba(255, 186, 0, 0.3);
		}
		.btn-submit:hover {
			background: linear-gradient(135deg, #e5a800 0%, #cc8f00 100%);
			box-shadow: 0 6px 20px rgba(255, 186, 0, 0.4);
			transform: translateY(-2px);
		}
		.btn-submit:active {
			transform: translateY(0);
			box-shadow: 0 2px 10px rgba(255, 186, 0, 0.3);
		}
		.btn-cancel {
			background: #f5f5f5;
			color: #555;
			padding: 14px 40px;
			border: 1px solid #e0e0e0;
			border-radius: 4px;
			font-size: 14px;
			font-weight: 600;
			text-transform: uppercase;
			letter-spacing: 0.5px;
			cursor: pointer;
			transition: all 0.3s ease;
		}
		.btn-cancel:hover {
			background: #efefef;
			border-color: #ccc;
		}
		@media (max-width: 768px) {
			.form-group-wrapper {
				grid-template-columns: 1fr;
			}
			.form-section {
				padding: 25px;
			}
			.button-group {
				flex-direction: column;
			}
			.btn-submit,
			.btn-cancel {
				width: 100%;
			}
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


	<!-- Start Banner Area -->
	<section class="banner-area organic-breadcrumb">
		<div class="container">
			<div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
				<div class="col-first">
					<h1>Información del usuario</h1>
					<nav class="d-flex align-items-center">
						<a href="frmAdmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
						<a href="frmAdmGestUsuarios.aspx">Gestión de usuarios<span class="lnr lnr-arrow-right"></span></a>
						<a href="frmAdmABDUsuarios.aspx">Información del usuario</a>
					</nav>
				</div>
			</div>
		</div>
	</section>
	<!-- End Banner Area -->

	<!-- Start Contact Info Section -->
	<section class="contact-page-area section-gap" style="background: #f5f5f5;">
		<div class="container">
			<div class="form-section">
				<h3>Actualizar Mi Información</h3>
				<div class="form-group-wrapper">
					<div class="form-group-item input-icon-wrapper">
						<label>Nombre</label>
						<i class="fa fa-user"></i>
						<asp:TextBox ID="txtNombre" runat="server" placeholder="Ingrese su nombre completo"></asp:TextBox>
					</div>
					<div class="form-group-item input-icon-wrapper">
						<label>Apellido Paterno</label>
						<i class="fa fa-user"></i>
						<asp:TextBox ID="txtApPaterno" runat="server" placeholder="Apellido paterno"></asp:TextBox>
					</div>
				</div>
				<div class="form-group-wrapper">
					<div class="form-group-item input-icon-wrapper">
						<label>Apellido Materno</label>
						<i class="fa fa-user"></i>
						<asp:TextBox ID="txtApMaterno" runat="server" placeholder="Apellido materno"></asp:TextBox>
					</div>
					<div class="form-group-item input-icon-wrapper">
						<label>Correo Electrónico</label>
						<i class="fa fa-envelope"></i>
						<asp:TextBox ID="txtEmail" runat="server" placeholder="ejemplo@correo.com" TextMode="Email"></asp:TextBox>
					</div>
				</div>
				<div class="form-group-wrapper">
					<div class="form-group-item input-icon-wrapper">
						<label>Teléfono</label>
						<i class="fa fa-phone"></i>
						<asp:TextBox ID="txtTelefono" runat="server" placeholder="Número de teléfono" MaxLength="12"></asp:TextBox>
					</div>
					<div class="form-group-item input-icon-wrapper">
						<label>Calle</label>
						<i class="fa fa-road"></i>
						<asp:TextBox ID="txtCalle" runat="server" placeholder="Nombre de la calle"></asp:TextBox>
					</div>
				</div>
				<div class="form-group-wrapper">
					<div class="form-group-item input-icon-wrapper">
						<label>Número</label>
						<i class="fa fa-home"></i>
						<asp:TextBox ID="txtNumero" runat="server" placeholder="Número de domicilio"></asp:TextBox>
					</div>
					<div class="form-group-item input-icon-wrapper">
						<label>Colonia</label>
						<i class="fa fa-map-signs"></i>
						<asp:TextBox ID="txtColonia" runat="server" placeholder="Nombre de la colonia"></asp:TextBox>
					</div>
				</div>
				<div class="form-group-wrapper">
					<div class="form-group-item input-icon-wrapper">
						<label>Ciudad</label>
						<i class="fa fa-building"></i>
						<asp:TextBox ID="txtCiudad" runat="server" placeholder="Nombre de la ciudad"></asp:TextBox>
					</div>
					<div class="form-group-item input-icon-wrapper">
						<label>Municipio</label>
						<i class="fa fa-map"></i>
						<asp:TextBox ID="txtMunicipio" runat="server" placeholder="Nombre del municipio"></asp:TextBox>
					</div>
				</div>
				<div class="form-group-wrapper">
					<div class="form-group-item input-icon-wrapper">
						<label>Estado</label>
						<i class="fa fa-globe"></i>
						<asp:TextBox ID="txtEstado" runat="server" placeholder="Nombre del estado"></asp:TextBox>
					</div>
					<div class="form-group-item input-icon-wrapper">
						<label>Código Postal</label>
						<i class="fa fa-map-pin"></i>
						<asp:TextBox ID="txtCP" runat="server" placeholder="Código postal"></asp:TextBox>
					</div>
				</div>
				<!-- Divider -->
				<div class="form-section-divider">
					<div class="line"></div>
					<span>Datos de Cuenta</span>
					<div class="line"></div>
				</div>
				<!-- Sección de Datos de Cuenta: Usuario/Contraseña y Foto -->
				<div class="form-group-wrapper">
					<!-- Lado Izquierdo: Usuario y Contraseña -->
					<div class="form-group-item">
						<div class="input-icon-wrapper" style="margin-bottom: 15px;">
							<label>Usuario</label>
							<i class="fa fa-user-circle"></i>
							<asp:TextBox ID="txtUsuario" runat="server" placeholder="Nombre de usuario" 
								ReadOnly="true" style="background-color: #f0f0f0;"></asp:TextBox>
						</div>
						<div class="input-icon-wrapper">
							<label>Contraseña Actual</label>
							<i class="fa fa-lock"></i>
							<asp:TextBox ID="txtContrasena" ToolTip="Nueva contraseña (12 a 128 caracteres). Deja ambos campos vacíos para conservarla." runat="server" placeholder="Contraseña" 
								 style="background-color: #fff;" ReadOnly="false"></asp:TextBox>
						</div>
						<div class="input-icon-wrapper">
							<label>Confirmar contraseña</label>
							<i class="fa fa-lock"></i>
							<asp:TextBox ID="txtContrasena2" runat="server" placeholder="Contraseña" 
								 style="background-color: #fff;" ReadOnly="false"></asp:TextBox>
							</div>						
					</div>
					<!-- Lado Derecho: Foto de Perfil -->
					<div class="form-group-item">
						<label>Foto de Perfil</label>
						<div style="display: flex; flex-direction: column; align-items: center; gap: 15px; margin-top: 10px;">
							<asp:Image ID="imgFotoPerfil" runat="server" 
								ImageUrl="../FOTOS/USUARIOS/default.png" 
								Width="150px" 
								Height="150px" 
								style="border-radius: 8px; border: 2px solid #e0e0e0; object-fit: cover;" />
							<div style="width: 100%;">
								<asp:FileUpload ID="fuFoto" runat="server" 
									CssClass="form-control" 
									accept="image/*"
									style="margin-bottom: 10px;" />
								<asp:Button ID="btnSubirFoto" runat="server" 
									Text="Subir Foto" 
									CssClass="btn-submit" 
									OnClick="btnSubirFoto_Click"
									style="padding: 10px 25px; font-size: 13px; width: 100%;" />
								<p style="font-size: 12px; color: #999; margin-top: 8px; margin-bottom: 0; text-align: center;">
									Formatos: JPG, PNG, GIF (máx. 5MB)
								</p>
							</div>
						</div>
					</div>
				</div>
				<!-- Buttons -->
				<div class="button-group">
					<asp:Button ID="btnGuardar" runat="server" Text="Guardar Cambios" CssClass="btn-submit" OnClick="btnGuardar_Click" />
					<button type="button" class="btn-cancel" onclick="history.back();">Cancelar</button>
				</div>
			</div>
		</div>
	</section>
	<!-- End Contact Info Section -->


</asp:Content>
