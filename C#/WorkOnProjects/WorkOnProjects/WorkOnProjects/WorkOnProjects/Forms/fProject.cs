//Проекты
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
  public partial class frmProject : Form
  {
    public frmProject()
    {
      InitializeComponent();
    }

    //добавлена работа с переменной 'updating'
    //при первоначальном заполнении таблицы проектов помогает не запускать
    //код метода 'dgProject_SelectionChanged'
    int updating = 0;

    void BeginUpdate()
    {
      updating++;
    }

    void EndUpdate()
    {
      updating--;
    } 

    bool IsUpdating
    {
      get{ return updating > 0; }
    }

    //изменение размеров формы
    private void frmProject_Resize(object sender, EventArgs e)
    {
      pnlWorkerInProject.Width = Width / 2;
    }

    //открытие формы
    private void frmProject_Shown(object sender, EventArgs e)
    {
      tbManager.Width  = pnlFilter.Width - 10;
      cbPriority.Width = pnlFilter.Width - 10;
      pnlWorkerInProject.Width = Width / 2;

      BeginUpdate();
      cbPriority.Items.AddRange(new object[] {"[все приоритеты]",
                                              "1 приоритет",
                                              "2 приоритет",
                                              "3 приоритет",
                                              "4 приоритет",
                                              "5 приоритет"});
      cbPriority.SelectedIndex = 0;
      cbPriority.DropDownStyle = ComboBoxStyle.DropDownList;

      cbBDate.Value = new DateTime(2014, 1, 1);
      cbEDate.Value = DateTime.Now;
      EndUpdate();

      GetProject(); //получить список проектов
      GetWorker();  //получить список работников
    }

    //получить список проектов
    private void GetProject()
    {
      if (IsUpdating)
      {
        return;
      }

      dgProject.Rows.Clear();

      //запрос в базу данных
      SqlCommand cmd_project = new SqlCommand("dbo.GET_PROJECTS", Session.sqlConnection);
      cmd_project.CommandType = CommandType.StoredProcedure;
      cmd_project.Parameters.Add(new SqlParameter("@MANAGER", tbManager.Text));
      cmd_project.Parameters.Add(new SqlParameter("@BDATE", cbBDate.Text));
      cmd_project.Parameters.Add(new SqlParameter("@EDATE", cbEDate.Text));
      cmd_project.Parameters.Add(new SqlParameter("@PRIORITY", cbPriority.SelectedIndex));

      SqlDataReader reader;
      try
      {
        reader = cmd_project.ExecuteReader();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при получении списка проектов.\n\n{0}", ex.Message));
        return;
      }

      //добавляем записи в таблицу
      BeginUpdate();
      while (reader.Read())
      {
        dgProject.Rows.Add(reader.GetValue(0),
                           reader.GetValue(1),
                           reader.GetValue(2),
                           reader.GetValue(3),
                           reader.GetValue(4),
                           reader.GetValue(5),
                           reader.GetValue(6),
                           reader.GetValue(7),
                           reader.GetValue(8),
                           reader.GetValue(9));
      }
      EndUpdate();
      reader.Close();
    }

    //получить список работников
    private void GetWorker()
    {
      if ((dgProject.Rows.Count == 0) || (IsUpdating))
      {
        return;
      }

      int project_id = Convert.ToInt32(dgProject.CurrentRow.Cells[0].Value);
      int manager_id = Convert.ToInt32(dgProject.CurrentRow.Cells[9].Value);

      //-------------------------------------------------------------
      //работники проекта
      dgWorkerInProject.Rows.Clear();
      SqlCommand cmd_worker_in_project = new SqlCommand("dbo.GET_WORKERS_IN_PROJECT", Session.sqlConnection);
      cmd_worker_in_project.CommandType = CommandType.StoredProcedure;
      cmd_worker_in_project.Parameters.Add(new SqlParameter("@PROJECT_ID", project_id));

      SqlDataReader reader;
      try
      {
        reader = cmd_worker_in_project.ExecuteReader();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при получении списка сотрудников проекта.\n\n{0}", ex.Message));
        return;
      }
      
      while (reader.Read())
      {
        dgWorkerInProject.Rows.Add(reader.GetValue(0),
                                   reader.GetValue(1));
      }
      reader.Close();

      if (dgWorkerInProject.RowCount == 0)
        btnWorkerOut.Enabled = false;
      else
        btnWorkerOut.Enabled = true;

      //-------------------------------------------------------------
      //работники вне проекта
      dgWorkerOutProject.Rows.Clear();
      SqlCommand cmd_worker_out_project = new SqlCommand("dbo.GET_WORKERS_OUT_PROJECT", Session.sqlConnection);
      cmd_worker_out_project.CommandType = CommandType.StoredProcedure;
      cmd_worker_out_project.Parameters.Add(new SqlParameter("@PROJECT_ID", project_id));
      cmd_worker_out_project.Parameters.Add(new SqlParameter("@MANAGER_ID", manager_id));

      try
      {
        reader = cmd_worker_out_project.ExecuteReader();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при получении списка сотрудников вне проекта.\n\n{0}", ex.Message));
        return;
      } 

      while (reader.Read())
      {
        dgWorkerOutProject.Rows.Add(reader.GetValue(0),
                                    reader.GetValue(1));
      }
      reader.Close();

      if (dgWorkerOutProject.RowCount == 0)
        btnWorkerIn.Enabled = false;
      else
        btnWorkerIn.Enabled = true;
    }

    //переход по записям в таблице проектов
    private void dgProject_SelectionChanged(object sender, EventArgs e)
    {
      GetWorker();
    }

    //удаление работника из проекта
    private void btnWorkerOut_Click(object sender, EventArgs e)
    {
      if (dgWorkerInProject.RowCount == 0)
      {
        return;
      }

      if (Common.YesNoBox(string.Format("Удалить работника '{0}' (ID #{1})\nиз проекта '{2}' (ID #{3})?",
                          dgWorkerInProject.CurrentRow.Cells[1].Value.ToString(),
                          dgWorkerInProject.CurrentRow.Cells[0].Value.ToString(),
                          dgProject.CurrentRow.Cells[1].Value.ToString(),
                          dgProject.CurrentRow.Cells[0].Value.ToString())) == DialogResult.No)
      {
        return;
      }

      int project_id = Convert.ToInt32(dgProject.CurrentRow.Cells[0].Value);
      int manager_id = Convert.ToInt32(dgProject.CurrentRow.Cells[9].Value);
      int worker_id  = Convert.ToInt32(dgWorkerInProject.CurrentRow.Cells[0].Value);

      //удаляем в базе
      SqlCommand cmd_delete = new SqlCommand("dbo.DELETE_PROJECT2WORKER", Session.sqlConnection);
      cmd_delete.CommandType = CommandType.StoredProcedure;
      cmd_delete.Parameters.Add(new SqlParameter("@PROJECT_ID", project_id));
      cmd_delete.Parameters.Add(new SqlParameter("@WORKER_ID", worker_id));

      try
      {
        cmd_delete.ExecuteNonQuery();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при удалении записи из таблицы связи проектов и работников.\n\n{0}", ex.Message));
        return;
      }

      //добавляем запись в таблицу "Работники вне проекта"
      dgWorkerOutProject.Rows.Add(worker_id, dgWorkerInProject.CurrentRow.Cells[1].Value);

      //удаляем запись из таблицы "Работники проекта"
      dgWorkerInProject.Rows.Remove(dgWorkerInProject.CurrentRow);
        
      btnWorkerOut.Enabled = dgWorkerInProject.RowCount > 0;
      btnWorkerIn.Enabled  = dgWorkerOutProject.RowCount > 0;
    }

    //добавление работника в проект
    private void btnWorkerIn_Click(object sender, EventArgs e)
    {
      if (dgWorkerOutProject.RowCount == 0)
      {
        return;
      }

      if (Common.YesNoBox(string.Format("Добавить работника '{0}' (ID #{1})\nв проект '{2}' (ID #{3})?",
                          dgWorkerOutProject.CurrentRow.Cells[1].Value.ToString(),
                          dgWorkerOutProject.CurrentRow.Cells[0].Value.ToString(),
                          dgProject.CurrentRow.Cells[1].Value.ToString(), 
                          dgProject.CurrentRow.Cells[0].Value.ToString())) == DialogResult.No)
      {
        return;
      }

      int project_id = Convert.ToInt32(dgProject.CurrentRow.Cells[0].Value);
      int manager_id = Convert.ToInt32(dgProject.CurrentRow.Cells[9].Value);
      int worker_id  = Convert.ToInt32(dgWorkerOutProject.CurrentRow.Cells[0].Value);

      //добавляем запись в связочную таблицу 'PROJECT2WORKER'
      SqlCommand cmd_insert = new SqlCommand("dbo.ADD_PROJECT2WORKER", Session.sqlConnection);
      cmd_insert.CommandType = CommandType.StoredProcedure;
      cmd_insert.Parameters.Add(new SqlParameter("@PROJECT_ID", project_id));
      cmd_insert.Parameters.Add(new SqlParameter("@WORKER_ID", worker_id));

      try
      {
        cmd_insert.ExecuteNonQuery();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при добавлении записи в таблицу связи проектов и работников.\n\n{0}", ex.Message));
        return;
      }

      //добавляем запись в таблицу "Работники проекта"
      dgWorkerInProject.Rows.Add(worker_id, dgWorkerOutProject.CurrentRow.Cells[1].Value);

      //удаляем запись из таблицы "Работники вне проекта"
      dgWorkerOutProject.Rows.Remove(dgWorkerOutProject.CurrentRow);

      btnWorkerOut.Enabled = dgWorkerInProject.RowCount > 0;
      btnWorkerIn.Enabled = dgWorkerOutProject.RowCount > 0;
    }

    //добавить проект
    private void cmAdd_Click(object sender, EventArgs e)
    {
      frmProjectEd f = new frmProjectEd();
      f.Text = "Проекты (добавление)";
      f.InitComboBox();

      if (f.cbManager.Items.Count > 0)
        f.cbManager.SelectedIndex = 0;

      f.cbPriority.SelectedIndex = 0;
      f.cbBDate.Value = DateTime.Now;
      f.cbEDate.Value = DateTime.Now;

      f.AddProject(dgProject);
    }

    //редактировать проект
    private void cmEdit_Click(object sender, EventArgs e)
    {
      if (dgProject.RowCount == 0)
      {
        return;
      }

      frmProjectEd f = new frmProjectEd();
      f.Text = "Проекты (редактирование)";
      f.InitComboBox();

      f.tbName.Text     = dgProject.CurrentRow.Cells[1].Value.ToString();
      f.tbClient.Text   = dgProject.CurrentRow.Cells[2].Value.ToString();
      f.tbExecutor.Text = dgProject.CurrentRow.Cells[3].Value.ToString();
      f.cbManager.Text  = string.Format("{0} - {1}", 
                                        dgProject.CurrentRow.Cells[9].Value.ToString().Trim(),
                                        dgProject.CurrentRow.Cells[4].Value.ToString().Trim());
      f.cbBDate.Text    = dgProject.CurrentRow.Cells[5].Value.ToString();
      f.cbEDate.Text    = dgProject.CurrentRow.Cells[6].Value.ToString();
      f.cbPriority.Text = dgProject.CurrentRow.Cells[7].Value.ToString();
      f.tbComment.Text  = dgProject.CurrentRow.Cells[8].Value.ToString();

      f.EditProject(dgProject);
      GetWorker();
    }

    //удалить проект
    private void cmDelete_Click(object sender, EventArgs e)
    {
      if (dgProject.RowCount == 0)
      {
        return;
      }

      if (Common.YesNoBox(string.Format("Удалить проект '{0}' (ID #{1})?",
                          dgProject.CurrentRow.Cells[1].Value.ToString(),
                          dgProject.CurrentRow.Cells[0].Value.ToString())) == DialogResult.No)
      {
        return;
      }

      SqlCommand cmd_delete = new SqlCommand("dbo.DELETE_PROJECT", Session.sqlConnection);
      cmd_delete.CommandType = CommandType.StoredProcedure;
      int project_id = Convert.ToInt32(dgProject.CurrentRow.Cells[0].Value);
      cmd_delete.Parameters.Add(new SqlParameter("@PROJECT_ID", project_id));

      try
      {
        cmd_delete.ExecuteNonQuery();
      }
      catch (Exception ex)
      {
        Common.ErrorBox(string.Format("Ошибка при удалении записи из таблицы проектов.\n"
                                    + " Возможно, запись используется в других таблицах.\n\n"
                                    + "Если на проект добавлены работники, то предварительно необходимо удалить всех сотрудников проекта.\n\n"
                                    + "{0}", ex.Message));
        return;
      }

      GetProject(); //получить список проектов
      GetWorker();  //получить список работников
    }

    //перед открытием контекстного меню
    private void contextMenuStrip_Opening(object sender, CancelEventArgs e)
    {
      cmEdit.Enabled   = dgProject.Rows.Count > 0;
      cmDelete.Enabled = dgProject.Rows.Count > 0;
    }

    //изменение размеров панели фильтрации
    private void pnlFilter_Resize(object sender, EventArgs e)
    {
      tbManager.Width  = pnlFilter.Width - 10;
      cbPriority.Width = pnlFilter.Width - 10;
    }

    //изменение параметров фильтрации
    private void tbManager_TextChanged(object sender, EventArgs e)
    {
      GetProject(); //получить список проектов
      GetWorker();  //получить список работников
    }
  }
}
