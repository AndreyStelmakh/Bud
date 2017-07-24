using System;
using System.Collections.Generic;

namespace WebApplication.Models
{
    public partial class Earnings
    {
        public Earnings()
        {
            Budget = new HashSet<Budget>();
        }

        public Guid Id { get; set; }
        public DateTime RegisteredAt { get; set; }
        public string Tool { get; set; }
        public string Properties { get; set; }

        public virtual ICollection<Budget> Budget { get; set; }
    }
}
