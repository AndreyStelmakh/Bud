using System;
using System.Collections.Generic;

namespace WebApplication.Models
{
    public partial class Expenditure
    {
        public Expenditure()
        {
            Budget = new HashSet<Budget>();
            DistributionsDetails = new HashSet<DistributionsDetails>();
        }

        public Guid Id { get; set; }
        public string Title { get; set; }
        public string Properties { get; set; }

        public virtual ICollection<Budget> Budget { get; set; }
        public virtual ICollection<DistributionsDetails> DistributionsDetails { get; set; }
    }
}
