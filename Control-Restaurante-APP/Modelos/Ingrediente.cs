using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Control_Restaurante_APP.Modelos
{
    public class Ingrediente
    {
        public int id { get; set; }
        public string nombre { get; set; }
        public int candidadDisponible { get; set; }
    }
}