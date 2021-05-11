using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class CinemaHoll
    {
        public int HollID { private set; get; }
        public bool TdEnable { private set; get; }
        public int RowNumber { private set; get; }
        public int SeatNumber { private set; get; }

        public CinemaHoll(int id, bool td, int rows, int seats)
        {
            HollID = id;
            TdEnable = td;
            RowNumber = rows;
            SeatNumber = seats;
        }
    }
}
