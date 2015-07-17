//форма добавления таблицы / редактирования полей

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Oracle.DataAccess.Client;
using Oracle.DataAccess.Types;

namespace OraManager
{
  public partial class frmCreateModifyTable : Form
  {
    public frmCreateModifyTable()
    {
      InitializeComponent();
    }

    //отмена
    private void btnCancel_Click(object sender, EventArgs e)
    {
      Close();
    }

    //создание / изменение
    private void btnCreate_Click(object sender, EventArgs e)
    { 
      if (tbTableName.Text == "")
      {
        MessageBox.Show("Укажите имя таблицы.", "Предупреждение");
        tbTableName.Focus();
        return;
      }

      if (dataGridView.Rows.Count == 0)
      {
        MessageBox.Show("Необходимо ввсести хотя бы одно поле таблицы.", "Предупреждение");
        dataGridView.Focus();
        return;
      }

      if (!tbTableName.Enabled) //редактирование полей
      {
        OracleCommand query_delete = new OracleCommand();
        query_delete.Connection = frmMain.conn;
        query_delete.CommandText = "drop table " + tbCurrentUser.Text + "." + tbTableName.Text;
        query_delete.CommandType = CommandType.Text;

        try
        {
          OracleDataReader dr_delete = query_delete.ExecuteReader();
        }
        catch
        {
          MessageBox.Show("Ошибка создания/изменения таблицы.\nВозможно, у вас нет прав создавать таблицы для выбранной схемы.", "Ошибка");
          return;
        }
      }

      OracleCommand query_create = new OracleCommand();
      query_create.Connection = frmMain.conn;

      //создание таблицы
      string query_string = "create table " + tbCurrentUser.Text + "."+ tbTableName.Text + "(";

      for (int i = 0; i < dataGridView.Rows.Count - 1; i++)
      {
        if (i > 0)
          query_string = query_string + ", ";

        query_string = query_string + dataGridView.Rows[i].Cells[0].Value + " " + dataGridView.Rows[i].Cells[1].Value;

        if (dataGridView.Rows[i].Cells[2].Value != null)
          query_string = query_string + "(" + dataGridView.Rows[i].Cells[2].Value + ")";
      }

      query_string = query_string + ")";

      query_create.CommandText = query_string;
      query_create.CommandType = CommandType.Text;
      MessageBox.Show(query_create.CommandText);

      try
      {
        OracleDataReader dr_create = query_create.ExecuteReader();
      }
      catch
      {
        MessageBox.Show("Ошибка создания/изменения таблицы.\nВозможно, у вас нет прав создавать таблицы для выбранной схемы.", "Ошибка");
        return;
      }

      MessageBox.Show("Таблица " + tbTableName.Text + " успешно создана/изменена.", "Информация");

      Close();
    }
  }
}
