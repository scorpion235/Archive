//Основная форма
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using WorkOnProjects.Classes;

namespace WorkOnProjects
{
  public partial class frmMain : Form
  {
    public frmMain()
    {
      InitializeComponent();
    }

    //загрузка формы
    private void frmMain_Load(object sender, EventArgs e)
    {
      if (!Session.OpenConnection())
      {
        Close();
      }
    }

    //закрытие формы
    private void frmMain_FormClosed(object sender, FormClosedEventArgs e)
    {
      Session.CloseConnection();
    }

    //переводим фокус на уже открытую форму
    private bool ActiveMdiForm(string form_name)
    {
      if ((form_name != "frmProject") && (form_name != "frmWorker"))
        return false;

      for (int i = 0; i < Application.OpenForms.Count; i++)
      {
        if (Application.OpenForms[i].Name == form_name)
        {
          Application.OpenForms[i].Activate();
          return true;
        }
      }

      return false;
    }

    //проекты
    private void mnmProject_Click(object sender, EventArgs e)
    {
      if (ActiveMdiForm("frmProject"))
      {
        return;
      }

      frmProject newMDIChild = new frmProject();
      newMDIChild.MdiParent = this;
      newMDIChild.Show();
    }

    //работники
    private void mnmWorker_Click(object sender, EventArgs e)
    {
      if (ActiveMdiForm("frmWorker"))
      {
        return;
      }

      frmWorker newMDIChild = new frmWorker();
      newMDIChild.MdiParent = this;
      newMDIChild.Show();
    }
  }
}
