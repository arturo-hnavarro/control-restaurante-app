<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Control_Restaurante_APP.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Login</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BmbxuPwQa2lc/FVzBcNJ7UAyJxM6wuqIj61tLrc4wSX0szH/Ev+nYRRuWlolflfl" crossorigin="anonymous">
    <script src="Scripts/jquery-3.0.0.min.js"></script>
</head>
<body>
    <div class="mx-auto">
        <header class="p-3 bg-dark text-white">
            <div class="container">
                <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">
                    <a class="d-flex align-items-center mb-2 mb-lg-0 text-white text-decoration-none">
                        <h2>Login</h2>
                    </a>
                    <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
                    </ul>

                    <div class="text-end">
                        <button type="button" onclick="irAMenu()" class="btn btn-warning">Menú</button>
                    </div>
                </div>
            </div>
        </header>
        <div class="container">
            <div class="bg-light">
                <h1 class="text-center">Ingrese sus datos para acceder</h1>
                <form>
                    <div class="mb-3 ">
                        <label for="exampleInputEmail1" class="form-label">Usuario</label>
                        <input type="text" class="form-control" id="userInput">
                    </div>
                    <div class="mb-3">
                        <label for="exampleInputPassword1" class="form-label">Contraseña</label>
                        <input type="password" class="form-control" id="passwordInput">
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="exampleCheck1">
                        <label class="form-check-label" for="exampleCheck1">Recordarme</label>
                    </div>
                    <button type="button" class="btn btn-primary" id="btn_acceder" data-bs-toggle="modal" data-bs-target="#alertaModal">Acceder</button>
                </form>
            </div>
        </div>

        <div class="modal fade" id="alertaModal" tabindex="1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header" id="alertaModalHeader">
                        <h5 class="modal-title" id="tituloModalAlertaLabel"></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="alertaModalBody">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Aceptar</button>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">

            function crearAlerta(titulo, estado, cuerpo) {
                $("#alertaModalHeader").removeClass("alert alert-danger");
                $("#alertaModalHeader").removeClass("alert alert-success");
                $("#tituloModalAlertaLabel").text(titulo);
                $("#alertaModalHeader").addClass(estado);
                $("#alertaModalBody").html(cuerpo);
            }

            function irAMenu() {
                window.open("Menu.aspx", "_self");
            }

            $("body").on("click", "#btn_acceder", function (e) {
                let dataJSON = JSON.stringify({
                    username: $("#userInput").val(),
                    password: $("#passwordInput").val()
                });
                $.ajax({
                    type: 'POST',
                    url: 'Login.aspx/Acceder',
                    data: dataJSON,
                    contentType: "application/json; charset=utf-8",
                    timeout: 360000,
                    success: function (response) {
                        if (response.d !== null) {
                            crearAlerta("Login", "alert alert-success", "Ingreso.</br>" + response.d.user.nombre);
                            document.cookie = "usuario="+crearJSONUsuario(response);
                            window.open("Ordenes.aspx", "_self");
                        } else {
                            crearAlerta("Login", "alert alert-danger", 'Datos errones.');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        crearAlerta("Login", "alert alert-danger", 'Ocurrio un error iniciar sesión.');
                    }
                });
            });

            function crearJSONUsuario(response) {
                let usuario = JSON.stringify({
                    username: response.d.user.username,
                    rol: response.d.user.roles[0]
                });
                return usuario;
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>
</body>
</html>
