using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WordProcessor
{
    class Command
    {
        /// <summary>
        /// Создание словаря
        /// </summary>
        public static void CreateDictionary()
        {
            Session.ClearTable();

            Session.InsertWord("");

            Session.GenerateDictionary();
        }

        /// <summary>
        /// Обновление словаря
        /// </summary>
        public static void UpdateDictionary()
        {
            Session.InsertWord("");

            Session.GenerateDictionary();
        }

        /// <summary>
        /// Очистка словаря
        /// </summary>
        public static void DeleteDictionary()
        {
            Session.ClearTable();
        }
    }
}
