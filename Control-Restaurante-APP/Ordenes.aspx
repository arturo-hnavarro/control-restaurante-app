<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Ordenes.aspx.cs" Inherits="Control_Restaurante_APP.Ordenes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Ordenes</title>
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
                        <h2 id="textoCabecera"></h2>
                    </a>
                    <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
                    </ul>

                    <div class="text-end">
                        <button type="button" onclick="irAMenu()" class="btn btn-warning">Menú</button>
                    </div>
                </div>
            </div>
        </header>

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

        <div class="modal fade" id="facturarModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="4" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog  modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="ordenBackdropLabel">¿Desea facturar la orden?</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="facturarModalBody"></div>
                    <div id="confirmarFacturacionFooter" class="modal-footer"></div>
                </div>
            </div>
        </div>
    </div>

    <form id="form1" runat="server">
        <div class="container">
            <div id="ordenes" class="row">
            </div>
        </div>

    </form>

    <script type="text/javascript">

        window.onload = cargarPagina();

        function irAMenu() {
            window.open("Menu.aspx?mesa=" + getCookie('mesa'), "_self");
        }

        function cerrarSesion() {
            document.cookie = "usuario=;expires = Thu, 01 Jan 1970 00: 00: 00 UTC; path = /;";
            window.open("Login.aspx", "_self");
        }

        function cargarPagina() {
            if (document.cookie != "" && getCookie("usuario") != "") {
                cargarOrdenes();
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

        function crearJSONUsuario() {
            let usuario = JSON.stringify({
                username: "",
                rol: { id: "", nombre: "" }
            });
            return usuario;
        }

        function crearAlerta(titulo, estado, cuerpo) {
            $("#alertaModalHeader").removeClass("alert alert-danger");
            $("#alertaModalHeader").removeClass("alert alert-success");
            $("#tituloModalAlertaLabel").text(titulo);
            $("#alertaModalHeader").addClass(estado);
            $("#alertaModalBody").html(cuerpo);
        }

        function cargarOrdenes() {
            $.ajax({
                type: 'POST',
                url: 'Ordenes.aspx/CargarOrdenes',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != "") {
                        mostrarListaOrdenes(response.d);
                        mostrarTitulo();
                    }
                    else
                        alert('PROBLEMAS AL CARGAR LAS ORDENES');
                }
            });
        }

        function mostrarTitulo() {
            let usuario = JSON.parse(getCookie("usuario"));
            switch (usuario.rol.nombre) {
                case "ROLE_USER":
                    $("#textoCabecera").text("No tiene permisos para ver las ordenes.");
                    break;
                case "ROLE_ADMIN":
                    $("#textoCabecera").text("Todas las ordenes.");
                    break;
                case "ROLE_COCINERO":
                    $("#textoCabecera").text("Platillos por preparar.");
                    break;
                case "ROLE_MESERO":
                    $("#textoCabecera").text("Platillos por servir.");
                    break;
                case "ROLE_CAJERO":
                    $("#textoCabecera").text("Facturación de ordenes");
                    break;
                default:
                    return 0;
                    break;
            }
        }
        function obtenerOrdenTemplate() {
            var template = '<div class="card p-2 card bg-light">';
            template += '<div class="card-body">';
            template += '<div class="row border">';
            template += '<div class="col order-5">';
            template += '<div class="col-sm">';
            template += '<div class="p-2 mb-2 bg-[[COLOR_CABECERA]] text-white">';
            template += '<caption>Orden numero: [[ORDEN_NUMERO]]</caption>';
            template += ' Estado: [[ESTADO_ORDEN]]</div >';
            template += '<div>Mesa: [[MESA_ORDEN]]</div >';
            template += '<div [[OCULTO3]]>Total Orden: ₡[[TOTAL_ORDEN]]</div>';
            template += '<table class="table table-sm border">';
            template += '<thead>';
            template += '<tr>';
            template += '<th scope="col">#</th>';
            template += '<th scope="col">Platillo</th>';
            template += '<th scope="col">Cantidad</th>';
            template += '</tr >';
            template += '</thead >';
            template += '<tbody id="itemLista">';
            template += '[[NUEVO_ITEM]]';
            template += '</tbody>';
            template += '</table>';
            template += '<button type="button"  class="btn btn-success p-2"  onclick="cambiarEstadoOrden([[ID]],[[ID_ESTADO]])" data-bs-toggle="modal" data-bs-target="#alertaModal" [[OCULTO1]]>Cambiar Estado</button>';
            template += '<button type="button"  class="btn btn-primary p-2"  onclick="facturarOrden([[ID]],[[ID_ESTADO]],[[MESA_ORDEN]],[[TOTAL_ORDEN]])" data-bs-toggle="modal" data-bs-target="#facturarModal" [[OCULTO2]]>Facturar</button>';
            template += '</div >';
            template += '</br >';
            template += '</div >';
            template += '</div >';
            template += '</div >';
            template += '</div >';
            return template;
        }

        function mostrarListaOrdenes(response) {
            let listBody = "";
            for (var i = 0; i < response.length; i++) {
                if (response[i].estadoOrden.id > visibilidadXRolMin() && response[i].estadoOrden.id < visibilidadXRolMax()) {
                    let orden = obtenerOrdenTemplate();
                    orden = orden.replace("[[ORDEN_NUMERO]]", response[i].id);
                    orden = orden.replaceAll("[[TOTAL_ORDEN]]", (response[i].estadoOrden.id >= 3 ? response[i].total : ""));
                    orden = orden.replace("[[ESTADO_ORDEN]]", response[i].estadoOrden.descripcion);
                    orden = orden.replace("[[COLOR_CABECERA]]", response[i].estadoOrden.nombre);
                    orden = orden.replaceAll("[[ID]]", response[i].id);
                    orden = orden.replaceAll("[[ID_ESTADO]]", response[i].estadoOrden.id);
                    orden = orden.replaceAll("[[MESA_ORDEN]]", response[i].mesa.id);
                    orden = orden.replace("[[OCULTO1]]", (response[i].estadoOrden.id >= 3 ? "hidden" : "enabled"));
                    orden = orden.replace("[[OCULTO2]]", (response[i].estadoOrden.id == 3 ? "enabled" : "hidden"));
                    orden = orden.replace("[[OCULTO3]]", (response[i].estadoOrden.id >= 3 ? "enabled" : "hidden"));
                    let listItems = "";
                    for (var j = 0; j < response[i].items.length; j++) {
                        let item = obtenerItemTemplate();
                        item = item.replace("[[ITEM_NUMERO]]", j + 1);
                        item = item.replace("[[NOMBRE_PLATILLO]]", response[i].items[j].platillo.nombre);
                        item = item.replace("[[CANTIDAD_PLATILLO]]", response[i].items[j].cantidad);
                        listItems += item;
                    }
                    orden = orden.replace("[[NUEVO_ITEM]]", listItems);
                    listBody += orden;
                    $("#itemLista").html(listItems);
                }
            }
            $("#ordenes").html(listBody);
        }

        function visibilidadXRolMin() {
            let usuario = JSON.parse(getCookie("usuario"));
            switch (usuario.rol.nombre) {
                case "ROLE_USER":
                    return 0;
                    break;
                case "ROLE_ADMIN":
                    return 0
                    break;
                case "ROLE_COCINERO":
                    return 0;
                    break;
                case "ROLE_MESERO":
                    return 1;
                    break;
                case "ROLE_CAJERO":
                    return 2;
                    break;
                default:
                    return 0;
                    break;
            }

        }
        function visibilidadXRolMax() {
            let usuario = JSON.parse(getCookie("usuario"));
            switch (usuario.rol.nombre) {
                case "ROLE_USER":
                    return 0;
                    break;
                case "ROLE_ADMIN":
                    return 5;
                    break;
                case "ROLE_COCINERO":
                    return 2;
                    break;
                case "ROLE_MESERO":
                    return 3;
                    break;
                case "ROLE_CAJERO":
                    return 5;
                    break;
                default:
                    return 0;
                    break;
            }
        }

        function obtenerItemTemplate() {
            var template = '<tr>';
            template += '<th scope="row">[[ITEM_NUMERO]]</th>';
            template += '<td>[[NOMBRE_PLATILLO]]</td>';
            template += ' <td>[[CANTIDAD_PLATILLO]]</td>';
            template += '</tr>';

            return template;
        }
        function cambiarEstadoOrden(id, idEstado) {
            let dataJSON = JSON.stringify({
                idOrden: id,
                idEstado: idEstado + 1
            });
            $.ajax({
                type: 'POST',
                url: 'Ordenes.aspx/EditarOrden',
                data: dataJSON,
                contentType: "application/json; charset=utf-8",
                timeout: 360000,
                success: function (response) {
                    if (response.d != null) {
                        crearAlerta("Estado de orden", "alert alert-success", "El estado de la orden: " + response.d.id + ", cambio a: " + response.d.estadoOrden.descripcion);
                        cargarOrdenes();
                    } else {
                        crearAlerta("Estado de orden", "alert alert-danger", "No se pudo cambiar el estado de la orden.");
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    crearAlerta("Estado de orden", "alert alert-danger", 'Ocurrio un error al cambiar el estado de la orden');
                }
            });
        }

        function facturarOrden(id, idEstado, mesa, total) {
            let footer = '<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>'
            footer += '<button type="button" class="btn btn-warning" onclick="cambiarEstadoOrden(' + id + ',' + idEstado + ')" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#alertaModal" id="btn_facturarOrden">Sí</button>'

            $("#confirmarFacturacionFooter").append(footer);
            $("#facturarModalBody").html("Orden: " + id + " </br>Mesa: " + mesa + " </br>Precio de la orden: ₡" + total);
        }

        function mostrarItemOrden() {
            $("#itemLista").html(listBody);
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>
</body>
</html>
