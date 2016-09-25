
using Budget.Types;
using Helpers;
using System;
using System.Runtime.Serialization;
using System.ServiceModel;

namespace Budget
{
    [ServiceContract]
    interface IOperation
    {
        void PushOnExpenditure(int expenditureId, int amount);
        void PushOnAllocationSet(int allocationSetId, int amount);
        StateInfo PullStateInfo();
    }
}
