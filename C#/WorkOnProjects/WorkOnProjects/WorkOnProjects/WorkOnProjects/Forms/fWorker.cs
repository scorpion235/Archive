//Работники
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using WorkOnProjects.Classes;

namespace WorkOnProjects
{
  public partial class frmWorker : Form
  {
    public frmWorker()
    {
      InitializeComponent();
    }

    //отображение формы
    private void frmWorker_Shown(object sender, EventArgs e)
    {
      SqlCommand cmd_worker = new SqlCommand("dbo.GET_WORKERS", Session.sqlConnection);
      cmd_worker.CommandType = CommandType.StoredProcedure;
      SqlDataReader reader = cmd_worker.ExecuteReader();

      while (reader.Read())
      {
        dgWorker.Rows.Add(reader.GetValue(0), 
                          reader.GetValue(1), 
                          reader.GetValue(2));
      }
      reader.Close();
    }

    //добавить работника
    private void добавитьToolStripMenuItem_Click(object sender, EventArgs e)
    {
      frmWorkerEd f = new frmWorkerEd();
      f.Text = "Работники (добавление)";
      f.AddWorker(dgWorker);
    }

    //редактировать работника
    private void редактироватьToolStripMenuItem_Click(object sender, EventArgs e)
    {
      if (dgWorker.RowCount == 0)
        return;

      frmWorkerEd f  = new frmWorkerEd();
      f.Text = "Работники (редактирование)";
      f.tbFIO.Text   = dgWorker.CurrentRow.Cells[1].Value.ToString();
      f.tbEmail.Text = dgWorker.CurrentRow.Cells[2].Value.ToString();
      f.EditWorker(dgWorker);
    }

    //удалить работника
    private void удалитьToolStripMenuItem_Click(object sender, EventArgs e)
    {
      if (dgWorker.RowCount == 0) 
        return;

      if (Common.YesNoBox(string.Format("Удалить работника '{0}' (ID #{1})?", 
                          dgWorker.CurrentRow.Cells[1].Value.ToString(),
                          dgWorker.CurrentRow.Cells[0].Value.ToString())) == DialogResult.No)
      {
        return;
      }

      SqlCommand cmd_delete = new SqlCommand("dbo.DELETE_WORKER", Session.sqlConnection);
      cmd_delete.CommandType = CommandType.StoredProcedure;
      cmd_delete.Parameters.Add(new SqlParameter("@WORKER_ID", Convert.ToInt32(dgWorker.CurrentRow.Cells[0].Value)));

      try
      {
        cmd_delete.ExecuteNonQuery();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при удалении записи из таблицы работников.\n"
                                    + "Возможно, запись используется в других таблицах.\n\n"
                                    + "{0}", ex.Message));
        return;
      }

      dgWorker.Rows.Remove(dgWorker.CurrentRow);
    }

    //перед открытием контекстного меню
    private void contextMenuStrip_Opening(object sender, CancelEventArgs e)
    {
      if (dgWorker.Rows.Count == 0)
      {
        cmEdit.Enabled   = false;
        cmDelete.Enabled = false;
      }
      else
      {
        cmEdit.Enabled   = true;
        cmDelete.Enabled = true;
      }
    }
  }
}
