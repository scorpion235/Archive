//Среда разработки: Microsoft Visual Studio 2013 Professional
//Версия 12.0.21005.1 Rel

using System;
using System.Windows.Forms;

namespace FileInfo
{
    public partial class Main : Form
    {
        private SearchThread searchThread = new SearchThread();
        private long startRowNo = 0;
        private long endRowNo = 0;

        //конструктор
        public Main()
        {
            InitializeComponent();
            cbExt.SelectedIndex = 0;
            cbSize.SelectedIndex = 0;
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
                MessageBox.Show("Необходимо выбрать дитекторию.", "Информация", 
                                MessageBoxButtons.OK, MessageBoxIcon.Information);
                bBrowse.Focus();
                return;
            }

            lbResult.Items.Clear();
            searchThread.Start(cbExt.Text, tFolder.Text, cbSize.Text);
            bStart.Enabled = false;
            timer.Enabled = true;
        }

        //каждые полсекунды выводим данные обработки файлов на экран
        private void timer_Tick(object sender, EventArgs e)
        {
            if (searchThread.Result.Count != 0)
            {
                endRowNo = searchThread.Result.Count - 1;

                for (int i = 0; i <= endRowNo; i++)
                {
                    lbResult.Items.Add(searchThread.Result[i]);
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
            this.Cursor = Cursors.Default;
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

        //изменение доступности кнопки "Старт"
        private void bStart_EnabledChanged(object sender, EventArgs e)
        {
            bStop.Enabled = !bStart.Enabled;
        }
    }
}