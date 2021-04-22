<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Platillos.aspx.cs" Inherits="Control_Restaurante_APP.Platillos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Platillos</title>
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
                        <h2>Administración de Platillos</h2>
                    </a>
                    <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
                    </ul>

                    <div class="text-end">
                        <button type="button" onclick="irAMenu()" class="btn btn-warning">Menú</button>
                    </div>
                </div>
            </div>
        </header>
    </div>
    <div id="alertMessage" class="" role="alert">
    </div>

    <form id="form1">
        <div class="container">
            <br />
            <button id="nuevoPlatillo" class="btn btn-success" type="button" data-bs-toggle="modal" data-bs-target="#modalPlatilloDetalle">Agregar nuevo platillo </button>
            <br />
            <div id="platillos" class="row">
            </div>
        </div>
    </form>

    <div class="modal fade" id="modalPlatilloDetalle" tabindex="1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="tituloModalLabel">Detelle del platillo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modalPlatilloBodyDetalle">
                </div>
                <div class="modal-footer">
                    <button type="button" id="btn_guardar_platillo" class="btn btn-primary" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#crearOrdenModal">Registrar</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">   
        var estadosPlatillos = [];
        var tipoPlatillos = [];
        var catalogoIngredientes = [];

        function irAMenu() {
            window.open("Menu.aspx", "_self");
        }
        $(document).ready(function () {

            window.onload = loadDefaulValues();

            $("body").on("click", "#nuevoPlatillo", function (e) {
                mostrarDetallePlatillo('')
            });

            $("body").on("click", "#btn_guardar_platillo", function (e) {
                var ingredientesSeleccionados = $("input:checkbox:checked").map(function () {
                    return $(this).val();
                }).get();

                var platillo = JSON.stringify({
                    id: $("#platilloId").val(),
                    nombre: $("#nombreId").val(),
                    precio: $("#precioId").val(),
                    estadoPlatillo: $("#estadoPlatilloId").val(),
                    tipoPlato: $("#tipoPlatilloId").val(),
                    ingredientes: ingredientesSeleccionados,
                    imagePath: $("#imagePathId").val(),
                });
                salvarPlatillo(platillo);
            });

            function loadDefaulValues() {
                if (document.cookie != "" && getCookie("usuario") != "") {
                    cargarPlatillos();
                    cargarEstadosPlatillos();
                    cargarTipoPlatillos();
                    cargarCatalogoIngredientes();
                } else {
                    window.open("Login.aspx", "_self");
                }
            }
        });

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

        function salvarPlatillo(dataJson) {
            $.ajax({
                type: 'POST',
                url: "Platillos.aspx/Salvar",
                data: dataJson,
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response.d != null) {
                        showAlert('Platillo <strong>' + response.d.id + '</strong> guardado correctamente', '1');
                        cargarPlatillos()
                    }
                    else
                        showAlert('No fue posible guardar la información. Por favor intente de nuevo', '2');
                }
            });
        }

        function cargarPlatillos() {
            $.ajax({
                type: 'POST',
                url: "Menu.aspx/CargarMenu",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != "")
                        mostrarListaPlatillos(response.d);
                    else
                        showAlert('No fue posible cargar la información del platillo. Por favor intente de nuevo', '2');
                }
            });
        }

        function obtenerTablaPlatilloTemplate() {
            var template = '<table class="table table-striped table-hover">';
            template += '<thead>';
            template += '<tr>';
            template += '<th scope="col">Id</th>';
            template += '<th scope="col">Nombre</th>';
            template += '<th scope="col">Precio</th>';
            template += '<th scope="col">Ruta de imagen</th>';
            template += '<th scope="col">Estado</th>';
            template += '<th scope="col">Tipo de platillo</th>';
            template += '<th scope="col">Ingredientes</th>';
            template += '<th scope="col">Acciones</th>';
            template += '</tr>';
            template += '</thead>';
            template += '<tbody id="itemLista">';
            template += '[[NUEVO_ITEM]]';
            template += '</tbody>';
            template += '</table>';
            return template;
        }

        function obtenerPlatilloTemplate() {
            var template = '<tr>';
            template += '<th scope="row">[[ID]]</th>';
            template += '<td>[[NOMBRE]]</td>';
            template += '<td>[[PRECIO]]</td>';
            template += '<td>[[IMAGEN]]</td>';
            template += '<td>[[ESTADO]]</td>';
            template += '<td>[[TIPO]]</td>';
            template += '<td>[[INGREDIENTES]]</td>';
            template += '<td>[[ACCIONES]]</td>';
            template += '</tr>';
            return template;
        }

        function obtenerPlatilloFormTemplate() {
            var template = '<form>'
            template += '<div class="visually-hidden">'
            template += '<label for="platilloId" class="form-label">Id</label>'
            template += '<input type="text" class="form-control" id="platilloId" value="[[ID]]" disabled>'
            template += '</div>'

            template += '<div>'
            template += '<label for="nombreId" class="form-label">Nombre</label>'
            template += '<input type="text" class="form-control" id="nombreId" value="[[NOMBRE]]">'
            template += '</div>'

            template += '<div>'
            template += '<label for="precioId" class="form-label">Precio</label>'
            template += '<input type="text" class="form-control" id="precioId" value="[[PRECIO]]">'
            template += '</div>'

            template += '<div >'
            template += '<label for="estadoPlatilloId" class="form-label">Estado:</label>'
            template += '</br>[[ESTADO]]'
            template += '</div>'

            template += '<div>'
            template += '<label for="tipoPlatilloId" class="form-label">Tipo:</label>'
            template += '</br>[[TIPO]]'
            template += '</div>'

            template += '<div class="[[IMG_BASE_64_CLASS]]">'
            template += '<label for="imageId" class="form-label">Imagen</label>'
            template += '<div class="p-2 " ><img src="[[IMAGEN]]" alt="Imagén del platillo" width="80%" height="80%"></div>';
            template += '</div>'

            template += '<div>'
            template += '<label for="imagePathId" class="form-label">Ruta de la imagen</label>'
            template += '<input type="text" class="form-control" id="imagePathId" value="[[IMG_PATH]]">'
            template += '</div>'

            template += '<div>'
            template += '<label class="form-label">Ingredientes:</label>'
            template += '</br>[[INGREDIENTES]]';
            template += '</div>'

            return template;
        }

        function mostrarListaPlatillos(response) {
            let table = obtenerTablaPlatilloTemplate();
            let listBody = "";
            for (var i = 0; i < response.length; i++) {
                let platillo = obtenerPlatilloTemplate();
                platillo = platillo.replace("[[ID]]", response[i].id);
                platillo = platillo.replace("[[NOMBRE]]", response[i].nombre);
                platillo = platillo.replace("[[PRECIO]]", response[i].precio);
                platillo = platillo.replace("[[IMAGEN]]", response[i].imagePath);
                platillo = platillo.replace("[[ESTADO]]", response[i].estadoPlatillo.nombre + '<p class="fst-italic">(' + response[i].estadoPlatillo.descripcion + '.)</p>');
                platillo = platillo.replace("[[TIPO]]", response[i].tipoPlato.nombre + '<p class="fst-italic">(' + response[i].tipoPlato.descripcion + '.)</p>');
                var ingredientes = '<ul class="list-group list-group-flush">';
                for (let j = 0; j < response[i].ingredientes.length; j++)
                    ingredientes += '<li class="list-group-item">' + response[i].ingredientes[j].nombre + '</li>'
                ingredientes += '<ul class="list-group list-group-flush">'
                platillo = platillo.replace("[[INGREDIENTES]]", ingredientes);
                platillo = platillo.replace("[[ACCIONES]]", '<div class="d-grid gap-2"><button class= "btn btn-primary" onclick="verDetallePlatillo(' + response[i].id + ')" type = "button" data-bs-toggle="modal" data-bs-target="#modalPlatilloDetalle""> Editar </button></div >');

                listBody += platillo;
            }
            table = table.replace("[[NUEVO_ITEM]]", listBody);
            $("#platillos").html(table);
        }

        function obtenerItemTemplate() {
            var template = '<tr>';
            template += '<th scope="row">[[ITEM_NUMERO]]</th>';
            template += '<td>[[NOMBRE_PLATILLO]]</td>';
            template += ' <td>[[CANTIDAD_PLATILLO]]</td>';
            template += '</tr>';

            return template;
        }

        function mostrarItemOrden() {
            $("#itemLista").html(listBody);
        }

        function verDetallePlatillo(id) {
            buscarPlatillo(id);
        }

        function obtenerEstados() {
            return estadosPlatillos;
        }

        function obtenerTipos() {
            return tipoPlatillos;
        }

        function obtenerCatalogo() {
            return catalogoIngredientes;
        }

        /*
         * si idEstadoPlatillo es null se genera el template para un nuevo platillo
         * */
        function detalleTemplate(id) {
            var estados = obtenerEstados();
            let detalleEstado = '<select id="estadoPlatilloId" class="form-select" aria-label="Default select example">'
            detalleEstado += '<option>Seleccionar</option>'
            for (var i = 0; i < estados.length; i++) {
                if (id == estados[i].id)
                    detalleEstado += '<option value="' + estados[i].id + '" selected>' + estados[i].nombre + '</option>'
                else
                    detalleEstado += '<option value="' + estados[i].id + '">' + estados[i].nombre + '</option>'
            }
            detalleEstado += '</select>'
            return detalleEstado;
        }

        function tipoPlatilloTemplate(id) {
            var tipos = obtenerTipos();

            let detalleTipo = '<select id="tipoPlatilloId" class="form-select" aria-label="Default select example">'
            detalleTipo += '<option>Seleccionar</option>'
            for (var i = 0; i < tipos.length; i++) {
                if (id == tipos[i].id)
                    detalleTipo += '<option value="' + tipos[i].id + '" selected>' + tipos[i].nombre + '</option>'
                else
                    detalleTipo += '<option value="' + tipos[i].id + '">' + tipos[i].nombre + '</option>'
            }
            detalleTipo += '</select>'

            return detalleTipo;
        }

        function ingredientesTemplate(ingredientesPlatillo) {
            var ingredientes = ''
            var catalogoIngredientes = obtenerCatalogo();
            if (ingredientesPlatillo.length > 0)
                for (var i = 0; i < catalogoIngredientes.length; i++) {
                    ingredientes += '<div class="form-check form-check-inline">'
                    if (isIngredienteInPlatillo(catalogoIngredientes[i].id, ingredientesPlatillo))
                        ingredientes += '<input class="form-check-input" type="checkbox" id="catalogoIngrediente' + catalogoIngredientes[i].id + '" value="' + catalogoIngredientes[i].id + '" checked>'
                    else
                        ingredientes += '<input class="form-check-input" type="checkbox" id="catalogoIngrediente' + catalogoIngredientes[i].id + '" value="' + catalogoIngredientes[i].id + '">'
                    ingredientes += '<label class="form-check-label" for="catalogoIngrediente' + catalogoIngredientes[i].id + '">' + catalogoIngredientes[i].nombre + '</label>'
                    ingredientes += '</div>'
                }
            else
                for (var i = 0; i < catalogoIngredientes.length; i++) {
                    ingredientes += '<div class="form-check form-check-inline">'
                    ingredientes += '<input class="form-check-input" type="checkbox" id="catalogoIngrediente' + catalogoIngredientes[i].id + '" value="' + catalogoIngredientes[i].id + '">'
                    ingredientes += '<label class="form-check-label" for="catalogoIngrediente' + catalogoIngredientes[i].id + '">' + catalogoIngredientes[i].nombre + '</label>'
                    ingredientes += '</div>'
                }
            return ingredientes
        }

        function mostrarDetallePlatillo(response) {
            var platilloForm = obtenerPlatilloFormTemplate();
            platilloForm = platilloForm.replace("[[ID]]", response != '' ? response.id : '');
            platilloForm = platilloForm.replace("[[NOMBRE]]", response != '' ? response.nombre : '');
            platilloForm = platilloForm.replace("[[PRECIO]]", response != '' ? response.precio : '');
            platilloForm = platilloForm.replace("[[ESTADO]]", detalleTemplate(response != '' ? response.estadoPlatillo.id : ''));
            platilloForm = platilloForm.replace("[[TIPO]]", tipoPlatilloTemplate(response != '' ? response.tipoPlato.id : ''));
            platilloForm = platilloForm.replace("[[INGREDIENTES]]", ingredientesTemplate(response != '' ? response.ingredientes : ''));


            platilloForm = platilloForm.replace("[[IMAGEN]]", response != '' ? "data:image/jpg;base64," + response.image : '');
            platilloForm = platilloForm.replace("[[IMG_BASE_64_CLASS]]", response != '' ? "" + response.image : "visually-hidden");
            platilloForm = platilloForm.replace("[[IMG_PATH]]", response != '' ? response.imagePath : '');
            $("#modalPlatilloBodyDetalle").html(platilloForm);
        }

        function editarPlatillo(idPlatillo) {
            var jsonData = JSON.stringify({
                id: idPlatillo
            });

            $.ajax({
                type: 'POST',
                url: "Platillos.aspx/Editar",
                data: jsonData,
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != null)
                        alert(response.d);
                    else
                        showAlert('No fue posible guardar la información del platillo. Por favor intente de nuevo', '2');
                }
            });
        }

        function buscarPlatillo(id) {
            var jsonData = JSON.stringify({
                idPlatillo: id
            });

            $.ajax({
                type: 'POST',
                url: "Platillos.aspx/BuscarPorId",
                data: jsonData,
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != null)
                        mostrarDetallePlatillo(response.d);
                    else
                        showAlert('No fue posible cargar la información del platillo. Por favor intente de nuevo', '2');
                }
            });
        }

        function cargarEstadosPlatillos() {
            $.ajax({
                type: 'POST',
                url: "Platillos.aspx/Estados",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != "")
                        cargarEstadosEnMemoria(response.d);
                    else
                        showAlert('No fue posible cargar estados de los platillos. Por favor intente de nuevo', '2');
                }
            });
        }

        function cargarTipoPlatillos() {
            $.ajax({
                type: 'POST',
                url: "Platillos.aspx/GetTipos",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != "")
                        cargarTiposEnMemoria(response.d);
                    else
                        showAlert('No fue posible cargar tipos de platillos. Por favor intente de nuevo', '2');
                }
            });
        }

        function cargarCatalogoIngredientes() {
            $.ajax({
                type: 'POST',
                url: "Platillos.aspx/GetCatalogoIngredientes",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != "")
                        cargarCatalogoEnMemoria(response.d);
                    else
                        showAlert('No fue posible cargar el catalogo de ingredientes. Por favor intente de nuevo', '2');
                }
            });
        }

        function cargarEstadosEnMemoria(response) {
            for (let i = 0; i < response.length; i++) {
                estadosPlatillos.push(response[i]);
            }
        }

        function cargarTiposEnMemoria(response) {
            for (let i = 0; i < response.length; i++) {
                tipoPlatillos.push(response[i]);
            }
        }

        function cargarCatalogoEnMemoria(response) {
            for (let i = 0; i < response.length; i++) {
                catalogoIngredientes.push(response[i]);
            }
        }

        function isIngredienteInPlatillo(idCatalogo, ingredientes) {
            for (var i = 0; i < ingredientes.length; i++) {
                if (ingredientes[i].id == idCatalogo)
                    return true;
            }
            return false;
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
