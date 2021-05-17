using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class Employee
    {
        public int EmployeeID { private set; get; }
        public string Position { private set; get; }
        public string EmployeeName { private set; get; }
        public PassportType Passport { private set; get; }
        public int Expirience { private set; get; }
        public string Phone { private set; get; }

        public Employee(int id, string pos, string name, PassportType pass, int exp, string phone)
        {
            EmployeeID = id;
            Position = pos;
            EmployeeName = name;
            Passport = pass;
            Expirience = exp;
            Phone = phone;
        }
    }

    public struct PassportType
    {
        public int Series { private set; get; }
        public int Number { private set; get; }
        public PassportType(string passport)
        {
            Series = Convert.ToInt32(passport.Substring(0, 4));
            Number = Convert.ToInt32(passport.Substring(4, 6));
        }
    }
}
