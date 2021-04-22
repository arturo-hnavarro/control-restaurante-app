using Control_Restaurante_APP.Modelos;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Control_Restaurante_APP
{
    public partial class Inventario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [System.Web.Services.WebMethod]
        public static Ingrediente Salvar(string id, string nombre, string cantidad)
        {
            try
            {
                Ingrediente ingrediente = MapperIngrediente(id, nombre, cantidad);
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.PostAsJsonAsync("api/catalogo", ingrediente).Result;
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                        return result.Content.ReadAsAsync<Ingrediente>().Result;
                }
            }
            catch
            {
                return null;
            }
            return null;
        }

        [System.Web.Services.WebMethod]
        public static List<Ingrediente> Get()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.GetAsync("api/catalogo").Result;
                    if(result.StatusCode == System.Net.HttpStatusCode.OK)
                        return result.Content.ReadAsAsync<List<Ingrediente>>().Result;
                }
            }
            catch
            {
                return null;
            }
            return null;
        }

        [System.Web.Services.WebMethod]
        public static Ingrediente BuscarPorId(string idProducto)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.GetAsync("api/catalogo/ver?id=" + idProducto).Result;
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                    {
                        return result.Content.ReadAsAsync<Ingrediente>().Result;
                    }
                }
            }
            catch
            {
                return null;
            }
            return null;
        }
        private static Ingrediente MapperIngrediente(string id, string nombre, string cantidad)
        {
            Ingrediente ingrediente = new Ingrediente();
            if (!String.IsNullOrEmpty(id))
                ingrediente.id = Int32.Parse(id);
            if (String.IsNullOrEmpty(nombre))
                throw new ArgumentNullException();
            ingrediente.nombre = nombre;
            if (String.IsNullOrEmpty(cantidad))
                throw new ArgumentNullException();
            ingrediente.candidadDisponible = Int32.Parse(cantidad);
            return ingrediente;
        }
    }
}