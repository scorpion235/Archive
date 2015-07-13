//Проекты (добавление/редактирование)
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
  public partial class frmProjectEd : Form
  {
    public frmProjectEd()
    {
      InitializeComponent();
    }

    //добавление проекта
    public void AddProject(DataGridView dgProject)
    {
      ShowDialog();

      if (DialogResult == DialogResult.Cancel)
      {
        return;
      }

      SqlCommand cmd_insert = new SqlCommand("dbo.ADD_PROJECT", Session.sqlConnection);
      cmd_insert.CommandType = CommandType.StoredProcedure;

      string manager_id = string.Empty;
      for (int i = 0; i < cbManager.Text.Length; i++)
      {
        if (cbManager.Text[i] == ' ' )
          break;

        manager_id += cbManager.Text[i];
      }

      string manager_str = cbManager.Text.Replace(manager_id + " - ", "");

      cmd_insert.Parameters.Add(new SqlParameter("@NAME", tbName.Text));
      cmd_insert.Parameters.Add(new SqlParameter("@CLIENT", tbClient.Text));
      cmd_insert.Parameters.Add(new SqlParameter("@EXECUTOR", tbExecutor.Text));
      cmd_insert.Parameters.Add(new SqlParameter("@MANAGER_ID", manager_id));
      cmd_insert.Parameters.Add(new SqlParameter("@BDATE", cbBDate.Text));
      cmd_insert.Parameters.Add(new SqlParameter("@EDATE", cbEDate.Text));
      cmd_insert.Parameters.Add(new SqlParameter("@PRIORITY", cbPriority.SelectedIndex + 1));
      cmd_insert.Parameters.Add(new SqlParameter("@COMMENT", tbComment.Text));

      string project_id = string.Empty;
      try
      {
        project_id = cmd_insert.ExecuteScalar().ToString();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при добавлении записи в таблицу проектов.\n\n{0}", ex.Message));
        return;
      }

      dgProject.Rows.Add(project_id, 
                         tbName.Text, 
                         tbClient.Text, 
                         tbExecutor.Text,
                         manager_str,
                         cbBDate.Text, 
                         cbEDate.Text, 
                         cbPriority.Text, 
                         tbComment.Text,
                         manager_id);
    }

    //редактирование проекта
    public void EditProject(DataGridView dgProject)
    {
      ShowDialog();

      if (DialogResult == DialogResult.Cancel)
      {
        return;
      }

      SqlCommand cmd_update = new SqlCommand("dbo.EDIT_PROJECT", Session.sqlConnection);
      cmd_update.CommandType = CommandType.StoredProcedure;

      string manager_id = string.Empty;
      for (int i = 0; i < cbManager.Text.Length; i++)
      {
        if (cbManager.Text[i] == ' ' )
          break;

        manager_id += cbManager.Text[i];
      }

      string manager_str = cbManager.Text.Replace(manager_id + " - ", "");

      cmd_update.Parameters.Add(new SqlParameter("@PROJECT_ID", Convert.ToInt32(dgProject.CurrentRow.Cells[0].Value)));
      cmd_update.Parameters.Add(new SqlParameter("@NAME", tbName.Text));
      cmd_update.Parameters.Add(new SqlParameter("@CLIENT", tbClient.Text));
      cmd_update.Parameters.Add(new SqlParameter("@EXECUTOR", tbExecutor.Text));
      cmd_update.Parameters.Add(new SqlParameter("@MANAGER_ID", manager_id));
      cmd_update.Parameters.Add(new SqlParameter("@BDATE", cbBDate.Text));
      cmd_update.Parameters.Add(new SqlParameter("@EDATE", cbEDate.Text));
      cmd_update.Parameters.Add(new SqlParameter("@PRIORITY", cbPriority.SelectedIndex + 1));
      cmd_update.Parameters.Add(new SqlParameter("@COMMENT", tbComment.Text));

      try
      {
        cmd_update.ExecuteNonQuery();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при радактировании записи в таблице проектов.\n\n{0}", ex.Message));
        return;
      }
      
      dgProject.CurrentRow.Cells[1].Value = tbName.Text;
      dgProject.CurrentRow.Cells[2].Value = tbClient.Text;
      dgProject.CurrentRow.Cells[3].Value = tbExecutor.Text;
      dgProject.CurrentRow.Cells[4].Value = manager_str;
      dgProject.CurrentRow.Cells[5].Value = cbBDate.Text;
      dgProject.CurrentRow.Cells[6].Value = cbEDate.Text;
      dgProject.CurrentRow.Cells[7].Value = cbPriority.Text;
      dgProject.CurrentRow.Cells[8].Value = tbComment.Text;
      dgProject.CurrentRow.Cells[9].Value = manager_id;                                 
    }

    //Нажатие на кнопку OK, проверка корректности введенных данных
    private void btnOK_Click(object sender, EventArgs e)
    {
      if (tbName.Text.Trim().Length == 0)
      {
        Common.WarningBox("Необходимо указать название проекта.\n\nНажмите [OK] для перехода к полю.");
        DialogResult = DialogResult.None;
        tbName.Focus();
      }

      else if (tbClient.Text.Trim().Length == 0)
      {
        Common.WarningBox("Необходимо указать компанию-заказчик проекта.\n\nНажмите [OK] для перехода к полю.");
        DialogResult = DialogResult.None;
        tbClient.Focus();
      }

      else if (tbExecutor.Text.Trim().Length == 0)
      {
        Common.WarningBox("Необходимо указать компанию-исполнитель проекта.\n\nНажмите [OK] для перехода к полю.");
        DialogResult = DialogResult.None;
        tbExecutor.Focus();
      }

      else if (cbManager.Text.Trim().Length == 0)
      {
        Common.WarningBox("Необходимо указать руководителя проекта.\nПеред работой с проектами заполните справочник работников.\n\nНажмите [OK] для перехода к полю.");
        DialogResult = DialogResult.None;
        cbManager.Focus();
      }

      else if (cbBDate.Value.Date > cbEDate.Value.Date)
      {
        Common.WarningBox("Дата начала проекта не может быть больше даты окончания проекта.\n\nНажмите [OK] для перехода к полю.");
        DialogResult = DialogResult.None;
        cbBDate.Focus();
      }
    }

    //инициализания контролов
    public void InitComboBox()
    {
      SqlCommand cmd_manager = new SqlCommand("SELECT CONVERT(VARCHAR(250), WORKER_ID) + ' - ' + FIO"
                                            + " FROM WORKERS"
                                            + " ORDER BY WORKER_ID"
                                            , Session.sqlConnection);

      SqlDataReader reader = cmd_manager.ExecuteReader();
      while (reader.Read())
      {
        cbManager.Items.Add(reader.GetValue(0));
      }
      reader.Close();

      cbPriority.Items.AddRange(new object[] {"1 приоритет",
                                              "2 приоритет",
                                              "3 приоритет",
                                              "4 приоритет",
                                              "5 приоритет"});
    }
  }
}
