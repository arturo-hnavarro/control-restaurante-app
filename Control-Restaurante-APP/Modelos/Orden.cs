using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Control_Restaurante_APP.Modelos
{
    public class Orden
    {
        public int IdEstado { get; set; }
        public Mesa mesa { get; set; }
        public string cliente { get; set; }
        public double total { get; set; }
        public List<Item> items { get; set; }
    }
}