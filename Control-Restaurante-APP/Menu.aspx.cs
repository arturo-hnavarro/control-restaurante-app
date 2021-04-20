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
                    List<Platillo> platillos = result.Content.ReadAsAsync<List<Platillo>>().Result;

                    platillos.ForEach(x => x.image = Convert.ToBase64String(x.imageInBytes));
                    platillos.ForEach(x => x.imageInBytes = null);
                    return platillos;
                }
            }
            catch
            {
                return null;
            }
        }
        [System.Web.Services.WebMethod]
        public static string EnviarOrden(int idMesa, string cliente, double total, List<Item> platillos)
        {
            try
            {
                if (platillos != null)
                {
                    OrdenDTO response = null;
                    Orden request = new Orden
                    {
                        mesa = new Mesa { id = idMesa },
                        cliente = cliente,
                        total = total,
                        items = platillos
                    };
                    using (var client = new HttpClient())
                    {
                        client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                        var result = client.PostAsJsonAsync("api/ordenes/salvar", request).Result;

                        if (result.StatusCode == System.Net.HttpStatusCode.Created)
                        {
                            response = result.Content.ReadAsAsync<OrdenDTO>().Result;
                            return $"Su orden número <strong>{response.id}</strong> fue creada con exito.";
                        }
                    }
                }
            }
            catch
            {
                return "";
            }
            return "";
        }
    }
}

