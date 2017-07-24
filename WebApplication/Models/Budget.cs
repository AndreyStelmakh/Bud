using System;
using System.Collections.Generic;

namespace WebApplication.Models
{
    public partial class Budget
    {
        public Guid IncomeId { get; set; }
        public Guid ExpenditureId { get; set; }
        public decimal Value { get; set; }

        public virtual Expenditure Expenditure { get; set; }
        public virtual Earnings Income { get; set; }
    }
}
