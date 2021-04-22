using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Control_Restaurante_APP.Modelos
{
    public class LoginDTO
    {
        public User user { get; set; }
        public string status { get; set; }
        public string message { get; set; }
    }

    public class User
    {
        public int id { get; set; }
        public string username { get; set; }
        public string password { get; set; }
        public bool enabled { get; set; }
        public string nombre { get; set; }
        public string apellido { get; set; }
        public string email { get; set; }
        public Rol[] roles { get; set; }
    }
}