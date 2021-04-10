using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Control_Restaurante_APP.Modelos;

namespace Control_Restaurante_APP.Modelos
{
    public class Platillo
    {
        public int id { get; set; }
        public string nombre { get; set; }
        public float precio { get; set; }
        public string createAt { get; set; }
        public string image { get; set; }
        public Ingrediente[] ingredientes { get; set; }
        public EstadoPlatillo estadoPlatillo { get; set; }
        public TipoPlato tipoPlato { get; set; }
    }
}