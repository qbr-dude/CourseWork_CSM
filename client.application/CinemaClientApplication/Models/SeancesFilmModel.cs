using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CinemaClientApplication.Models
{
    public class SeancesFilmModel
    {
        public Entities.Film Film { set; get; }
        public List<Entities.Seance> Seances { set; get; }
    }
}