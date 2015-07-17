namespace OraManager
{
  partial class frmCreateModifyTable
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
      this.pnlTableName = new System.Windows.Forms.Panel();
      this.tbCurrentUser = new System.Windows.Forms.TextBox();
      this.lblCurrentUser = new System.Windows.Forms.Label();
      this.tbLogonUser = new System.Windows.Forms.TextBox();
      this.lblLogonUser = new System.Windows.Forms.Label();
      this.tbTableName = new System.Windows.Forms.TextBox();
      this.lblTableName = new System.Windows.Forms.Label();
      this.dataGridView = new System.Windows.Forms.DataGridView();
      this.ColumnName = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.DataType = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.DataLength = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.panel1 = new System.Windows.Forms.Panel();
      this.btnCancel = new System.Windows.Forms.Button();
      this.btnCreateModify = new System.Windows.Forms.Button();
      this.pnlTableName.SuspendLayout();
      ((System.ComponentModel.ISupportInitialize)(this.dataGridView)).BeginInit();
      this.panel1.SuspendLayout();
      this.SuspendLayout();
      // 
      // pnlTableName
      // 
      this.pnlTableName.Controls.Add(this.tbCurrentUser);
      this.pnlTableName.Controls.Add(this.lblCurrentUser);
      this.pnlTableName.Controls.Add(this.tbLogonUser);
      this.pnlTableName.Controls.Add(this.lblLogonUser);
      this.pnlTableName.Controls.Add(this.tbTableName);
      this.pnlTableName.Controls.Add(this.lblTableName);
      this.pnlTableName.Dock = System.Windows.Forms.DockStyle.Top;
      this.pnlTableName.Location = new System.Drawing.Point(0, 0);
      this.pnlTableName.Name = "pnlTableName";
      this.pnlTableName.Size = new System.Drawing.Size(542, 100);
      this.pnlTableName.TabIndex = 0;
      // 
      // tbCurrentUser
      // 
      this.tbCurrentUser.Location = new System.Drawing.Point(10, 65);
      this.tbCurrentUser.Name = "tbCurrentUser";
      this.tbCurrentUser.Size = new System.Drawing.Size(200, 20);
      this.tbCurrentUser.TabIndex = 10;
      // 
      // lblCurrentUser
      // 
      this.lblCurrentUser.AutoSize = true;
      this.lblCurrentUser.Location = new System.Drawing.Point(10, 50);
      this.lblCurrentUser.Name = "lblCurrentUser";
      this.lblCurrentUser.Size = new System.Drawing.Size(125, 13);
      this.lblCurrentUser.TabIndex = 9;
      this.lblCurrentUser.Text = "User / Schema (Current):";
      // 
      // tbLogonUser
      // 
      this.tbLogonUser.Location = new System.Drawing.Point(10, 25);
      this.tbLogonUser.Name = "tbLogonUser";
      this.tbLogonUser.Size = new System.Drawing.Size(200, 20);
      this.tbLogonUser.TabIndex = 8;
      // 
      // lblLogonUser
      // 
      this.lblLogonUser.AutoSize = true;
      this.lblLogonUser.Location = new System.Drawing.Point(10, 11);
      this.lblLogonUser.Name = "lblLogonUser";
      this.lblLogonUser.Size = new System.Drawing.Size(121, 13);
      this.lblLogonUser.TabIndex = 7;
      this.lblLogonUser.Text = "User / Schema (Logon):";
      // 
      // tbTableName
      // 
      this.tbTableName.Location = new System.Drawing.Point(230, 25);
      this.tbTableName.Name = "tbTableName";
      this.tbTableName.Size = new System.Drawing.Size(200, 20);
      this.tbTableName.TabIndex = 6;
      // 
      // lblTableName
      // 
      this.lblTableName.AutoSize = true;
      this.lblTableName.Location = new System.Drawing.Point(230, 11);
      this.lblTableName.Name = "lblTableName";
      this.lblTableName.Size = new System.Drawing.Size(66, 13);
      this.lblTableName.TabIndex = 5;
      this.lblTableName.Text = "Table name:";
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
      this.dataGridView.Location = new System.Drawing.Point(0, 100);
      this.dataGridView.Name = "dataGridView";
      this.dataGridView.Size = new System.Drawing.Size(542, 273);
      this.dataGridView.TabIndex = 12;
      // 
      // ColumnName
      // 
      this.ColumnName.HeaderText = "Column name";
      this.ColumnName.Name = "ColumnName";
      // 
      // DataType
      // 
      this.DataType.HeaderText = "Data type";
      this.DataType.Name = "DataType";
      // 
      // DataLength
      // 
      this.DataLength.HeaderText = "Data length";
      this.DataLength.Name = "DataLength";
      // 
      // panel1
      // 
      this.panel1.Controls.Add(this.btnCancel);
      this.panel1.Controls.Add(this.btnCreateModify);
      this.panel1.Dock = System.Windows.Forms.DockStyle.Bottom;
      this.panel1.Location = new System.Drawing.Point(0, 343);
      this.panel1.Name = "panel1";
      this.panel1.Size = new System.Drawing.Size(542, 30);
      this.panel1.TabIndex = 13;
      // 
      // btnCancel
      // 
      this.btnCancel.Location = new System.Drawing.Point(440, 5);
      this.btnCancel.Name = "btnCancel";
      this.btnCancel.Size = new System.Drawing.Size(100, 23);
      this.btnCancel.TabIndex = 1;
      this.btnCancel.Text = "Cancel";
      this.btnCancel.UseVisualStyleBackColor = true;
      this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
      // 
      // btnCreateModify
      // 
      this.btnCreateModify.Location = new System.Drawing.Point(330, 5);
      this.btnCreateModify.Name = "btnCreateModify";
      this.btnCreateModify.Size = new System.Drawing.Size(100, 23);
      this.btnCreateModify.TabIndex = 0;
      this.btnCreateModify.Text = "Create";
      this.btnCreateModify.UseVisualStyleBackColor = true;
      this.btnCreateModify.Click += new System.EventHandler(this.btnCreate_Click);
      // 
      // frmCreateModifyTable
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(542, 373);
      this.Controls.Add(this.panel1);
      this.Controls.Add(this.dataGridView);
      this.Controls.Add(this.pnlTableName);
      this.Name = "frmCreateModifyTable";
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
      this.Text = "Создание таблицы / редактирование полей";
      this.pnlTableName.ResumeLayout(false);
      this.pnlTableName.PerformLayout();
      ((System.ComponentModel.ISupportInitialize)(this.dataGridView)).EndInit();
      this.panel1.ResumeLayout(false);
      this.ResumeLayout(false);

    }

    #endregion

    private System.Windows.Forms.Panel pnlTableName;
    private System.Windows.Forms.Label lblTableName;
    private System.Windows.Forms.DataGridViewTextBoxColumn ColumnName;
    private System.Windows.Forms.DataGridViewTextBoxColumn DataType;
    private System.Windows.Forms.DataGridViewTextBoxColumn DataLength;
    private System.Windows.Forms.Panel panel1;
    private System.Windows.Forms.Button btnCancel;
    private System.Windows.Forms.Label lblLogonUser;
    public System.Windows.Forms.TextBox tbLogonUser;
    public System.Windows.Forms.TextBox tbCurrentUser;
    private System.Windows.Forms.Label lblCurrentUser;
    public System.Windows.Forms.TextBox tbTableName;
    public System.Windows.Forms.Button btnCreateModify;
    public System.Windows.Forms.DataGridView dataGridView;
  }
}