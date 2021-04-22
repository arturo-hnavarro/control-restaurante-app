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
    public partial class Platillos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        
        [System.Web.Services.WebMethod]
        public static Platillo Salvar(string id, string nombre, string precio, List<string> ingredientes, string tipoPlato, string estadoPlatillo, string imagePath)
        {
            try
            {
                Platillo platillo = MapperPlatillo(id, nombre, precio, ingredientes, tipoPlato, estadoPlatillo, imagePath);
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.PostAsJsonAsync("api/menu/", platillo).Result;
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                        return result.Content.ReadAsAsync<Platillo>().Result;
                }
            }
            catch
            {
                return null;
            }
            return null;
        }

        [System.Web.Services.WebMethod]
        public static Platillo BuscarPorId(string idPlatillo)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.GetAsync("api/menu/ver/?id=" + idPlatillo).Result;
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                    {
                        Platillo platillo = result.Content.ReadAsAsync<Platillo>().Result;
                        platillo.imagePath = platillo.image;
                        platillo.image = Convert.ToBase64String(platillo.imageInBytes);
                        platillo.imageInBytes = null;
                        return platillo;
                    }
                }
            }
            catch
            {
                return null;
            }
            return null;
        }

        [System.Web.Services.WebMethod]
        public static List<EstadoPlatillo> Estados()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.GetAsync("/api/estados/platillos").Result;
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                        return result.Content.ReadAsAsync<List<EstadoPlatillo>>().Result;
                }
            }
            catch (Exception ignore)
            {
                return null;
            }
            return null;
        }

        [System.Web.Services.WebMethod]
        public static List<TipoPlato> GetTipos()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.GetAsync("/api/tipo-plato").Result;
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                        return result.Content.ReadAsAsync<List<TipoPlato>>().Result;
                }
            }
            catch (Exception ignore)
            {
                return null;
            }
            return null;
        }

        [System.Web.Services.WebMethod]
        public static List<Ingrediente> GetCatalogoIngredientes()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.GetAsync("/api/catalogo").Result;
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                        return result.Content.ReadAsAsync<List<Ingrediente>>().Result;
                }
            }
            catch (Exception ignore)
            {
                return null;
            }
            return null;
        }

        private static Platillo MapperPlatillo(string id, string nombre, string precio, List<string> ingredientes, string tipoPlato, string estadoPlatillo, string imagePath)
        {
            Platillo platillo = new Platillo();
            
            if (!String.IsNullOrEmpty(id))
                platillo.id = Int32.Parse(id);
            
            platillo.nombre = nombre;
            platillo.precio = float.Parse(precio);
            platillo.tipoPlato = new TipoPlato()
            {
                id = Int32.Parse(tipoPlato)
            };
            platillo.estadoPlatillo = new EstadoPlatillo()
            {
                id = Int32.Parse(estadoPlatillo)
            };

            Ingrediente[] ingredientesList = new Ingrediente[ingredientes.Count];
            for (int i=0; i< ingredientes.Count; i++)
            {
                ingredientesList[i] = (new Ingrediente()
                {
                    id = Int32.Parse(ingredientes[i])
                });
            }
            platillo.ingredientes = ingredientesList;
            platillo.image= imagePath;
            return platillo;
        }
    }
}
