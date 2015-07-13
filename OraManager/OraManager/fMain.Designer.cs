namespace OraManager
{
  partial class frmMain
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
      this.pnlConnection = new System.Windows.Forms.Panel();
      this.tbPassword = new System.Windows.Forms.TextBox();
      this.lblPassword = new System.Windows.Forms.Label();
      this.tbUser = new System.Windows.Forms.TextBox();
      this.lblUser = new System.Windows.Forms.Label();
      this.tbDataBase = new System.Windows.Forms.TextBox();
      this.lblDataBase = new System.Windows.Forms.Label();
      this.btnConnect = new System.Windows.Forms.Button();
      this.treeView = new System.Windows.Forms.TreeView();
      this.contextMenuStrip = new System.Windows.Forms.ContextMenuStrip(this.components);
      this.добавитьToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.удалитьТаблицуToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripSeparator();
      this.поляТаблицыToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.splitter1 = new System.Windows.Forms.Splitter();
      this.dataGridView = new System.Windows.Forms.DataGridView();
      this.ColumnName = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.DataType = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.DataLength = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.pnlConnection.SuspendLayout();
      this.contextMenuStrip.SuspendLayout();
      ((System.ComponentModel.ISupportInitialize)(this.dataGridView)).BeginInit();
      this.SuspendLayout();
      // 
      // pnlConnection
      // 
      this.pnlConnection.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
      this.pnlConnection.Controls.Add(this.tbPassword);
      this.pnlConnection.Controls.Add(this.lblPassword);
      this.pnlConnection.Controls.Add(this.tbUser);
      this.pnlConnection.Controls.Add(this.lblUser);
      this.pnlConnection.Controls.Add(this.tbDataBase);
      this.pnlConnection.Controls.Add(this.lblDataBase);
      this.pnlConnection.Controls.Add(this.btnConnect);
      this.pnlConnection.Dock = System.Windows.Forms.DockStyle.Top;
      this.pnlConnection.Location = new System.Drawing.Point(0, 0);
      this.pnlConnection.Name = "pnlConnection";
      this.pnlConnection.Size = new System.Drawing.Size(742, 165);
      this.pnlConnection.TabIndex = 0;
      // 
      // tbPassword
      // 
      this.tbPassword.Location = new System.Drawing.Point(10, 105);
      this.tbPassword.Name = "tbPassword";
      this.tbPassword.Size = new System.Drawing.Size(200, 20);
      this.tbPassword.TabIndex = 8;
      this.tbPassword.Text = "cjkysirj";
      // 
      // lblPassword
      // 
      this.lblPassword.AutoSize = true;
      this.lblPassword.Location = new System.Drawing.Point(10, 91);
      this.lblPassword.Name = "lblPassword";
      this.lblPassword.Size = new System.Drawing.Size(56, 13);
      this.lblPassword.TabIndex = 7;
      this.lblPassword.Text = "Password:";
      // 
      // tbUser
      // 
      this.tbUser.Location = new System.Drawing.Point(10, 65);
      this.tbUser.Name = "tbUser";
      this.tbUser.Size = new System.Drawing.Size(200, 20);
      this.tbUser.TabIndex = 6;
      this.tbUser.Text = "SYSTEM";
      // 
      // lblUser
      // 
      this.lblUser.AutoSize = true;
      this.lblUser.Location = new System.Drawing.Point(10, 51);
      this.lblUser.Name = "lblUser";
      this.lblUser.Size = new System.Drawing.Size(82, 13);
      this.lblUser.TabIndex = 5;
      this.lblUser.Text = "User / Schema:";
      // 
      // tbDataBase
      // 
      this.tbDataBase.Location = new System.Drawing.Point(10, 25);
      this.tbDataBase.Name = "tbDataBase";
      this.tbDataBase.Size = new System.Drawing.Size(200, 20);
      this.tbDataBase.TabIndex = 4;
      this.tbDataBase.Text = "(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = scorpion)(PORT = 1521)) (CONNEC" +
    "T_DATA = (SERVER = DEDICATED) (SERVICE_NAME = XE)))";
      // 
      // lblDataBase
      // 
      this.lblDataBase.AutoSize = true;
      this.lblDataBase.Location = new System.Drawing.Point(10, 11);
      this.lblDataBase.Name = "lblDataBase";
      this.lblDataBase.Size = new System.Drawing.Size(57, 13);
      this.lblDataBase.TabIndex = 3;
      this.lblDataBase.Text = "DataBase:";
      // 
      // btnConnect
      // 
      this.btnConnect.Location = new System.Drawing.Point(10, 135);
      this.btnConnect.Name = "btnConnect";
      this.btnConnect.Size = new System.Drawing.Size(100, 23);
      this.btnConnect.TabIndex = 2;
      this.btnConnect.Text = "Connect";
      this.btnConnect.UseVisualStyleBackColor = true;
      this.btnConnect.Click += new System.EventHandler(this.button1_Click);
      // 
      // treeView
      // 
      this.treeView.ContextMenuStrip = this.contextMenuStrip;
      this.treeView.Dock = System.Windows.Forms.DockStyle.Left;
      this.treeView.Location = new System.Drawing.Point(0, 165);
      this.treeView.Name = "treeView";
      this.treeView.Size = new System.Drawing.Size(250, 308);
      this.treeView.TabIndex = 9;
      this.treeView.AfterSelect += new System.Windows.Forms.TreeViewEventHandler(this.treeView_AfterSelect);
      // 
      // contextMenuStrip
      // 
      this.contextMenuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.добавитьToolStripMenuItem,
            this.удалитьТаблицуToolStripMenuItem,
            this.toolStripMenuItem1,
            this.поляТаблицыToolStripMenuItem});
      this.contextMenuStrip.Name = "contextMenuStrip";
      this.contextMenuStrip.Size = new System.Drawing.Size(169, 98);
      this.contextMenuStrip.Opening += new System.ComponentModel.CancelEventHandler(this.contextMenuStrip_Opening);
      // 
      // добавитьToolStripMenuItem
      // 
      this.добавитьToolStripMenuItem.Name = "добавитьToolStripMenuItem";
      this.добавитьToolStripMenuItem.Size = new System.Drawing.Size(168, 22);
      this.добавитьToolStripMenuItem.Text = "добавить таблицу";
      this.добавитьToolStripMenuItem.Click += new System.EventHandler(this.добавитьToolStripMenuItem_Click);
      // 
      // удалитьТаблицуToolStripMenuItem
      // 
      this.удалитьТаблицуToolStripMenuItem.Name = "удалитьТаблицуToolStripMenuItem";
      this.удалитьТаблицуToolStripMenuItem.Size = new System.Drawing.Size(168, 22);
      this.удалитьТаблицуToolStripMenuItem.Text = "удалить таблицу";
      this.удалитьТаблицуToolStripMenuItem.Click += new System.EventHandler(this.удалитьТаблицуToolStripMenuItem_Click);
      // 
      // toolStripMenuItem1
      // 
      this.toolStripMenuItem1.Name = "toolStripMenuItem1";
      this.toolStripMenuItem1.Size = new System.Drawing.Size(165, 6);
      // 
      // поляТаблицыToolStripMenuItem
      // 
      this.поляТаблицыToolStripMenuItem.Name = "поляТаблицыToolStripMenuItem";
      this.поляТаблицыToolStripMenuItem.Size = new System.Drawing.Size(168, 22);
      this.поляТаблицыToolStripMenuItem.Text = "поля таблицы";
      this.поляТаблицыToolStripMenuItem.Click += new System.EventHandler(this.поляТаблицыToolStripMenuItem_Click);
      // 
      // splitter1
      // 
      this.splitter1.Location = new System.Drawing.Point(250, 165);
      this.splitter1.Name = "splitter1";
      this.splitter1.Size = new System.Drawing.Size(3, 308);
      this.splitter1.TabIndex = 10;
      this.splitter1.TabStop = false;
      // 
      // dataGridView
      // 
      this.dataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
      this.dataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.ColumnName,
            this.DataType,
            this.DataLength});
      this.dataGridView.Dock = System.Windows.Forms.DockStyle.Fill;
      this.dataGridView.ImeMode = System.Windows.Forms.ImeMode.NoControl;
      this.dataGridView.Location = new System.Drawing.Point(253, 165);
      this.dataGridView.Name = "dataGridView";
      this.dataGridView.ReadOnly = true;
      this.dataGridView.Size = new System.Drawing.Size(489, 308);
      this.dataGridView.TabIndex = 11;
      // 
      // ColumnName
      // 
      this.ColumnName.HeaderText = "Column name";
      this.ColumnName.Name = "ColumnName";
      this.ColumnName.ReadOnly = true;
      // 
      // DataType
      // 
      this.DataType.HeaderText = "Data type";
      this.DataType.Name = "DataType";
      this.DataType.ReadOnly = true;
      // 
      // DataLength
      // 
      this.DataLength.HeaderText = "Data length";
      this.DataLength.Name = "DataLength";
      this.DataLength.ReadOnly = true;
      // 
      // frmMain
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(742, 473);
      this.Controls.Add(this.dataGridView);
      this.Controls.Add(this.splitter1);
      this.Controls.Add(this.treeView);
      this.Controls.Add(this.pnlConnection);
      this.Name = "frmMain";
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
      this.Text = "OraManager";
      this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.frmOraManager_FormClosed);
      this.pnlConnection.ResumeLayout(false);
      this.pnlConnection.PerformLayout();
      this.contextMenuStrip.ResumeLayout(false);
      ((System.ComponentModel.ISupportInitialize)(this.dataGridView)).EndInit();
      this.ResumeLayout(false);

    }

    #endregion

    private System.Windows.Forms.Panel pnlConnection;
    private System.Windows.Forms.Button btnConnect;
    private System.Windows.Forms.TextBox tbPassword;
    private System.Windows.Forms.Label lblPassword;
    private System.Windows.Forms.TextBox tbUser;
    private System.Windows.Forms.Label lblUser;
    private System.Windows.Forms.TextBox tbDataBase;
    private System.Windows.Forms.Label lblDataBase;
    private System.Windows.Forms.Splitter splitter1;
    private System.Windows.Forms.DataGridView dataGridView;
    private System.Windows.Forms.DataGridViewTextBoxColumn ColumnName;
    private System.Windows.Forms.DataGridViewTextBoxColumn DataType;
    private System.Windows.Forms.DataGridViewTextBoxColumn DataLength;
    private System.Windows.Forms.ContextMenuStrip contextMenuStrip;
    private System.Windows.Forms.ToolStripMenuItem добавитьToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem удалитьТаблицуToolStripMenuItem;
    private System.Windows.Forms.ToolStripSeparator toolStripMenuItem1;
    private System.Windows.Forms.ToolStripMenuItem поляТаблицыToolStripMenuItem;
    private System.Windows.Forms.TreeView treeView;

  }
}

