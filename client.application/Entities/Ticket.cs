using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class Ticket
    {
        public int TicketID { private set; get; }
        public string TicketType { private set; get; }
        public int CashboxID { private set; get; }
        public int SeanceId { private set; get; }
        public int RowNumber { private set; get; }
        public int SeatNumber { private set; get; }
        public int Cost { private set; get; }
        public Ticket(int id, string type, int cashId, int seanceId, int row, int seat, int cost)
        {
            TicketID = id;
            TicketType = type;
            CashboxID = cashId;
            SeanceId = seanceId;
            RowNumber = row;
            SeatNumber = seat;
            Cost = cost;
        }

    }
}
