using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    class AdvertisingSeance
    {
        public int SeanceId { private set; get; }
        public int AdvertisingId { private set; get; }
        public AdvertisingSeance(int seance, int ad)
        {
            SeanceId = seance;
            AdvertisingId = ad;
        }
    }
}
