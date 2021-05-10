using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class EmployeePosition
    {
        public string PositionName { private set; get; }
        public string Responsibilities { private set; get; }
        public int EmployeeRank { private set; get; }
        public int Salary { private set; get; }

        public EmployeePosition(string name, string respons, int rank, int salary)
        {
            PositionName = name;
            Responsibilities = respons;
            EmployeeRank = rank;
            Salary = salary;
        }
    }
}
