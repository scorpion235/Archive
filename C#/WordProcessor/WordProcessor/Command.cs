using System;
using System.IO;
using System.Text;
using System.Configuration;

namespace WordProcessor
{
    public class Command
    {
        private static string dictionaryPath = ConfigurationManager.AppSettings["DictionaryPath"].ToString();

        private static bool existsFile()
        {
            bool result = File.Exists(dictionaryPath);

            if (!result)
            {
                Console.WriteLine(string.Format("Справочник не найден: {0}", dictionaryPath));
            }

            return result;
        }

        /// <summary>
        /// Создание словаря
        /// </summary>
        public static void CreateDictionary()
        {
            if (!existsFile())
            {
                return;
            }

            Session.ClearTable();

            UpdateDictionary();
        }

        /// <summary>
        /// Обновление словаря
        /// </summary>
        public static void UpdateDictionary()
        {
            if (!existsFile())
            {
                return;
            }

            using (TextReader reader = new StreamReader(dictionaryPath, Encoding.UTF8))
            {
                string word = string.Empty;
                long step = 100;
                long cnt = 0;

                while ((word = reader.ReadLine()) != null)
                {
                    if (word.Trim().Length >= 3 && word.Trim().Length <= 15)
                    Session.InsertWord(word.Trim());

                    cnt++;

                    if (cnt == step)
                    {
                        Console.WriteLine(string.Format("Обработано {0} строк словаря", step));
                        step += 100;
                    }
                }
                Console.WriteLine(string.Format("Обработано {0} строк словаря", cnt));
            }

            Session.GenerateDictionary();
        }

        /// <summary>
        /// Автодополнение из словаря
        /// </summary>
        /// <param name="word"></param>
        public static void DictionarySelection(string word)
        {
            Session.DictionarySelection(word);
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
