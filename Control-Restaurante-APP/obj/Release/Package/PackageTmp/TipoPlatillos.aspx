﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TipoPlatillos.aspx.cs" Inherits="Control_Restaurante_APP.TipoPlatillos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Tipos de platillos</title>
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
                        <h2>Administración de Tipos de Platillos</h2>
                    </a>
                    <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
                    </ul>

                    <div class="text-end">
                        <button type="button" onclick="irAMenu()" class="btn btn-warning">Menú</button>
                    </div>
                </div>
            </div>
        </header>

        <div id="alertMessage" class="" role="alert">
        </div>

        <form id="form1">
            <div class="container">
                <br />
                <button id="nuevoPlatillo" class="btn btn-success" type="button" data-bs-toggle="modal" data-bs-target="#modalTipoPlatillo">Agregar nuevo tipo</button>
                <br />

                <div id="tiposDePlatillos" class="row">
                </div>
            </div>
        </form>
    </div>
    <div class="modal fade" id="modalTipoPlatillo" tabindex="1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="tituloModalLabel">Detelle del tipo de platillo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modalTipoPlatilloBodyDetalle">
                </div>
                <div class="modal-footer">
                    <button type="button" id="btn_guardar_tipo_platillo" class="btn btn-primary" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#crearOrdenModal">Registrar</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">

        function irAMenu() {
            window.open("Menu.aspx?mesa=" + getCookie('mesa'), "_self");
        }
        $(document).ready(function () {
            window.onload = loadDefaulValues();

            $("body").on("click", "#nuevoPlatillo", function (e) {
                mostrarDetalleTipoPlatillo('')
            });

            $("body").on("click", "#btn_guardar_tipo_platillo", function (e) {
                var platillo = JSON.stringify({
                    id: $("#platilloId").val(),
                    nombre: $("#nombreId").val(),
                    descripcion: $("#descripcionId").val()
                });
                salvarTipoPlatillo(platillo);
            });
        });

        function loadDefaulValues() {
            if (document.cookie != "" && getCookie("usuario") != "") {
                cargarTipoPlatillos();
            } else {
                window.open("Login.aspx", "_self");
            }
        }

        function getCookie(cname) {
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        }

        function cargarTipoPlatillos() {
            $.ajax({
                type: 'POST',
                url: "Platillos.aspx/GetTipos",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != null)
                        mostrarListaTiposPlatillos(response.d);
                    else
                        showAlert('Problemas al cargar información del tipo de platillos. Por favor intente de nuevo', '2');
                }
            });
        }

        function salvarTipoPlatillo(dataJson) {
            $.ajax({
                type: 'POST',
                url: "TipoPlatillos.aspx/Salvar",
                data: dataJson,
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response.d != null) {
                        showAlert('Platillo <strong>' + response.d.id + '</strong> guardado correctamente', '1');
                        cargarTipoPlatillos()
                    }
                    else
                        showAlert('No fue posible guardar la información. Por favor intente de nuevo', '2');
                }
            });
        }

        function mostrarListaTiposPlatillos(tipos) {
            let table = obtenerTablaTipoPlatilloTemplate();
            let listBody = "";
            for (var i = 0; i < tipos.length; i++) {
                let tipo = obtenerTipoPlatilloTemplate();
                tipo = tipo.replace("[[ID]]", tipos[i].id);
                tipo = tipo.replace("[[NOMBRE]]", tipos[i].nombre);
                tipo = tipo.replace("[[DESCRIPCION]]", tipos[i].descripcion);
                tipo = tipo.replace("[[ACCIONES]]", '<div class="d-grid gap-2"><button class= "btn btn-primary" onclick="verDetalleTipoPlatillo(' + tipos[i].id + ')" type = "button" data-bs-toggle="modal" data-bs-target="#modalTipoPlatillo"> Editar </button></div >');
                listBody += tipo;
            }
            table = table.replace("[[NUEVO_ITEM]]", listBody);
            $("#tiposDePlatillos").html(table);
        }

        function obtenerTablaTipoPlatilloTemplate() {
            var template = '<table class="table table-striped table-hover">';
            template += '<thead>';
            template += '<tr>';
            template += '<th scope="col">Id</th>';
            template += '<th scope="col">Nombre</th>';
            template += '<th scope="col">Descripcion</th>';
            template += '<th scope="col">Acciones</th>';
            template += '</tr>';
            template += '</thead>';
            template += '<tbody id="itemPlatilloLista">';
            template += '[[NUEVO_ITEM]]';
            template += '</tbody>';
            template += '</table>';
            return template;
        }

        function obtenerTipoPlatilloTemplate() {
            var template = '<tr>';
            template += '<th scope="row">[[ID]]</th>';
            template += '<td>[[NOMBRE]]</td>';
            template += '<td>[[DESCRIPCION]]</td>';
            template += '<td>[[ACCIONES]]</td>';
            template += '</tr>';
            return template;
        }

        function verDetalleTipoPlatillo(id) {
            buscarTipoPlatillo(id);
        }

        function buscarTipoPlatillo(id) {
            var jsonData = JSON.stringify({
                idTipo: id
            });

            $.ajax({
                type: 'POST',
                url: "TipoPlatillos.aspx/BuscarPorId",
                data: jsonData,
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != null)
                        mostrarDetalleTipoPlatillo(response.d);
                    else
                        showAlert('Problemas al cargar información del tipo de platillo. Por favor intente de nuevo', '2');
                }
            });
        }

        function mostrarDetalleTipoPlatillo(response) {
            var platilloForm = obtenerTipoPlatilloFormTemplate();
            platilloForm = platilloForm.replace("[[ID]]", response != '' ? response.id : '');
            platilloForm = platilloForm.replace("[[NOMBRE]]", response != '' ? response.nombre : '');
            platilloForm = platilloForm.replace("[[DESCRIPCION]]", response != '' ? response.descripcion : '');
            $("#modalTipoPlatilloBodyDetalle").html(platilloForm);
        }

        function obtenerTipoPlatilloFormTemplate() {
            var template = '<form>'
            template += '<div class="visually-hidden">'
            template += '<label for="platilloId" class="form-label">Id</label>'
            template += '<input type="text" class="form-control" id="platilloId" value="[[ID]]" disabled>'
            template += '</div>'

            template += '<div>'
            template += '<label for="nombreId" class="form-label">Nombre</label>'
            template += '<input type="text"  required="required" class="form-control" id="nombreId" value="[[NOMBRE]]">'
            template += '</div>'

            template += '<div>'
            template += '<label for="descripcionId" class="form-label">Descripción</label>'
            template += '<input type="text" class="form-control" id="descripcionId" value="[[DESCRIPCION]]">'
            template += '</div>'
            template += '</form>'

            return template;
        }

        /*
        * type 1 = success, 2 = error
        * */
        function showAlert(message, type) {
            $("#alertMessage").removeClass("alert alert-success");
            $("#alertMessage").removeClass("alert alert-danger");
            switch (type) {
                case '1':
                    $("#alertMessage").addClass("alert alert-success");
                    break;
                case '2':
                    $("#alertMessage").addClass("alert alert-danger");
                    break;
            }
            $("#alertMessage").html(message)
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>
</body>
</html>
