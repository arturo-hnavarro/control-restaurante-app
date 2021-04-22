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
    public partial class TipoPlatillos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [System.Web.Services.WebMethod]
        public static TipoPlato Salvar(string id, string nombre, string descripcion)
        {
            try
            {
                TipoPlato tipo = MapperTipoPlatillo(id, nombre, descripcion);
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.PostAsJsonAsync("api/tipo-plato/", tipo).Result;
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                        return result.Content.ReadAsAsync<TipoPlato>().Result;
                }
            }
            catch
            {
                return null;
            }
            return null;
        }

        [System.Web.Services.WebMethod]
        public static TipoPlato BuscarPorId(string idTipo)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.GetAsync("api/tipo-plato/ver?id="+ idTipo).Result;
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                    {
                        return result.Content.ReadAsAsync<TipoPlato>().Result;
                    }
                }
            }
            catch
            {
                return null;
            }
            return null;
        }
    
        private static TipoPlato MapperTipoPlatillo(string id, string nombre, string descripcion)
        {
            TipoPlato tipo = new TipoPlato();
            if (!String.IsNullOrEmpty(id))
                tipo.id = Int32.Parse(id);
            if (String.IsNullOrEmpty(nombre))
                throw new ArgumentNullException();
                tipo.nombre = nombre;
            if (String.IsNullOrEmpty(descripcion))
                throw new ArgumentNullException();
            tipo.descripcion = descripcion;
            return tipo;
        }

    }
}