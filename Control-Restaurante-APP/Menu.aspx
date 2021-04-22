<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Menu.aspx.cs" Inherits="Control_Restaurante_APP.Views.Menu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Menu</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BmbxuPwQa2lc/FVzBcNJ7UAyJxM6wuqIj61tLrc4wSX0szH/Ev+nYRRuWlolflfl" crossorigin="anonymous">
    <script src="Scripts/jquery-3.0.0.min.js"></script>
</head>
<body>
    <!-- Menu. Este div agrupa la lista de platillos del menu
    Un ejemplo se puede ver aqui https://getbootstrap.com/docs/4.6/components/card/#using-grid-markup    
    -->
    <div class="mx-auto">
        <header class="p-3 bg-dark text-white">
            <div class="container">
                <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">
                    <a class="d-flex align-items-center mb-2 mb-lg-0 text-white text-decoration-none">
                        <h2>Menú</h2>
                    </a>
                    <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
                        <!--<li><a href="#" class="nav-link px-2 text-white">Features</a></li>
                        <li><a href="#" class="nav-link px-2 text-secondary">Home</a></li>
                        <li><a href="#" class="nav-link px-2 text-white">Pricing</a></li>
                        <li><a href="#" class="nav-link px-2 text-white">FAQs</a></li>
                        <li><a href="#" class="nav-link px-2 text-white">About</a></li>-->
                    </ul>

                    <div class="text-end">
                        <button type="button" onclick="mostarListaArticulos()" class="btn btn-outline-light me-2" data-bs-toggle="modal" data-bs-target="#carritoModal">Carrito</button>
                        <button type="button" onclick="irAOrdenes()" class="btn btn-warning">Ordenes</button>
                    </div>
                </div>
            </div>
        </header>

        <div class="container">
            <div id="menu" class="row ">
            </div>
        </div>
    </div>

    <div class="modal fade" id="carritoModal" tabindex="1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="tituloModalLabel">Carrito de compra</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="lista">
                </div>
                <p class="text-center" id="totalCarrito"></p>
                <div class="modal-footer">
                    <button type="button" id="btn_borrar_carrito" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#borrarCarritoModal">Borrar carrito</button>
                    <button type="button" id="btn_crear_orden" class="btn btn-primary" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#crearOrdenModal">Realizar orden</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="alertaModal" tabindex="2" aria-labelledby="exampleModalLabel" aria-hidden="true">
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
    <div class="modal fade" id="borrarCarritoModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="3" aria-labelledby="staticBackdropLabel" aria-hidden="true">
        <div class="modal-dialog  modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="staticBackdropLabel">Desea eliminar los platillos del carrito?</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                    <button type="button" class="btn btn-danger" data-bs-dismiss="modal" id="btn_limpiarcarrito">Sí</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="crearOrdenModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="4" aria-labelledby="staticBackdropLabel" aria-hidden="true">
        <div class="modal-dialog  modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="ordenBackdropLabel">¿Desea crear la orden?</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                    <button type="button" class="btn btn-danger" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#alertaModal" id="btn_crearordencarrito">Sí</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Fin menu -->

    <script type="text/javascript">
        var SessionStorageCarrito = 'carrito';

        window.onload = cargarMenu();

        var myModalEl = document.getElementById('carritoModal')
        myModalEl.addEventListener('show.bs.modal', function (event) {
            if (JSON.parse(sessionStorage.getItem(SessionStorageCarrito)) == null) {
                $("#btn_crear_orden").addClass("disabled");
                $("#btn_borrar_carrito").addClass("disabled");
            } else {
                $("#btn_crear_orden").removeClass("disabled");
                $("#btn_borrar_carrito").removeClass("disabled");
            }
        });

        function crearAlerta(titulo, estado, cuerpo) {
            $("#alertaModalHeader").removeClass("alert alert-danger");
            $("#alertaModalHeader").removeClass("alert alert-success");
            $("#tituloModalAlertaLabel").text(titulo);
            $("#alertaModalHeader").addClass(estado);
            $("#alertaModalBody").html(cuerpo);
        }

        function irAOrdenes() {
            if (document.cookie != "" && getCookie("usuario") != "") {
                window.open("Ordenes.aspx", "_self");
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

        function calcularTotalCarrito(carrito) {
            let totalCarrito = 0;
            if (carrito !== null) {
                for (var i = 0; i < carrito.length; i++) {
                    if (carrito[i].Platillo !== undefined) {
                        totalCarrito += carrito[i].Platillo.precio * carrito[i].Cantidad;
                    }
                }
            }
            return totalCarrito;
        }
        //Para hacer post a archivo .aspx.cs
        $("body").on("click", "#btn_crearordencarrito", function (e) {
            var platillosCarro = JSON.parse(sessionStorage.getItem(SessionStorageCarrito));
            let totalCarrito = calcularTotalCarrito(platillosCarro);
            var jsonData = JSON.stringify({
                idMesa: 1,
                cliente: "Nombre Cliente",
                total: totalCarrito,
                platillos: platillosCarro
            });
            $.ajax({
                type: 'POST',
                url: 'Menu.aspx/EnviarOrden',
                data: jsonData,
                contentType: "application/json; charset=utf-8",
                timeout: 360000,
                success: function (response) {
                    if (response.d != "") {
                        crearAlerta("Estado de orden", "alert alert-success", response.d);
                        sessionStorage.setItem(SessionStorageCarrito, null);
                    } else {
                        crearAlerta("Estado de orden", "alert alert-danger", "No se pudo generar la orden.");
                        sessionStorage.setItem(SessionStorageCarrito, null);
                        mostarListaArticulos();
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert('Ocurrio un error al registar la orden');
                }
            });
        });
        //fin post a aspx.cs

        function cargarMenu() {
            $.ajax({
                type: 'POST',
                url: "Menu.aspx/CargarMenu",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != "")
                        mostrarMenu(response.d);
                    else
                        alert('PROBLEMAS AL CARGAR EL MENÚ');
                }
            });
        }

        function mostrarMenu(response) {
            let menuBody = '';

            for (var i = 0; i < response.length; i++) {
                let platillo = obtenerPlatilloTemplate();
                platillo = platillo.replace("[[ID_PLATILLO]]", response[i].id);
                platillo = platillo.replace("[[TIPO_PLATILLO]]", response[i].tipoPlato.nombre);
                platillo = platillo.replace("[[NOMBRE_PLATILLO]]", response[i].nombre);
                platillo = platillo.replace("[[IMAGEN]]", "data:image/jpg;base64," + response[i].image);
                platillo = platillo.replace("[[PRECIO_PLATILLO]]", "₡" + response[i].precio);
                platillo = platillo.replaceAll("[[ID]]", response[i].id);
                var listaIngredientes = "";
                for (var j = 0; j < response[i].ingredientes.length; j++) {
                    listaIngredientes += response[i].ingredientes[j].nombre.replace(".", "");
                    if (j + 1 < response[i].ingredientes.length) {
                        listaIngredientes += ", ";
                    } else {
                        listaIngredientes += ".";
                    }
                }
                platillo = platillo.replace("[[INGREDIENTES]]", listaIngredientes);
                menuBody += platillo;
            }

            document.getElementById("menu").innerHTML = menuBody;
        }

        function obtenerPlatilloTemplate() {
            var template = '<div class="col-sm-6 p-2 id="[[ID_PLATILLO]]">';
            template += '<div class="card bg-light justify-content-start">';
            template += '<div class="card-body">';
            template += '<h6 class="">[[TIPO_PLATILLO]]</h6>';
            template += '<h5 class="card-title " id="platillo_nombre_[[ID]]">[[NOMBRE_PLATILLO]]</h5>';
            template += '<h5 class="card-tilte" id="platillo_precio_[[ID]]">[[PRECIO_PLATILLO]]</h5>';
            template += '<h6 class="col-sm-4">Ingredientes</h6>';
            template += '<p class="card-text">[[INGREDIENTES]]</p>';
            template += '<div class="p-2 " ><img src="[[IMAGEN]]" alt="Imagén del platillo" width="80%" height="80%"></div>';
            template += '<div class="input-group mb-3"> <span class="input-group-text" id="basic-addon1">Cantidad</span> <input id="platillo_cantidad_[[ID]]" type="number" min="1" max="10" width="10%" height="10%" value="1"></div>';
            template += '<button type="button" class="btn btn-primary" onclick="agregarArticulo([[ID]])" data-bs-toggle="modal" data-bs-target="#alertaModal">Agregar al carrito</button>';
            template += '</div>';
            template += '</div>';
            template += '</div>';
            return template;
        }

        function mostarListaArticulos() {
            let listBody = "";
            let totalCarrito = 0;
            var platillos = JSON.parse(sessionStorage.getItem(SessionStorageCarrito));
            if (platillos !== null) {
                for (var i = 0; i < platillos.length; i++) {
                    if (platillos[i].Platillo !== undefined) {
                        let total = platillos[i].Platillo.precio * platillos[i].Cantidad;
                        let articulo = obtenerListaPlatillosTemplate();
                        articulo = articulo.replace("[[NOMBRE_PLATILLO]]", "Platillo: " + platillos[i].Platillo.nombre);
                        articulo = articulo.replace("[[PRECIO_PLATILLO]]", "Total: ₡" + total);
                        articulo = articulo.replace("[[CANTIDAD]]", platillos[i].Cantidad);
                        listBody += articulo;
                        totalCarrito += total;
                    }
                }
            }
            $("#totalCarrito").text("Total: ₡" + totalCarrito);
            $("#lista").html(listBody);
        }
        function obtenerListaPlatillosTemplate() {
            var template = '<ol class="list-group list-group-numbered">';
            template += '<li class="list-group-item d-flex justify-content-between align-items-start">';
            template += '<div class="ms-2 me-auto">';
            template += '<div class="fw-bold">[[NOMBRE_PLATILLO]]</div>';
            template += '[[PRECIO_PLATILLO]]';
            template += '</div>';
            template += '<span class="badge bg-primary rounded-pill">[[CANTIDAD]]</span>';
            template += '</li>';
            template += '</ol>';
            return template;
        }
        function agregarArticulo(id) {
            var platillos = JSON.parse(sessionStorage.getItem(SessionStorageCarrito));
            var platillo = {
                id: id,
                nombre: $("#platillo_nombre_" + id).text(),
                precio: $("#platillo_precio_" + id).text().substring(1)
            }
            var articuloOrden = {
                Platillo: platillo,
                Cantidad: $("#platillo_cantidad_" + id).val()
            }
            if (articuloOrden.Cantidad > 0 && articuloOrden.Cantidad <= 10) {
                crearAlerta("Agregado al carrito de compras", "alert alert-success", "Platillo: " + platillo.nombre + " </br> Cantidad: " + articuloOrden.Cantidad);
                guardarEnsessionStorage(platillos, articuloOrden);
            } else {
                crearAlerta("No se agrego al carrito", "alert alert-danger", "La cantidad debe de estar entre 1 y 10.");
            }
        }

        function guardarEnsessionStorage(platillos, articuloOrden) {
            if (platillos !== null) {
                platillos.push(articuloOrden);
                sessionStorage.setItem(SessionStorageCarrito, JSON.stringify(platillos));
            } else {
                var nuevosPlatillo = []
                nuevosPlatillo.push(articuloOrden);
                sessionStorage.setItem(SessionStorageCarrito, JSON.stringify(nuevosPlatillo));
            }
        }

        $("body").on("click", "#btn_limpiarcarrito", function (e) {
            sessionStorage.setItem(SessionStorageCarrito, null);
            mostarListaArticulos();
            $("#btn_crear_orden").addClass("disabled");
            $("#btn_borrar_carrito").addClass("disabled");
        });

    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>

</body>
</html>
