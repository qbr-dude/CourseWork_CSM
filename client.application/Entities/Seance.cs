using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class Seance
    {
        public int SeanceId { private set; get; }
        public int FilmID { private set; get; }
        public int HollID { private set; get; }
        public DateTime ShowTime { private set; get; }
        public int AgeRating { private set; get; }
        public string SeanceType { private set; get; }
        public decimal TicketCost { private set; get; }

        public Seance(int id, int filmID, int hollID, DateTime time, int rating, string type, int cost)
        {
            SeanceId = id;
            FilmID = filmID;
            HollID = hollID;
            ShowTime = time;
            AgeRating = rating;
            SeanceType = type;
            TicketCost = cost;
        }
    }
}
