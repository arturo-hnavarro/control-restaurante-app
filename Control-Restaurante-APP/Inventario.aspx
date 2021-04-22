<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inventario.aspx.cs" Inherits="Control_Restaurante_APP.Inventario" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Inventario</title>
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
                        <h2>Administración de Inventario</h2>
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
                <button id="nuevoProducto" class="btn btn-success" type="button" data-bs-toggle="modal" data-bs-target="#modalProducto">Agregar nuevo producto</button>
                <br /><br />
                <div id="productos" class="row">
                </div>
            </div>
        </form>
    </div>

    <div class="modal fade" id="modalProducto" tabindex="1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="tituloModalLabel">Detelle del producto</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modalProductoBodyDetalle">
                </div>
                <div class="modal-footer">
                    <button type="button" id="btn_guardar_producto" class="btn btn-primary" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#crearOrdenModal">Registrar</button>
                </div>
            </div>
        </div>
    </div>


    <script type="text/javascript">

        function irAMenu() {
            window.open("Menu.aspx", "_self");
        }
        $(document).ready(function () {
            window.onload = loadDefaulValues();

            $("body").on("click", "#nuevoProducto", function (e) {
                mostrarDetalleProducto('')
            });

            $("body").on("click", "#btn_guardar_producto", function (e) {
                var producto = JSON.stringify({
                    id: $("#productoId").val(),
                    nombre: $("#nombreId").val(),
                    cantidad: $("#cantidadId").val()
                });
                salvarProducto(producto);
            });

        });

        function salvarProducto(dataJson) {
            $.ajax({
                type: 'POST',
                url: "Inventario.aspx/Salvar",
                data: dataJson,
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response.d != null) {
                        showAlert('Producto <strong>' + response.d.id + '</strong> guardado correctamente', '1');
                        cargarInventario()
                    }
                    else
                        showAlert('No fue posible guardar la información. Por favor intente de nuevo', '2');
                }
            });
        }

        function loadDefaulValues() {
            cargarInventario();
        }

        function cargarInventario() {
            $.ajax({
                type: 'POST',
                url: "Inventario.aspx/Get",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != null)
                        mostrarListaInventario(response.d);
                    else
                        alert('PROBLEMAS AL CARGAR INFORMACION DE INVENTARIO');
                }
            });
        }

        function mostrarListaInventario(productos) {
            let table = obtenerTablaInventarioTemplate();
            let listBody = "";
            for (var i = 0; i < productos.length; i++) {
                let producto = obtenerProductoTemplate();
                producto = producto.replace("[[ID]]", productos[i].id);
                producto = producto.replace("[[NOMBRE]]", productos[i].nombre);
                producto = producto.replace("[[CANTIDAD]]", productos[i].candidadDisponible);
                producto = producto.replace("[[ACCIONES]]", '<div class="d-grid gap-2"><button class= "btn btn-primary" onclick="verDetalleProducto(' + productos[i].id + ')" type="button" data-bs-toggle="modal" data-bs-target="#modalProducto"> Editar </button></div >');

                listBody += producto;
            }
            table = table.replace("[[NUEVO_ITEM]]", listBody);
            $("#productos").html(table);
        }

        function obtenerTablaInventarioTemplate() {
            var template = '<table class="table table-striped table-hover">';
            template += '<thead>';
            template += '<tr>';
            template += '<th scope="col">Id</th>';
            template += '<th scope="col">Nombre</th>';
            template += '<th scope="col">Cantidad</th>';
            template += '<th scope="col">Acciones</th>';
            template += '</tr>';
            template += '</thead>';
            template += '<tbody id="itemProductoLista">';
            template += '[[NUEVO_ITEM]]';
            template += '</tbody>';
            template += '</table>';
            return template;
        }

        function obtenerProductoTemplate() {
            var template = '<tr>';
            template += '<th scope="row">[[ID]]</th>';
            template += '<td>[[NOMBRE]]</td>';
            template += '<td>[[CANTIDAD]]</td>';
            template += '<td>[[ACCIONES]]</td>';
            template += '</tr>';
            return template;
        }

        function verDetalleProducto(id) {
            buscarProducto(id);
        }

        function buscarProducto(id) {
            var jsonData = JSON.stringify({
                idProducto: id
            });

            $.ajax({
                type: 'POST',
                url: "Inventario.aspx/BuscarPorId",
                data: jsonData,
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != null)
                        mostrarDetalleProducto(response.d);
                    else
                        showAlert('Problemas al cargar catalodo de productos, por favor intentar de nuevo.', '2');
                }
            });
        }

        function mostrarDetalleProducto(response) {
            var productoForm = obtenerProductoFormTemplate();
            productoForm = productoForm.replace("[[ID]]", response != '' ? response.id : '');
            productoForm = productoForm.replace("[[NOMBRE]]", response != '' ? response.nombre : '');
            productoForm = productoForm.replace("[[CANTIDAD]]", response != '' ? response.candidadDisponible : '');
            $("#modalProductoBodyDetalle").html(productoForm);
        }

        function obtenerProductoFormTemplate() {
            var template = '<form>'
            template += '<div class="visually-hidden">'
            template += '<label for="productoId" class="form-label">Id</label>'
            template += '<input type="text" class="form-control" id="productoId" value="[[ID]]" disabled>'
            template += '</div>'

            template += '<div>'
            template += '<label for="nombreId" class="form-label">Nombre</label>'
            template += '<input type="text"  required="required" class="form-control" id="nombreId" value="[[NOMBRE]]">'
            template += '</div>'

            template += '<div>'
            template += '<label for="cantidadId" class="form-label">Cantidad</label>'
            template += '<input type="text" class="form-control" id="cantidadId" value="[[CANTIDAD]]">'
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
