using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace DesktopClient.StylesTemplates
{
    public class ItemListTemplateSelector : DataTemplateSelector
    {
        public DataTemplate SelectedItemTemplate { get; set; }
        public DataTemplate DeselectedItemTemplate { get; set; }

        public override DataTemplate SelectTemplate(object item, System.Windows.DependencyObject container)
        {
            return SelectedItemTemplate;

            return base.SelectTemplate(item, container);
        }
    }
}
