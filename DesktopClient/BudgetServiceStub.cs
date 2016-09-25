using Budget;
using Budget.Types;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesktopClient
{
    public class BudgetServiceStub : IOperation
    {
        public void PushOnExpenditure(int expenditureId, int amount)
        {
            throw new NotImplementedException();
        }

        public void PushOnAllocationSet(int allocationSetId, int amount)
        {
            throw new NotImplementedException();
        }

        public StateInfo PullStateInfo()
        {
            var result = new StateInfo();

            result.Values = new Sum[] { new Sum() { ToolName = "ru-RU", Value = 101M }, new Sum() { ToolName = "en-US", Value = 10.121M } };

            result.ExpenditureSet = new exp[] {
                new exp { Id = 1, Name = "перська" },
                new exp { Id = 2, Name = "коф" },
                new exp { Id = 3, Name = "дрв" },
                new exp { Id = 4, Name = "штр" }};

            result.AllocationSets = new allocSet[]{
                new allocSet { Id = 1, Name = "т",
                               Percentage = new alloc[]{
                                    new alloc{ expId = 1, Percentage = 5.5M },
                                    new alloc{ expId = 2, Percentage = 15.5M },
                                    new alloc{ expId = 3, Percentage = 5.0M }}},
                new allocSet { Id = 2, Name = "а",
                               Percentage = new alloc[]{
                                    new alloc{ expId = 1, Percentage = 15.5M },
                                    new alloc{ expId = 2, Percentage = 10.5M },
                                    new alloc{ expId = 3, Percentage = 1.0M }}},
            };

            return result;
        }
    }

}
