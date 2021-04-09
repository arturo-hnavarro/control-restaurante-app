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
</head>
<body>
    <!-- Menu. Este div agrupa la lista de platillos del menu
    Un ejemplo se puede ver aqui https://getbootstrap.com/docs/4.6/components/card/#using-grid-markup    
    -->

    <div>
        <div class="row">
            <div class="col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Nombre del platillo</h5>
                        <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                        <a href="#" class="btn btn-primary">Agregar al carrito</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Fin menu -->

    <script type="text/javascript">


        function cargarMenu() {
            $.ajax({
                type: 'POST',
                url: "Menu.aspx/CargarMenu",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response != "") {
                        //Aqui se debe llenar la informacion del div que esta arriba en la linea 14
                        //Deberia llenarse y luego con el append (igual que el curso de fundamentos de web agregarlo al html)
                        //El response trae una lista, entonces se puede recorrer con un ciclo e ir agregando
                    }
                }
            });
        }
    </script>

     <!-- Option 1: Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>
</body>
</html>
