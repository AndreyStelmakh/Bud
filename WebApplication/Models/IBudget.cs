using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApplication.Models.BudgetViewModels;

namespace WebApplication.Models
{
    interface IBudget
    {
        List<TV> Summary();
    }
}
