namespace WorkOnProjects
{
  partial class frmProjectEd
  {
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
      if (disposing && (components != null))
      {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
            this.tbName = new System.Windows.Forms.TextBox();
            this.lblName = new System.Windows.Forms.Label();
            this.tbClient = new System.Windows.Forms.TextBox();
            this.lblClient = new System.Windows.Forms.Label();
            this.tbExecutor = new System.Windows.Forms.TextBox();
            this.lblExecutor = new System.Windows.Forms.Label();
            this.lblManager = new System.Windows.Forms.Label();
            this.cbManager = new System.Windows.Forms.ComboBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.cbEDate = new System.Windows.Forms.DateTimePicker();
            this.lblEDate = new System.Windows.Forms.Label();
            this.cbBDate = new System.Windows.Forms.DateTimePicker();
            this.lblBDate = new System.Windows.Forms.Label();
            this.cbPriority = new System.Windows.Forms.ComboBox();
            this.lblPriority = new System.Windows.Forms.Label();
            this.tbComment = new System.Windows.Forms.TextBox();
            this.lblComment = new System.Windows.Forms.Label();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnOK = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // tbName
            // 
            this.tbName.Location = new System.Drawing.Point(10, 30);
            this.tbName.Name = "tbName";
            this.tbName.Size = new System.Drawing.Size(320, 20);
            this.tbName.TabIndex = 13;
            // 
            // lblName
            // 
            this.lblName.AutoSize = true;
            this.lblName.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.lblName.Location = new System.Drawing.Point(10, 15);
            this.lblName.Name = "lblName";
            this.lblName.Size = new System.Drawing.Size(60, 13);
            this.lblName.TabIndex = 11;
            this.lblName.Text = "Название:";
            // 
            // tbClient
            // 
            this.tbClient.Location = new System.Drawing.Point(10, 75);
            this.tbClient.Name = "tbClient";
            this.tbClient.Size = new System.Drawing.Size(320, 20);
            this.tbClient.TabIndex = 18;
            // 
            // lblClient
            // 
            this.lblClient.AutoSize = true;
            this.lblClient.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.lblClient.Location = new System.Drawing.Point(10, 60);
            this.lblClient.Name = "lblClient";
            this.lblClient.Size = new System.Drawing.Size(117, 13);
            this.lblClient.TabIndex = 17;
            this.lblClient.Text = "Компания - заказчик:";
            // 
            // tbExecutor
            // 
            this.tbExecutor.Location = new System.Drawing.Point(10, 120);
            this.tbExecutor.Name = "tbExecutor";
            this.tbExecutor.Size = new System.Drawing.Size(320, 20);
            this.tbExecutor.TabIndex = 20;
            // 
            // lblExecutor
            // 
            this.lblExecutor.AutoSize = true;
            this.lblExecutor.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.lblExecutor.Location = new System.Drawing.Point(10, 105);
            this.lblExecutor.Name = "lblExecutor";
            this.lblExecutor.Size = new System.Drawing.Size(135, 13);
            this.lblExecutor.TabIndex = 19;
            this.lblExecutor.Text = "Компания - исполнитель:\r\n";
            // 
            // lblManager
            // 
            this.lblManager.AutoSize = true;
            this.lblManager.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.lblManager.Location = new System.Drawing.Point(10, 150);
            this.lblManager.Name = "lblManager";
            this.lblManager.Size = new System.Drawing.Size(125, 13);
            this.lblManager.TabIndex = 21;
            this.lblManager.Text = "Руководитель проекта:";
            // 
            // cbManager
            // 
            this.cbManager.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbManager.FormattingEnabled = true;
            this.cbManager.Location = new System.Drawing.Point(10, 165);
            this.cbManager.Name = "cbManager";
            this.cbManager.Size = new System.Drawing.Size(320, 21);
            this.cbManager.TabIndex = 22;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.cbEDate);
            this.groupBox1.Controls.Add(this.lblEDate);
            this.groupBox1.Controls.Add(this.cbBDate);
            this.groupBox1.Controls.Add(this.lblBDate);
            this.groupBox1.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.groupBox1.Location = new System.Drawing.Point(10, 200);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(317, 56);
            this.groupBox1.TabIndex = 23;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Период проекта";
            // 
            // cbEDate
            // 
            this.cbEDate.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.cbEDate.Location = new System.Drawing.Point(160, 20);
            this.cbEDate.Name = "cbEDate";
            this.cbEDate.Size = new System.Drawing.Size(93, 20);
            this.cbEDate.TabIndex = 15;
            // 
            // lblEDate
            // 
            this.lblEDate.AutoSize = true;
            this.lblEDate.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.lblEDate.Location = new System.Drawing.Point(135, 25);
            this.lblEDate.Name = "lblEDate";
            this.lblEDate.Size = new System.Drawing.Size(22, 13);
            this.lblEDate.TabIndex = 14;
            this.lblEDate.Text = "по:";
            // 
            // cbBDate
            // 
            this.cbBDate.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.cbBDate.Location = new System.Drawing.Point(30, 20);
            this.cbBDate.Name = "cbBDate";
            this.cbBDate.Size = new System.Drawing.Size(93, 20);
            this.cbBDate.TabIndex = 13;
            // 
            // lblBDate
            // 
            this.lblBDate.AutoSize = true;
            this.lblBDate.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.lblBDate.Location = new System.Drawing.Point(10, 25);
            this.lblBDate.Name = "lblBDate";
            this.lblBDate.Size = new System.Drawing.Size(16, 13);
            this.lblBDate.TabIndex = 12;
            this.lblBDate.Text = "с:";
            // 
            // cbPriority
            // 
            this.cbPriority.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbPriority.FormattingEnabled = true;
            this.cbPriority.Location = new System.Drawing.Point(10, 285);
            this.cbPriority.Name = "cbPriority";
            this.cbPriority.Size = new System.Drawing.Size(320, 21);
            this.cbPriority.TabIndex = 25;
            // 
            // lblPriority
            // 
            this.lblPriority.AutoSize = true;
            this.lblPriority.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.lblPriority.Location = new System.Drawing.Point(10, 270);
            this.lblPriority.Name = "lblPriority";
            this.lblPriority.Size = new System.Drawing.Size(64, 13);
            this.lblPriority.TabIndex = 24;
            this.lblPriority.Text = "Приоритет:";
            // 
            // tbComment
            // 
            this.tbComment.Location = new System.Drawing.Point(10, 330);
            this.tbComment.Name = "tbComment";
            this.tbComment.Size = new System.Drawing.Size(320, 20);
            this.tbComment.TabIndex = 27;
            // 
            // lblComment
            // 
            this.lblComment.AutoSize = true;
            this.lblComment.ForeColor = System.Drawing.SystemColors.ControlText;
            this.lblComment.Location = new System.Drawing.Point(10, 315);
            this.lblComment.Name = "lblComment";
            this.lblComment.Size = new System.Drawing.Size(80, 13);
            this.lblComment.TabIndex = 26;
            this.lblComment.Text = "Комментарий:";
            // 
            // btnCancel
            // 
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancel.Location = new System.Drawing.Point(230, 370);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(99, 23);
            this.btnCancel.TabIndex = 29;
            this.btnCancel.Text = "Отмена";
            this.btnCancel.UseVisualStyleBackColor = true;
            // 
            // btnOK
            // 
            this.btnOK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnOK.Location = new System.Drawing.Point(120, 370);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(100, 23);
            this.btnOK.TabIndex = 28;
            this.btnOK.Text = "OK";
            this.btnOK.UseVisualStyleBackColor = true;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // frmProjectEd
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.btnCancel;
            this.ClientSize = new System.Drawing.Size(339, 405);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.tbComment);
            this.Controls.Add(this.lblComment);
            this.Controls.Add(this.cbPriority);
            this.Controls.Add(this.lblPriority);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.cbManager);
            this.Controls.Add(this.lblManager);
            this.Controls.Add(this.tbExecutor);
            this.Controls.Add(this.lblExecutor);
            this.Controls.Add(this.tbClient);
            this.Controls.Add(this.lblClient);
            this.Controls.Add(this.tbName);
            this.Controls.Add(this.lblName);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmProjectEd";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Проекты (добавление/редактирование)";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.Label lblName;
    private System.Windows.Forms.Label lblClient;
    private System.Windows.Forms.Label lblExecutor;
    private System.Windows.Forms.Label lblManager;
    private System.Windows.Forms.GroupBox groupBox1;
    private System.Windows.Forms.Label lblEDate;
    private System.Windows.Forms.Label lblBDate;
    private System.Windows.Forms.Label lblPriority;
    private System.Windows.Forms.Label lblComment;
    private System.Windows.Forms.Button btnCancel;
    private System.Windows.Forms.Button btnOK;
    public System.Windows.Forms.ComboBox cbManager;
    public System.Windows.Forms.DateTimePicker cbEDate;
    public System.Windows.Forms.DateTimePicker cbBDate;
    public System.Windows.Forms.ComboBox cbPriority;
    public System.Windows.Forms.TextBox tbName;
    public System.Windows.Forms.TextBox tbClient;
    public System.Windows.Forms.TextBox tbExecutor;
    public System.Windows.Forms.TextBox tbComment;
  }
}