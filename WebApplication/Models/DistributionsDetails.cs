using System;
using System.Collections.Generic;

namespace WebApplication.Models
{
    public partial class DistributionsDetails
    {
        public Guid DistributionId { get; set; }
        public Guid ExpenditureId { get; set; }
        public decimal Percentage { get; set; }

        public virtual Distributions Distribution { get; set; }
        public virtual Expenditure Expenditure { get; set; }
    }
}
