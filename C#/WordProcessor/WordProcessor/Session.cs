using System;
using System.Configuration;
using FirebirdSql.Data.FirebirdClient;

namespace WordProcessor
{
    public class Session
    {
        public static bool IsConnected
        {
            get
            {
                return сonnection != null && сonnection.State == System.Data.ConnectionState.Open;
            }
        }

        private static FbConnection сonnection;
        private static FbConnection Connection
        {
            get
            {
                if (!IsConnected)
                {
                    OpenSession();
                }

                return сonnection;
            }
        }

        public static void OpenSession()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["FBConnection"].ConnectionString;
                сonnection = new FbConnection(connectionString);
                сonnection.Open();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        public static void CloseSession()
        {
            try
            {
                сonnection.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        /// <summary>
        /// Вставка слова
        /// </summary>
        /// <param name="word"></param>
        public static void InsertWord(string word)
        {
            try
            {                
                FbTransaction transaction = Connection.BeginTransaction();

                FbCommand command = new FbCommand("EXECUTE PROCEDURE PKB_WORDS.INSERT_DATA(@WORD)", Connection, transaction);
                command.Parameters.Add("@WORD", FbDbType.VarChar);
                command.Parameters[0].Value = word;
                command.ExecuteNonQuery();

                transaction.Commit();
                command.Dispose();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        /// <summary>
        /// Сгенерировать словарь
        /// </summary>
        public static void GenerateDictionary()
        {
            try
            {
                FbTransaction transaction = Connection.BeginTransaction();

                FbCommand command = new FbCommand("EXECUTE PROCEDURE PKB_DICTIONARY.GENERATE", Connection, transaction);
                command.ExecuteNonQuery();

                transaction.Commit();
                command.Dispose();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        /// <summary>
        /// Выборка из словаря (возвращает 5 подходящих слов)
        /// </summary>
        /// <param name="word"></param>
        public static void DictionarySelection(string word)
        {
            FbTransaction transaction = Connection.BeginTransaction();

            FbCommand command = new FbCommand("SELECT WORD FROM PKB_DICTIONARY.SELECT_DATA(@WORD)", Connection, transaction);
            command.Parameters.Add("@WORD", FbDbType.VarChar);
            command.Parameters[0].Value = word;
            FbDataReader reader = command.ExecuteReader();

            while (reader.Read())
            {
                Console.WriteLine(string.Format("{0}", reader[0]));
            }

            transaction.Commit();
            command.Dispose();
        }

        /// <summary>
        /// Очистка таблиц
        /// </summary>
        public static void ClearTable()
        {
            FbTransaction transaction = Connection.BeginTransaction();

            FbCommand command = new FbCommand("EXECUTE PROCEDURE PKB_WORDS.DELETE_DATA", Connection, transaction);
            command.ExecuteNonQuery();

            command.CommandText = "EXECUTE PROCEDURE PKB_DICTIONARY.DELETE_DATA";
            command.ExecuteNonQuery();

            transaction.Commit();
            command.Dispose();
        }
    }
}
