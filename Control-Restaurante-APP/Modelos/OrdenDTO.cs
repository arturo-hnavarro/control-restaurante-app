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
        public Mesa mesa { get; set; }
        public string cliente { get; set; }
        public float total { get; set; }
        public EstadoOrden estadoOrden { get; set; }
        public List<Item> items { get; set; }
    }
}