using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using DAL.Department;
using Newtonsoft.Json;

namespace CinemaClientApplication.Controllers
{
    public class HomeController : Controller
    {
        private readonly SQLManagerDAO requestDAO;
        public HomeController()
        {
            requestDAO = new SQLManagerDAO();
            SelectList films = new SelectList(requestDAO.GetAllFilms(), "FilmID", "FilmName");
            ViewBag.Films = films;
            ViewBag.Seances = films;
        }
        public ActionResult Index(int? removeSuccess)
        {
            if(removeSuccess != null)ViewBag.Remove = removeSuccess;
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

        [HttpPost]
        public ActionResult RemoveTickets(FormCollection form)
        {
            int seance = int.Parse(form["Seances"]);
            string tickets = form["Tickets"];
            int? result = requestDAO.RemoveTickets(seance, tickets);
            return RedirectToAction("Index", "Home", new { removeSuccess = result});
        }
        [HttpGet]
        public PartialViewResult _SeancesSearch(int film)
        {
            List<Entities.Seance> seances = requestDAO.GetSeancesForFilms(film).ToList();
            SelectList listItems = new SelectList(seances, "SeanceID", "ShowTime");
            if (seances.Count == 0)
            {

                listItems = new SelectList(new List<SelectListItem> { new SelectListItem { Value = "-1", Text = "Не найдено сеансов" } }, "Value", "Text");
            }
            ViewBag.Seances = listItems;
            return PartialView(listItems);
        }
    }
}