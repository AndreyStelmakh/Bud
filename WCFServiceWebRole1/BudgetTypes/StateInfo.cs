//using Helpers;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Budget.Types
{
    [DataContract]
    public class StateInfo
    {
        /// <summary>
        /// Итоги по валютам
        /// </summary>
        [DataMember]
        public Sum[] Values { get; set; }

        /// <summary>
        /// Статьи расходов
        /// </summary>
        [DataMember]
        public exp[] ExpenditureSet { get { return _expenditureSet; } set { _expenditureSet = value;  } }

        [DataMember]
        public allocSet[] AllocationSets { get { return _allocationSets; } set { _allocationSets = value;  } }

        private exp[] _expenditureSet;
        public allocSet[] _allocationSets;

    }

    [DataContract]
    public class Sum
    {
        /// <summary>
        /// Название валюты
        /// </summary>
        public string ToolName { get; set; }

        public decimal Value { get; set; }

        public override string ToString()
        {
            return string.Format(new CultureInfo(ToolName), "{0:C0}", Value);
        }
    }

    /// <summary>
    /// Статья расходов
    /// </summary>
    public class exp
    {
        public int Id { get; set; }

        public string Name { get; set; }
    }

    public class allocSet
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public alloc[] Percentage { get; set; }
    }

    public class alloc
    {
        public int expId { get; set; }

        public decimal Percentage { get; set; }
    }
}
