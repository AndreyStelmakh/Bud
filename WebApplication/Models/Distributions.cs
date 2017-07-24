using System;
using System.Collections.Generic;

namespace WebApplication.Models
{
    public partial class Distributions
    {
        public Distributions()
        {
            DistributionsDetails = new HashSet<DistributionsDetails>();
        }

        public Guid Id { get; set; }
        public string Title { get; set; }

        public virtual ICollection<DistributionsDetails> DistributionsDetails { get; set; }
    }
}
