using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;

namespace WebApplication.Models.BudgetViewModels
{
    public class SummaryViewModel
    {
        public List<TV> ByTools { get { return _byToolsLazy.Value; } set { } }

        Lazy<List<TV>> _byToolsLazy = new Lazy<List<TV>>(() => {
            return new List<TV>(new []{
                new TV(Tool.Рубль, 14),
                new TV(Tool.Доллар, 12) });
        });

    }

    public class TV
    {
        public Tool Tool;
        public decimal Amount;
        public TV(Tool tool, decimal amount)
        {
            this.Tool = tool;
            this.Amount = amount;
        }

        public override string ToString()
        {
            return string.Format(Tool?.Format ?? "{0}", Amount);
        }
    }
    public class Tool
    {
        public int Order;
        public string Format;

        public static Tool Рубль { get; private set; }
        public static Tool Доллар { get; private set; }
        public static Tool Евро { get; private set; }

        static Tool()
        {
            Рубль = new Tool() { Order = 0, Format = "{0}₽" };
            Доллар = new Tool() { Order = 1, Format = "${0}" };
            Евро = new Tool() { Order = 2, Format = "{0}€" };
        }
        private Tool()
        {

        }
    }
}
