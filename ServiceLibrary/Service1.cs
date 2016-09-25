using System;
using Budget.Types;

namespace Budget
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in both code and config file together.
    public class Service1 : IOperation
    {
        public StateInfo PullStateInfo()
        {
            throw new NotImplementedException();
        }

        public void PushOnAllocationSet(int allocationSetId, int amount)
        {
            throw new NotImplementedException();
        }

        public void PushOnExpenditure(int expenditureId, int amount)
        {
            throw new NotImplementedException();
        }
    }
}
