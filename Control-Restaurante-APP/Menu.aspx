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
        <div>
            <h1>Menú</h1>
        </div>
        <div>
            <div id="menu" class="row">
            </div>
        </div>
    </div>

    <!-- Fin menu -->

    <script type="text/javascript">

        window.onload = cargarMenu();


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
                platillo = platillo.replace("[[TIPO_PLATILLO]]", response[i].tipoPlato.nombre);
                platillo = platillo.replace("[[NOMBRE_PLATILLO]]", response[i].nombre);
                platillo = platillo.replace("[[IMAGEN]]", response[i].image);
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
            var template = '<div class="col-sm-4 p-2 " >';
            template += '<div class="card bg-light justify-content-start">';
            template += '<div class="card-body">';
            template += '<h6 class="">[[TIPO_PLATILLO]]</h6>';
            template += '<h5 class="card-title">[[NOMBRE_PLATILLO]]</h5>';
            template += '<h6 class="col-sm-3">Ingredientes</h6>';
            template += '<p class="card-text">[[INGREDIENTES]]</p>';
            template += '<div class="p-2 " ><img src="[[IMAGEN]]"  width="230px" height="200px"></div>';
            template += '<a href="#" class="btn btn-primary">Agregar al carrito</a>';
            template += '</div>';
            template += '</div>';
            template += '</div>';
            return template;
        }

    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>

</body>
</html>
