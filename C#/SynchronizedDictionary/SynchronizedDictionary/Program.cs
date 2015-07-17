using System;
using System.Collections.Generic;
using Synchronized;

namespace SynchronizedDictionary
{   
    class Program
    {
        static void Main()
        {
            SynchronizedDictionary<int, string> dic = new SynchronizedDictionary<int, string>();

            // Генерация 20-ти элиментов коллекции
            for (int i = 1; i <= 20; i++)
            {
                dic.Add(i, "value" + i.ToString());
            }

            ICollection<int> keys = dic.Keys;
            foreach (int i in keys)
            {
                Console.WriteLine("key: {0} value: {1}", i, dic[i]);
            }

            // Поиск в коллекции по ключу 21
            if (!dic.ContainsKey(21))
            {
                dic.Add(21, "value21");
                Console.WriteLine("Добавлено значение для ключа = \"21\": {0}", dic[21]);
            }

            // Попытка получить значение по ключу 30
            string value = "";
            if (dic.TryGetValue(30, out value))
            {
                Console.WriteLine("key = \"30\", value = {0}", value);
            }
            else
            {
                Console.WriteLine("key = \"30\" не найден");
            }

            Console.Out.WriteLine("\r\nДля продолжения нажмите любую клавишу...");
            Console.ReadLine();
        }
    }
}