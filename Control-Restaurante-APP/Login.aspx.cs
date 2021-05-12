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
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [System.Web.Services.WebMethod]
        public static LoginDTO Acceder(string username, string password)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restaurante-api"]);
                    var result = client.GetAsync("api/user/login?username=" + username + "&password=" + password).Result;
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                    {
                        LoginDTO response = result.Content.ReadAsAsync<LoginDTO>().Result;
                        return response;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch
            {
                return null;
            }
        }
    }
}