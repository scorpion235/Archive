/*
Тестовое задание для вакансии «С# программист» 

Общие требования

Разработать приложение со следующими возможностями:
•	установить соединение с БД Oracle.
•	вывести все схемы, доступные пользователю.
•	найти все таблицы схемы, кроме системных.
•	создать новую таблицу.
•	удалить таблицу.
•	найти все поля с типом и размером данных для выбранной таблицы.
•	добавить поля в новую или существующую таблицу в конец. Внимание: изменять существующие поля не нужно!
•	удалять поля.
 
------------------------------------------------------------------
Автор: Дюгуров Сергей Михайлович
E-mail: scorpion235@mail.ru
Среды разработки: Microsoft Visual C# 2010 Версия: 10.0.40219.1 SP1Rel
                  Oracle Database Express Edition 11g Release 2
Начало разработки:    2010-05-12
Окончание разработки: 2012-05-14
Дополнительные установки: Oracle 11g Oracle Data Access Components (ODAC)
*/

//основная форма

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Oracle.DataAccess.Client; //ODP.NET
using Oracle.DataAccess.Types;

namespace OraManager
{
  public partial class frmMain : Form
  {
    public frmMain()
    {
      InitializeComponent();
    }

    //открыта для доступа из frmCreateModifyTable
    public static OracleConnection conn;

    //обновление данных
    private void RefreshData()
    {
      //строка подключения
      string oradb = "Data Source   = " + tbDataBase.Text
                       + ";User Id  = " + tbUser.Text
                       + ";Password = " + tbPassword.Text 
                       + ";";

      conn = new OracleConnection(oradb);

      //подключаемся к базе данных
      try
      {
        conn.Open();
      }
      catch
      {
        MessageBox.Show("Ошибка подключения к базе данных Oracle.\nПроверьте настройки подключения.", "Ошибка");
        return;
      }

      pnlConnection.Enabled = false;
      btnConnect.Enabled    = false;

      //получаем список схем
      OracleCommand query_parent = new OracleCommand();
      query_parent.Connection    = conn;
      query_parent.CommandText   = "select username" 
                                     + " from all_users" 
                                     + " order by username";

      query_parent.CommandType   = CommandType.Text;

      OracleDataReader dr_parent = query_parent.ExecuteReader();

      Cursor = Cursors.WaitCursor;
      dataGridView.Rows.Clear();
      treeView.Nodes.Clear();
      treeView.BeginUpdate();

      //получаем список доступных таблиц, исключая системные
      while (dr_parent.Read())
      {
        TreeNode tn = new TreeNode(dr_parent.GetString(0));

        OracleCommand query_child = new OracleCommand();
        query_child.Connection    = conn;
        query_child.CommandText   = "select distinct p.table_name"
                                      + " from all_tab_privs p,"
                                      + " dba_objects o"
                                      + " where p.table_schema = '" + dr_parent.GetString(0) + "'"
                                      + " and p.table_name = o.object_name"
                                      + " and o.created > (select created from v$database)"
                                      + " and o.object_type = 'TABLE'"
                                      + " order by p.table_name";

        query_child.CommandType   = CommandType.Text;

        OracleDataReader dr_child = query_child.ExecuteReader();
    
        while (dr_child.Read())
        {
          tn.Nodes.Add(dr_child.GetString(0));
        }

        //формируем полученные данные в treeView
        treeView.Nodes.Add(tn);
      }

      treeView.EndUpdate();
      Cursor = Cursors.Default;
    }

    private void button1_Click(object sender, EventArgs e)
    {
      RefreshData();
    }

    //выбор элемента в treeView
    private void treeView_AfterSelect(object sender, TreeViewEventArgs e)
    {
      dataGridView.Rows.Clear();

      if (treeView.SelectedNode.Parent == null)
        return;

      //получаем данные о полях и типах данных полей для выбранной таблицы
      OracleCommand query_column = new OracleCommand();
      query_column.Connection = conn;
      query_column.CommandText = "select column_name, data_type, data_length"
                                    + " from all_tab_columns"
                                    + " where table_name = '" + treeView.SelectedNode.Text + "'"
                                    + " and owner = '" + treeView.SelectedNode.Parent.Text + "'";

      query_column.CommandType = CommandType.Text;

      OracleDataReader dr_table = query_column.ExecuteReader();

      //формируем полученные данные в dataGridView
      int count = 0;
      while (dr_table.Read())
      {
        dataGridView.Rows.Add(dr_table.GetString(0), dr_table.GetString(1), dr_table.GetValue(2));

        count++;

        if (count == 10)
          return;
      }
    }

    //закрытие формы
    private void frmOraManager_FormClosed(object sender, FormClosedEventArgs e)
    {
      if (! btnConnect.Enabled)
        conn.Dispose(); //закрываем подключение
    }

    private void contextMenuStrip_Opening(object sender, CancelEventArgs e)
    {
      //определяем доступность элементов контекстного меню
      //в зависимости от выбранного элемента
      try
      {
        if (treeView.Nodes.Count == 0)
        {
          contextMenuStrip.Items[0].Enabled = false;
          contextMenuStrip.Items[1].Enabled = false;
          contextMenuStrip.Items[3].Enabled = false;
        }

        else
        if (treeView.SelectedNode.Parent == null)
        {
          contextMenuStrip.Items[0].Enabled = true;
          contextMenuStrip.Items[1].Enabled = false;
          contextMenuStrip.Items[3].Enabled = false;
        }

        else
        {
          contextMenuStrip.Items[0].Enabled = false;
          contextMenuStrip.Items[1].Enabled = true;
          contextMenuStrip.Items[3].Enabled = true;
        }
      }
      catch
      {
      }
    }

    //добавить таблицу
    private void добавитьToolStripMenuItem_Click(object sender, EventArgs e)
    {
      //создаем форму для добавления таблицы и передаем в нее данные
      frmCreateModifyTable f  = new frmCreateModifyTable();
      f.Text                  = "Создание таблицы";
      f.btnCreateModify.Text  = "Create";
      f.tbLogonUser.Text      = tbUser.Text;
      f.tbCurrentUser.Text    = treeView.SelectedNode.Text;
      f.tbLogonUser.Enabled   = false;
      f.tbCurrentUser.Enabled = false;
      f.ShowDialog();

      conn.Dispose(); //закрываем подключение
      RefreshData();  //переначитываем данные по новой
    }

    //удалить таблицу
    private void удалитьТаблицуToolStripMenuItem_Click(object sender, EventArgs e)
    {
      if (MessageBox.Show("Удалить таблицу " + treeView.SelectedNode.Parent.Text + "." + treeView.SelectedNode.Text + "?", "Подтверждение", MessageBoxButtons.YesNo) == DialogResult.No)
        return;

      OracleCommand query_delete = new OracleCommand();
      query_delete.Connection    = conn;
      query_delete.CommandText   = "drop table " + treeView.SelectedNode.Parent.Text + "." + treeView.SelectedNode.Text;
      query_delete.CommandType   = CommandType.Text;

      try
      {
        OracleDataReader dr_delete = query_delete.ExecuteReader();
      }
      catch
      {
        MessageBox.Show("Ошибка удаления таблицы " + treeView.SelectedNode.Parent.Text + "." + treeView.SelectedNode.Text + "\nВозможно, у вас не достаточно прав доступа.", "Ошибка");
        return;
      }

      treeView.SelectedNode.Remove();
    }

    //поля таблицы
    private void поляТаблицыToolStripMenuItem_Click(object sender, EventArgs e)
    {
      //создаем форму для редактирования полей таблицы и передаем в нее данные
      frmCreateModifyTable f  = new frmCreateModifyTable();
      f.Text                  = "Редактирование полей";
      f.btnCreateModify.Text  = "Modify";
      f.tbLogonUser.Text      = tbUser.Text;
      f.tbCurrentUser.Text    = treeView.SelectedNode.Parent.Text;
      f.tbTableName.Text      = treeView.SelectedNode.Text;
      f.tbLogonUser.Enabled   = false;
      f.tbCurrentUser.Enabled = false;
      f.tbTableName.Enabled   = false;

      //заполняем dataGridView
      for (int i = 0; i < dataGridView.Rows.Count - 1; i++)
      {
        f.dataGridView.Rows.Add(dataGridView.Rows[i].Cells[0].Value, dataGridView.Rows[i].Cells[1].Value, dataGridView.Rows[i].Cells[2].Value);
      }

      f.ShowDialog();

      conn.Dispose(); //закрываем подключение
      RefreshData();  //переначитываем данные по новой
    }
  }
}