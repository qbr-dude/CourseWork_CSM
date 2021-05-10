using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;

namespace DAL.Department
{
    class Class1
    {
        static void Main(string[] args)
        {
            SQLRequestesDAO accessObject = new SQLRequestesDAO();
            List<Ticket> list = accessObject.GetTicketsForSeance(1).ToList();

            foreach (var item in list)
            {
                foreach (var prop in item.GetType().GetProperties())
                {
                    Console.WriteLine(prop.GetValue(item) + " ");
                }
                Console.WriteLine();
            }
            Console.ReadKey();
        }
    }
}
