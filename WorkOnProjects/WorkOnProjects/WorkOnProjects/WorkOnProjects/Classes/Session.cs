using System;
using System.Windows.Forms;
using System.Configuration;
using System.Data.SqlClient;

namespace WorkOnProjects.Classes
{
  public class Session
  {
    public static SqlConnection sqlConnection;

    //открываем подключение
    public static bool OpenConnection()
    {
      string connString = string.Empty;
      
      try
      {
        ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["Name"];
        connString = settings.ConnectionString;
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Проверьте настройки подключения в 'app.config'\n\n{0}", ex.Message));
        return false;
      }

      try
      {
        sqlConnection = new SqlConnection(connString);
        sqlConnection.Open();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка подключения к базе данных MSSQL:\n{0}\n\n{1}", connString, ex.Message));
        return false;
      }

      return true;
    }

    //закрываем подключение
    public static void CloseConnection()
    {
      if (sqlConnection != null)
      {
        sqlConnection.Dispose();
      }
    }
  }
}