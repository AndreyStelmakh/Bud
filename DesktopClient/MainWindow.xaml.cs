using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

//using System.Collections


namespace DesktopClient
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        ViewModel VM { get { return this.DataContext as ViewModel; } set { DataContext = value; } }

        public MainWindow()
        {
            InitializeComponent();

            VM = new ViewModel();

            CommandBindings.Add(VM.SaveCommandBinding);
            CommandBindings.Add(VM.ToggleItemSelectionCommandBinding);
            
            R.AddHandler(
                FrameworkElement.MouseDownEvent,
                new RoutedEventHandler((a, b) =>
                {
                    var part = b.OriginalSource as Border;
                    if(part != null)
                    {
                        VM.ToggleItemSelectionCommandBinding.Command.Execute(part.DataContext);
                    }
                }));

            R1.AddHandler(
                FrameworkElement.MouseDownEvent,
                new RoutedEventHandler((a, b) =>
                {
                    var part = b.OriginalSource as Border;
                    if (part != null)
                    {
                        VM.ToggleItemSelectionCommandBinding.Command.Execute(part.DataContext);
                    }
                }));
        }
    }
}
