using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Helpers;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using DAL.Department;
using Newtonsoft.Json;

namespace CinemaClientApplication.Controllers
{
    public class HomeController : Controller
    {
        private readonly SQLRequestesDAO requestDAO;
        public HomeController()
        {
            requestDAO = new SQLRequestesDAO();
        }
        public ActionResult Index()
        {
            return View(requestDAO.GetAllFilms().ToList());
        }

        public ActionResult FilmInfo(int id)
        {
            Models.SeancesFilmModel model = new Models.SeancesFilmModel
            {
                Seances = requestDAO.GetSeancesForFilms(id).ToList(),
                Film = requestDAO.GetFilmById(id)
            };
            return View(model);
        }

        public ActionResult SeanceSeats(int id)
        {
            Models.SeanceHollModel model = new Models.SeanceHollModel
            {
                Tickets = requestDAO.GetTicketsForSeance(id).ToList(),
                Holl = requestDAO.GetCinemaHollInfoBySeance(id),
                Seance = requestDAO.GetSeanceInfo(id)
            };

            return View(model);
        }
        [HttpPost]
        public ActionResult CreateTickets(string tickets)
        {
            var jsonRow = JsonConvert.DeserializeObject<string[]>(tickets);
            List<Entities.Ticket> ticketsInfo = new List<Entities.Ticket>();
            foreach (var str in jsonRow)
            {
                string[] row = str.Split('-');
                ticketsInfo.Add(new Entities.Ticket(Entities.Ticket.LastId + 1, "standart", 0, Convert.ToInt32(row[0]), Convert.ToInt32(row[1]), Convert.ToInt32(row[2]), Convert.ToInt32(row[3])));
            }

            requestDAO.CreateTickets(ticketsInfo);

            return RedirectToAction("Index");
        }
    }
}