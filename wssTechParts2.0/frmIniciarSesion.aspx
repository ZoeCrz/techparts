<%@ Page Title="" Language="C#" MasterPageFile="~/mpPrincipal.Master" AutoEventWireup="true" CodeBehind="frmIniciarSesion.aspx.cs" Inherits="wssTechParts2._0.Formulario_web11" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <!-- Start Banner Area -->
	<section class="banner-area organic-breadcrumb">
		<div class="container">
			<div class="breadcrumb-banner d-flex flex-wrap align-items-center justify-content-end">
				<div class="col-first">
					<h1>Iniciar sesión</h1>
					<nav class="d-flex align-items-center">
						<a href="frmPrincipal.aspx">Inicio<span class="lnr lnr-arrow-right"></span></a>
						<a href="frmIniciarSesion.aspx">Iniciar sesión</a>
					</nav>
				</div>
			</div>
		</div>
	</section>
	<!-- End Banner Area -->

	<!--================Login Box Area =================-->
	<section class="login_box_area section_gap">
		<div class="container">
			<div class="row">
				<div class="col-lg-6">
					<div class="login_box_img">
						<img class="img-fluid" src="FOTOS/loginBanner.png" alt="">
						<div class="hover">
							<h4>¿Nuevo en TechParts?</h4>
							<p>Bienvenido a TechParts<br />
							Personaliza, arma y haz realidad la PC que siempre imaginaste!</p>
							<a class="primary-btn" href="frmRegistro.aspx">Crear una cuenta</a>
						</div>
					</div>
				</div>
				<div class="col-lg-6 d-flex justify-content-center align-items-center">
					<div class="login_form_inner text-center">
						<h3>Inicia sesión para seguir comprando</h3>
						<div class="row login_form">
							<div class="col-md-12 form-group">
								<asp:TextBox class="form-control" id="txtUsuario" name="usuario" placeholder="Usuario" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Usuario'" runat="server"></asp:TextBox>
							</div>
							<div class="col-md-12 form-group">
								<asp:TextBox class="form-control" id="txtContrasena" name="contrasena" placeholder="Contraseña" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Contraseña'" TextMode="Password" runat="server"></asp:TextBox>
							</div>
							<div class="col-md-12 form-group">
								<div class="creat_account">
									<input type="checkbox" id="f-option2" name="selector">
									<label for="f-option2">Mantenme conectado</label>
								</div>
							</div>
							<div class="col-md-12 form-group">
								<asp:Button ID="btnIniciarSesion" type="submit" value="submit" class="primary-btn" runat="server" Text="Iniciar sessión" OnClick="btnIniciarSesion_Click" />
								<a href="#">¿Olvidaste tu contraseña?</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!--================End Login Box Area =================-->


</asp:Content>