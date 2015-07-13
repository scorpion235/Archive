//Тестовое задание
//Дюгуров Сергей
//Среда разработки: Microsoft Visual Studio 2010 Professional
//                  Версия 10.0.40219.1 SP1Rel

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Util
{
    public partial class Main : Form
    {
        private SearchThread searchThread = new SearchThread();
        private long startRowNo = 0;
        private long endRowNo = 0;
        public Main()
        {
            InitializeComponent();
            bStop.Enabled = false;
        }

        //выбор каталога
        private void bBrowse_Click(object sender, EventArgs e)
        {
            if (folderDialog.ShowDialog() == DialogResult.OK)
            {
                tFolder.Text = folderDialog.SelectedPath;
            }
        }

        //нажатие на кнопку Старт
        private void bStart_Click(object sender, EventArgs e)
        {
            if (tFolder.Text == "")
            {
                MessageBox.Show("Select the Directory", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
                bBrowse.Focus();
                return;
            }

            lbResult.Items.Clear();
            searchThread.folder = tFolder.Text;
            searchThread.Start();
            bStart.Enabled = false;
            timer.Enabled = true;
        }

        //каждые полсекунды выводим данные обработки файлов на экран
        private void timer_Tick(object sender, EventArgs e)
        {
            if (searchThread.result.Count != 0)
            {
                endRowNo = searchThread.result.Count - 1;
                for (int i = 0; i <= endRowNo; i++)
                {
                    lbResult.Items.Add(searchThread.result[i]);
                }
                startRowNo = endRowNo + 1;
            }

            if (searchThread.Complete)
            {
                timer.Enabled = false;
                bStart.Enabled = true;
            }
            else
            {
                timer.Enabled = true;
            }
        }

        //нажатие на кнопку Стоп
        private void bStop_Click(object sender, EventArgs e)
        {
            searchThread.Stop = true;
            bStart.Enabled = true;
        }

        //закрытие формы
        private void Main_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (!searchThread.Complete)
            {
                searchThread.Stop = true;
            }

            while (!searchThread.Complete)
            {
                System.Threading.Thread.Sleep(1000);
            }

            return;
        }

        private void bStart_EnabledChanged(object sender, EventArgs e)
        {
            bStop.Enabled = !bStart.Enabled;
        }
    }
}
