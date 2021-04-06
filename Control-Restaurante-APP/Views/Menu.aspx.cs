using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Control_Restaurante_APP.Views
{
    public partial class Menu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [System.Web.Services.WebMethod]
        public static void CargarMenu()
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                var result = client.GetAsync("api/menu").Result; //Dependiendo el metodo aquí se cambia el endpoint "api/menu"
                //TODO: cambiar al tipo de respuesta de la api. En nuestro caso una lista de platillos
                //return result.Content.ReadAsAsync<OMG.Model.Response.ManualAssignResponse>().Result.Orders;

                //Link para descargar la coleccion y probar desde postman: https://www.getpostman.com/collections/48395e5de468bd79b734

            }
        }
    }
}