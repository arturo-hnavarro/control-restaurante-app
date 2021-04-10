using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Control_Restaurante_APP.Modelos;

namespace Control_Restaurante_APP.Views
{
    public partial class Menu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CargarMenu();
        }

        [System.Web.Services.WebMethod]
        public static List<Platillo> CargarMenu()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.GetAsync("api/menu").Result;
                    return result.Content.ReadAsAsync<List<Platillo>>().Result;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
            //Dependiendo el metodo aquí se cambia el endpoint "api/menu"
            //TODO: cambiar al tipo de respuesta de la api. En nuestro caso una lista de platillos
            //return result.Content.ReadAsAsync<OMG.Model.Response.ManualAssignResponse>().Result.
        }

    }
}

