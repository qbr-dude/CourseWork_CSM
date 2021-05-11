using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Helpers;

namespace CinemaClientApplication.Models
{
    public class SeanceHollModel
    {
        public Entities.CinemaHoll Holl { set; get; }
        public List<Entities.Ticket> Tickets { set; get; }
        public Entities.Seance Seance { set; get; }
    }
}