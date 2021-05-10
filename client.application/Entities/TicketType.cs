using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class TicketType
    {
        public string TypeName { private set; get; }
        public string TypeDescription { private set; get; }
        public int Discount { private set; get; }

        public TicketType(string name, string descr, int disc)
        {
            TypeName = name;
            TypeDescription = descr;
            Discount = disc;
        }
    }
}
