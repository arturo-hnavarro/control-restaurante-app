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
    public partial class Ordenes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [System.Web.Services.WebMethod]
        public static List<OrdenDTO> CargarOrdenes()
        {
            try
            {
                using(var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.GetAsync("api/ordenes").Result;
                    List<OrdenDTO> ordenes = result.Content.ReadAsAsync<List<OrdenDTO>>().Result;
                    return ordenes;
                }

            }catch
            {
                return null;
            }
        }
    }
}