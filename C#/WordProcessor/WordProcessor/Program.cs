using System;
using System.Configuration;
using FirebirdSql.Data.FirebirdClient;

namespace WordProcessor
{
    class Program
    {
        static void Main(string[] args)
        {            
            string connectionString = ConfigurationManager.ConnectionStrings["FBConnection"].ConnectionString;

            FbConnection myConnection = new FbConnection(connectionString);
            
            try
            {
                myConnection.Open();

                FbTransaction myTransaction = myConnection.BeginTransaction();

                FbCommand myCommand = new FbCommand();
                myCommand.CommandText = "EXECUTE PROCEDURE PKB_WORDS.INSERT_DATA(@WORD)";
                myCommand.Connection = myConnection;
                myCommand.Transaction = myTransaction;
                myCommand.Parameters.Add("@WORD", FbDbType.VarChar);
                myCommand.Parameters[0].Value = "тест";
                myCommand.ExecuteNonQuery();

                myTransaction.Commit();
                myCommand.Dispose();
                myConnection.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}
