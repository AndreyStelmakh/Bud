using Budget;
using Budget.Types;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesktopClient
{
    public static class ServiceLocator
    {
        private static Lazy<IOperation> _IBudgetOperationStubLazy = new Lazy<IOperation>(() => { return new BudgetServiceStub(); });
        private static Lazy<IOperation> _IBudgetOperationLazy = new Lazy<IOperation>(() => { return new BudgetServiceStub(); });

        static ServiceLocator()
        {
            _services.Add(typeof(IOperation), _IBudgetOperationStubLazy);
            //_services.Add(typeof(IOperation), _IBudgetOperationLazy);
        }

        public static T GetService<T>()
        {
            try
            {
                return (_services[typeof(T)] as Lazy<T>).Value;
            }
            catch (KeyNotFoundException)
            {
                throw new ApplicationException("The requested service is not registered");
            }
        }

        private static IDictionary<object, object> _services = new Dictionary<object, object>();
    }
}

