using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class SeanceType
    {
        public string TypeName { private set; get; }
        public string TypeDescription { private set; get; }

        public SeanceType(string name, string descr)
        {
            TypeName = name;
            TypeDescription = descr;
        }

    }
}
