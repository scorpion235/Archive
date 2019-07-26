using System;
using System.Configuration;
using FirebirdSql.Data.FirebirdClient;

namespace WordProcessor
{
    class Program
    {
        static void Main(string[] args)
        {
            Session.UpdateDictionary();
            Session.DeleteDictionary();
            Console.ReadKey();
        }
    }
}
