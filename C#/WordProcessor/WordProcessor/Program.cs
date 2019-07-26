using System;
using System.Configuration;
using FirebirdSql.Data.FirebirdClient;

namespace WordProcessor
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length > 1)
            {
                Console.WriteLine("Количество параметров командной строки не может быть больше одного.\r\n" +
                    "Допустимые значения параметров командной строки:\r\n-create\r\n-update\r\n-delete\r\n" +
                    "Для завершения нажмите любую клавишу.");
                Console.ReadKey();
                return;
            }

            if (args.Length == 1)
            {
                if (args[0].ToString() == "-create")
                {
                    Command.CreateDictionary();
                    Console.WriteLine("Создание словаря завершено.");
                }
                else if (args[0].ToString() == "-update")
                {
                    Command.UpdateDictionary();
                    Console.WriteLine("Обновление словаря завершено.");
                }
                else if (args[0].ToString() == "-delete")
                {
                    Command.DeleteDictionary();
                    Console.WriteLine("Очистка словаря завершена.");
                }
                else
                {
                    Console.WriteLine("Неизвестный параметр командной строки.\r\n" +
                    "Допустимые значения параметров командной строки:\r\n-create\r\n-update\r\n-delete");
                }
                Console.WriteLine("Для завершения нажмите любую клавишу.");
                Console.ReadKey();
                return;
            }

            //нет параметров командной строки (режим ввода)
            string word = string.Empty;
            while ((word = Console.ReadLine()) != string.Empty)
            {
                Command.DictionarySelection(word);
            }
        }
    }
}
