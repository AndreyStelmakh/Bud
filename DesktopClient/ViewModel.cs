using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

using Helpers;
using Budget;
using Budget.Types;

namespace DesktopClient
{
    public enum Modes { OnSelectedExpenditure, OnSelectedAllocation }

    public class ViewModel : ExtendedNotify
    {

        public CommandBinding SaveCommandBinding;
        public CommandBinding ToggleItemSelectionCommandBinding;
        public CommandBinding DeselectAllCommandBinding;

        private RoutedCommand ToggleItemSelectionCommand = new RoutedCommand();
        //private RoutedCommand DeselectAllCommand;

        public Sum[] Sums { get { return _sums; } set { _sums = value; RaisePropertyChanged(() => Sums); } }
        public ObservableCollection<Expenditure> ExpenditureSet { get { return _expenditureSets; } set { _expenditureSets = value; RaisePropertyChanged(() => ExpenditureSet); } }
        public ObservableCollection<AllocationSet> AllocationSets { get { return _allocationSets; } set { _allocationSets = value; RaisePropertyChanged(() => AllocationSets); } }
        public int Amount { get { return _amount; } set { _amount = value; RaisePropertyChanged(() => Amount); } }
        public Modes Mode { get { return _mode; } set { _mode = value; RaisePropertyChanged(() => Mode); } }

        public ViewModel()
        {
            SaveCommandBinding = new CommandBinding(
                ApplicationCommands.Save,
                (a, b) => {
                    Amount = 0;

                    IOperation r = ServiceLocator.GetService<IOperation>();

                },
                (a, b) => { b.CanExecute = Amount > 0; });

            ToggleItemSelectionCommandBinding = new CommandBinding(
                ToggleItemSelectionCommand,
                (a,b)=> {
                    switch (Mode)
                    {
                    case Modes.OnSelectedExpenditure:
                        {
                            foreach (var item in ExpenditureSet)
                            {
                                item.IsSelected = false;
                            }

                            break;
                        }
                    case Modes.OnSelectedAllocation:
                        {
                            foreach (var item in AllocationSets)
                            {
                                item.IsSelected = false;
                            }

                            break;
                        }

                    }

                    if(b.Parameter is ISelectable)
                    {
                        ((ISelectable)b.Parameter).IsSelected = !((ISelectable)b.Parameter).IsSelected;
                    }

                });


            LoadReferences();

            Mode = Modes.OnSelectedAllocation;

        }

        void LoadReferences()
        {
            var stateInfo = ServiceLocator.GetService<Budget.IOperation>().PullStateInfo();

            _expenditureSets.Clear();
            foreach(var item
                        in stateInfo.ExpenditureSet.Select<exp, Expenditure>((a,b) =>
                                { return new Expenditure() { Id = a.Id, Name = a.Name }; }))
            {
                ExpenditureSet.Add(item);
            }

            _allocationSets.Clear();
            foreach (var item
                        in stateInfo.AllocationSets.Select<allocSet, AllocationSet>((a, b) =>
                                { return new AllocationSet() { Id = a.Id, Name = a.Name }; }))
            {
                AllocationSets.Add(item);
            }

            Sums = stateInfo.Values;
        }

        private Sum[] _sums;
        ObservableCollection<Expenditure> _expenditureSets = new ObservableCollection<Expenditure>();
        ObservableCollection<AllocationSet> _allocationSets = new ObservableCollection<AllocationSet>();
        int _amount;
        Modes _mode;

    }

    public class Expenditure : Budget.Types.exp, ISelectable
    {
        public bool IsSelected
        {
            get
            {
                return _isSelected;
            }
            set
            {
                _isSelected = value;

                RaisePropertyChanged(() => IsSelected);
            }
        }

        private bool _isSelected;
    }

    public class AllocationSet: Budget.Types.allocSet, ISelectable
    {
        public bool IsSelected
        {
            get
            {
                return _isSelected;
            }
            set
            {
                _isSelected = value;

                RaisePropertyChanged(() => IsSelected);
            }
        }

        private bool _isSelected;
    }


}
