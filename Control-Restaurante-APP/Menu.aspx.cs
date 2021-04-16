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
            //Coleccion de postman
            //https://www.getpostman.com/collections/48395e5de468bd79b734
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
                    List<Platillo>  platillos = result.Content.ReadAsAsync<List<Platillo>>().Result;
                    
                    platillos.ForEach(x => x.image = Convert.ToBase64String(x.imageInBytes));
                    platillos.ForEach(x => x.imageInBytes = null);
                    return platillos;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }
}

