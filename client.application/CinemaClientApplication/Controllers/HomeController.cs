using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DAL.Department;

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
            Models.SeancesFilmModel model = new Models.SeancesFilmModel();
            model.Seances = requestDAO.GetSeancesForFilms(id).ToList();
            model.Film = requestDAO.GetFilmById(id);
            return View(model);
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}