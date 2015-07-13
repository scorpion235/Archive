//Работники (добавление/редактирование)
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using WorkOnProjects.Classes;
using System.Data.SqlClient;

namespace WorkOnProjects
{
  public partial class frmWorkerEd : Form
  {
    public frmWorkerEd()
    {
      InitializeComponent();
    }

    //добавление работника
    public void AddWorker(DataGridView dgWorker)
    {
      ShowDialog();

      if (DialogResult == DialogResult.Cancel)
      {
        return;
      }

      SqlCommand cmd_insert = new SqlCommand("dbo.ADD_WORKER", Session.sqlConnection);
      cmd_insert.CommandType = CommandType.StoredProcedure;
      cmd_insert.Parameters.Add(new SqlParameter("@FIO", tbFIO.Text));
      cmd_insert.Parameters.Add(new SqlParameter("@EMAIL", tbEmail.Text));

      string worker_id = string.Empty;
      try
      {
        worker_id = cmd_insert.ExecuteScalar().ToString();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при добавлении записи в таблицу работников.\n\n{0}", ex.Message));
        return;
      }

      dgWorker.Rows.Add(worker_id, tbFIO.Text, tbEmail.Text);
    }

    //редактирование работника
    public void EditWorker(DataGridView dgWorker)
    {
      ShowDialog();

      if (DialogResult == DialogResult.Cancel)
      {
        return;
      }

      SqlCommand cmd_update = new SqlCommand("dbo.EDIT_WORKER", Session.sqlConnection);
      cmd_update.CommandType = CommandType.StoredProcedure;
      cmd_update.Parameters.Add(new SqlParameter("@WORKER_ID", dgWorker.CurrentRow.Cells[1].Value));
      cmd_update.Parameters.Add(new SqlParameter("@FIO", tbFIO.Text));
      cmd_update.Parameters.Add(new SqlParameter("@EMAIL", tbEmail.Text));

      try
      {
        cmd_update.ExecuteNonQuery();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при радактировании записи в таблице работников.\n\n{0}", ex.Message));
        return;
      }

      dgWorker.CurrentRow.Cells[1].Value = tbFIO.Text;
      dgWorker.CurrentRow.Cells[2].Value = tbEmail.Text;
    }

    //Нажатие на кнопку OK, проверка корректности введенных данных
    private void btnOK_Click(object sender, EventArgs e)
    {
      if (tbFIO.Text.Trim().Length == 0)
      {
        Common.WarningBox("Необходимо указать ФИО.\n\nНажмите [OK] для перехода к полю.");
        DialogResult = DialogResult.None;
        tbFIO.Focus();
      }

      else if ((tbEmail.Text.Trim().Length != 0) && (tbEmail.Text.IndexOf("@") == -1))
      {
        Common.WarningBox("Нeверный формат e-mail.\n\nНажмите [OK] для перехода к полю.");
        DialogResult = DialogResult.None;
        tbEmail.Focus();
      }
    }
  }
}