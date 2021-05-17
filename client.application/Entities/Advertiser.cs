using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class Advertiser
    {
        public int AdvertiserID { private set; get; }
        public string AdvertiserName { private set; get; }
        public string CompanyName { private set; get; }
        public string AdvertiserPhone { private set; get; }
        public Advertiser(int id, string name, string companyName, string phone)
        {
            AdvertiserID = id;
            AdvertiserName = name;
            CompanyName = companyName;
            AdvertiserPhone = phone;
        }
    }
}
