using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WebApplication.Models;
using WebApplication.Models.BudgetViewModels;

namespace WebApplication.Controllers
{
    public class BudgetController : Controller
    {
        public IActionResult Summary()
        {
            ViewData["Message"] = "Your application description (Summary) page.";

            ViewData["list"] = new List<string>(new []{"sdfs", "llko" });

            return View(new WebApplication.Models.BudgetViewModels.SummaryViewModel());
        }

        public IActionResult Error()
        {
            return View();
        }
    }
}
