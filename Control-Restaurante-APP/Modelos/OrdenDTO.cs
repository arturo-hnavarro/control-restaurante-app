using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Control_Restaurante_APP.Modelos
{
    public class OrdenDTO
    {
        public int id { get; set; }
        public string createAt { get; set; }
        public object mesa { get; set; }
        public object cliente { get; set; }
        public float total { get; set; }
        public EstadoPlatillo estadoPlatillo { get; set; }
        public List<Item> items { get; set; }

    }
}