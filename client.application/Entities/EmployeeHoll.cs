using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class EmployeeHoll
    {
        public int HollID { private set; get; }
        public int EmployeeID { private set; get; }
        public int StaffChangeTime { private set; get; }
        public EmployeeHoll(int hollID, int emplId, int time)
        {
            HollID = hollID;
            EmployeeID = emplId;
            StaffChangeTime = time;
        }
    }
}
