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

    //Para hacer post con la informacion enviada desde JavaScript
    /*
    [System.Web.Services.WebMethod(EnableSession = true)]
    public static string Update(string pkReason, string internalName, string descriptionSPA, string descriptionENG)
    {
        try
        {
            if (!pkReason.IsNullOrEmpty() && !internalName.IsNullOrEmpty() && !descriptionSPA.IsNullOrEmpty() && !descriptionENG.IsNullOrEmpty())
            {
                Aeropost.Framework.Model.OMG.ItemCancelledReason request = new Aeropost.Framework.Model.OMG.ItemCancelledReason
                {
                    Pk_Catalogue = pkReason.ToInt(),
                    InternalName = internalName,
                    DescriptionSPA = descriptionSPA,
                    DescriptionENG = descriptionENG
                };

                System.Net.ServicePointManager.ServerCertificateValidationCallback = ((sender, cert, chain, errors) => true);

                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["URL_OMG"]);
                    var result = client.PostAsJsonAsync("api/Item/updateReason", request).Result;

                    string response = result.Content.ReadAsAsync<string>().Result;
                    if (!response.IsNullOrEmpty())
                    {
                        throw new Exception(response);
                    }
                    return "";
                }
            }
            else throw new Exception("Empty fields: Could not save motive.");
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }//Fin metodo
    */
}

