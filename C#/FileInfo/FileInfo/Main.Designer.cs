namespace FileInfo
{
    partial class Main
    {
        /// <summary>
        /// Требуется переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Обязательный метод для поддержки конструктора - не изменяйте
        /// содержимое данного метода при помощи редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.folderDialog = new System.Windows.Forms.FolderBrowserDialog();
            this.pnlTop = new System.Windows.Forms.Panel();
            this.lblSize = new System.Windows.Forms.Label();
            this.cbSize = new System.Windows.Forms.ComboBox();
            this.lblExt = new System.Windows.Forms.Label();
            this.cbExt = new System.Windows.Forms.ComboBox();
            this.lblFileProcessed = new System.Windows.Forms.Label();
            this.lblFolder = new System.Windows.Forms.Label();
            this.tFolder = new System.Windows.Forms.TextBox();
            this.bBrowse = new System.Windows.Forms.Button();
            this.pnlBottom = new System.Windows.Forms.Panel();
            this.bStop = new System.Windows.Forms.Button();
            this.bStart = new System.Windows.Forms.Button();
            this.pnlResult = new System.Windows.Forms.Panel();
            this.lbResult = new System.Windows.Forms.ListBox();
            this.timer = new System.Windows.Forms.Timer(this.components);
            this.pnlTop.SuspendLayout();
            this.pnlBottom.SuspendLayout();
            this.pnlResult.SuspendLayout();
            this.SuspendLayout();
            // 
            // pnlTop
            // 
            this.pnlTop.Controls.Add(this.lblSize);
            this.pnlTop.Controls.Add(this.cbSize);
            this.pnlTop.Controls.Add(this.lblExt);
            this.pnlTop.Controls.Add(this.cbExt);
            this.pnlTop.Controls.Add(this.lblFileProcessed);
            this.pnlTop.Controls.Add(this.lblFolder);
            this.pnlTop.Controls.Add(this.tFolder);
            this.pnlTop.Controls.Add(this.bBrowse);
            this.pnlTop.Dock = System.Windows.Forms.DockStyle.Top;
            this.pnlTop.Location = new System.Drawing.Point(0, 0);
            this.pnlTop.Name = "pnlTop";
            this.pnlTop.Size = new System.Drawing.Size(492, 92);
            this.pnlTop.TabIndex = 0;
            // 
            // lblSize
            // 
            this.lblSize.AutoSize = true;
            this.lblSize.Location = new System.Drawing.Point(249, 43);
            this.lblSize.Name = "lblSize";
            this.lblSize.Size = new System.Drawing.Size(46, 13);
            this.lblSize.TabIndex = 0;
            this.lblSize.Text = "Размер";
            // 
            // cbSize
            // 
            this.cbSize.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbSize.FormattingEnabled = true;
            this.cbSize.Items.AddRange(new object[] {
            "байт",
            "килобайт",
            "мегабайт",
            "гигабайт"});
            this.cbSize.Location = new System.Drawing.Point(301, 38);
            this.cbSize.Name = "cbSize";
            this.cbSize.Size = new System.Drawing.Size(121, 21);
            this.cbSize.TabIndex = 4;
            // 
            // lblExt
            // 
            this.lblExt.AutoSize = true;
            this.lblExt.Location = new System.Drawing.Point(13, 43);
            this.lblExt.Name = "lblExt";
            this.lblExt.Size = new System.Drawing.Size(70, 13);
            this.lblExt.TabIndex = 0;
            this.lblExt.Text = "Расширение";
            // 
            // cbExt
            // 
            this.cbExt.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbExt.FormattingEnabled = true;
            this.cbExt.Items.AddRange(new object[] {
            "*.*",
            "*.txt",
            "*.doc",
            "*.xls",
            "*.xml",
            "*.jpg",
            "*.jpeg"});
            this.cbExt.Location = new System.Drawing.Point(88, 38);
            this.cbExt.Name = "cbExt";
            this.cbExt.Size = new System.Drawing.Size(121, 21);
            this.cbExt.TabIndex = 3;
            // 
            // lblFileProcessed
            // 
            this.lblFileProcessed.AutoSize = true;
            this.lblFileProcessed.Location = new System.Drawing.Point(13, 76);
            this.lblFileProcessed.Name = "lblFileProcessed";
            this.lblFileProcessed.Size = new System.Drawing.Size(59, 13);
            this.lblFileProcessed.TabIndex = 0;
            this.lblFileProcessed.Text = "Результат";
            // 
            // lblFolder
            // 
            this.lblFolder.AutoSize = true;
            this.lblFolder.Location = new System.Drawing.Point(13, 16);
            this.lblFolder.Name = "lblFolder";
            this.lblFolder.Size = new System.Drawing.Size(69, 13);
            this.lblFolder.TabIndex = 0;
            this.lblFolder.Text = "Директория";
            // 
            // tFolder
            // 
            this.tFolder.Location = new System.Drawing.Point(88, 12);
            this.tFolder.Name = "tFolder";
            this.tFolder.ReadOnly = true;
            this.tFolder.Size = new System.Drawing.Size(334, 20);
            this.tFolder.TabIndex = 1;
            this.tFolder.TabStop = false;
            // 
            // bBrowse
            // 
            this.bBrowse.Location = new System.Drawing.Point(428, 9);
            this.bBrowse.Name = "bBrowse";
            this.bBrowse.Size = new System.Drawing.Size(48, 23);
            this.bBrowse.TabIndex = 2;
            this.bBrowse.Text = "...";
            this.bBrowse.UseVisualStyleBackColor = true;
            this.bBrowse.Click += new System.EventHandler(this.bBrowse_Click);
            // 
            // pnlBottom
            // 
            this.pnlBottom.Controls.Add(this.bStop);
            this.pnlBottom.Controls.Add(this.bStart);
            this.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.pnlBottom.Location = new System.Drawing.Point(0, 324);
            this.pnlBottom.Name = "pnlBottom";
            this.pnlBottom.Size = new System.Drawing.Size(492, 49);
            this.pnlBottom.TabIndex = 2;
            // 
            // bStop
            // 
            this.bStop.Location = new System.Drawing.Point(96, 13);
            this.bStop.Name = "bStop";
            this.bStop.Size = new System.Drawing.Size(75, 23);
            this.bStop.TabIndex = 7;
            this.bStop.Text = "Стоп";
            this.bStop.UseVisualStyleBackColor = true;
            this.bStop.Click += new System.EventHandler(this.bStop_Click);
            // 
            // bStart
            // 
            this.bStart.Location = new System.Drawing.Point(15, 13);
            this.bStart.Name = "bStart";
            this.bStart.Size = new System.Drawing.Size(75, 23);
            this.bStart.TabIndex = 6;
            this.bStart.Text = "Старт";
            this.bStart.UseVisualStyleBackColor = true;
            this.bStart.EnabledChanged += new System.EventHandler(this.bStart_EnabledChanged);
            this.bStart.Click += new System.EventHandler(this.bStart_Click);
            // 
            // pnlResult
            // 
            this.pnlResult.Controls.Add(this.lbResult);
            this.pnlResult.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pnlResult.Location = new System.Drawing.Point(0, 92);
            this.pnlResult.Name = "pnlResult";
            this.pnlResult.Size = new System.Drawing.Size(492, 232);
            this.pnlResult.TabIndex = 1;
            // 
            // lbResult
            // 
            this.lbResult.Dock = System.Windows.Forms.DockStyle.Fill;
            this.lbResult.FormattingEnabled = true;
            this.lbResult.Location = new System.Drawing.Point(0, 0);
            this.lbResult.Name = "lbResult";
            this.lbResult.Size = new System.Drawing.Size(492, 232);
            this.lbResult.TabIndex = 5;
            // 
            // timer
            // 
            this.timer.Interval = 500;
            this.timer.Tick += new System.EventHandler(this.timer_Tick);
            // 
            // Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(492, 373);
            this.Controls.Add(this.pnlResult);
            this.Controls.Add(this.pnlBottom);
            this.Controls.Add(this.pnlTop);
            this.MinimumSize = new System.Drawing.Size(500, 400);
            this.Name = "Main";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "FileInfo";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Main_FormClosing);
            this.pnlTop.ResumeLayout(false);
            this.pnlTop.PerformLayout();
            this.pnlBottom.ResumeLayout(false);
            this.pnlResult.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.FolderBrowserDialog folderDialog;
        private System.Windows.Forms.Panel pnlTop;
        private System.Windows.Forms.Label lblFileProcessed;
        private System.Windows.Forms.Label lblFolder;
        private System.Windows.Forms.TextBox tFolder;
        private System.Windows.Forms.Button bBrowse;
        private System.Windows.Forms.Panel pnlBottom;
        private System.Windows.Forms.Button bStop;
        private System.Windows.Forms.Button bStart;
        private System.Windows.Forms.Panel pnlResult;
        private System.Windows.Forms.ListBox lbResult;
        private System.Windows.Forms.Timer timer;
        private System.Windows.Forms.ComboBox cbExt;
        private System.Windows.Forms.Label lblExt;
        private System.Windows.Forms.Label lblSize;
        private System.Windows.Forms.ComboBox cbSize;
    }
}

