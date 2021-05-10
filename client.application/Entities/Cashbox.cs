using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class Cashbox
    {
        public int CashboxID { private set; get; }
        public int EmployeeID { private set; get; }
        public int StaffChangeTime { private set; get; }
        public int WorkTime { private set; get; }

        public Cashbox(int id, int emplId, int time, int wTime)
        {
            CashboxID = id;
            EmployeeID = emplId;
            StaffChangeTime = time;
            WorkTime = wTime;
        }
    }
}
