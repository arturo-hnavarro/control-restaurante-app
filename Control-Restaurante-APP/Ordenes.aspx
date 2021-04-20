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
                        <h2>Platillos por preparar</h2>
                    </a>
                    <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
                    </ul>

                    <div class="text-end">
                        <button type="button" onclick="irAMenu()" class="btn btn-warning">Menú</button>
                    </div>
                </div>
            </div>
        </header>

        <form id="form1" runat="server">
            <div class="container">
                <div id="ordenes" class="row">
                </div>
            </div>

        </form>

        <script type="text/javascript">   

            window.onload = cargarOrdenes();

            function irAMenu() {
                window.open("Menu.aspx", "_self");
            }
            function cargarOrdenes() {
                $.ajax({
                    type: 'POST',
                    url: 'Ordenes.aspx/CargarOrdenes',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        if (response != "")
                            mostrarListaOrdenes(response.d);
                        else
                            alert('PROBLEMAS AL CARGAR LAS ORDENES');
                    }
                });
            }
            function obtenerOrdenTemplate() {
                var template = '<div class="card p-2 card bg-light">';
                template += '<div class="card-body">';
                template += '<div class="row border">';
                template += '<div class="col order-5">';
                template += '<div class="col-sm">';
                template += '<div class="p-2 mb-2 bg-primary text-white">';
                template += '<caption>Orden numero:[[ORDEN_NUMERO]]</caption>';
                template += ' [[ESTADO_ORDEN]]</div >';
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
                template += '<button type="button" class="btn [[TIPO_BTN]] p-2">Marcar como completada</button>';
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
                    let orden = obtenerOrdenTemplate();
                    orden = orden.replace("[[ORDEN_NUMERO]]", response[i].id);
                    orden = orden.replace("[[ESTADO_ORDEN]]", response[i].estadoPlatillo.descripcion);
                    orden = orden.replace("[[TIPO_BTN]]", "btn-success");
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

                $("#ordenes").html(listBody);
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
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>
</body>
</html>
