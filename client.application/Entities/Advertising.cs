using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class Advertising
    {
        public int AdID { private set; get; }
        public int Employee { private set; get; }
        public int Advertiser { private set; get; }
        public string AdvertisingName { private set; get; }
        public int AdvertisingDuration { private set; get; }
        public decimal AdvertisingCost { private set; get; }

        public Advertising(int id, int emplId, int advId, string name, int duration, int cost)
        {
            AdID = id;
            Employee = emplId;
            Advertiser = advId;
            AdvertisingName = name;
            AdvertisingDuration = duration;
            AdvertisingCost = cost;
        }
    }
}
