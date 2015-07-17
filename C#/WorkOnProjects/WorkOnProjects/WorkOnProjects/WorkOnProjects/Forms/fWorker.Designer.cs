namespace WorkOnProjects
{
  partial class frmWorker
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
      this.components = new System.ComponentModel.Container();
      this.dgWorker = new System.Windows.Forms.DataGridView();
      this.ID = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.FIO = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.EMAIL = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.contextMenuStrip = new System.Windows.Forms.ContextMenuStrip(this.components);
      this.cmAdd = new System.Windows.Forms.ToolStripMenuItem();
      this.cmEdit = new System.Windows.Forms.ToolStripMenuItem();
      this.cmDelete = new System.Windows.Forms.ToolStripMenuItem();
      ((System.ComponentModel.ISupportInitialize)(this.dgWorker)).BeginInit();
      this.contextMenuStrip.SuspendLayout();
      this.SuspendLayout();
      // 
      // dgWorker
      // 
      this.dgWorker.AllowUserToAddRows = false;
      this.dgWorker.AllowUserToDeleteRows = false;
      this.dgWorker.AllowUserToResizeRows = false;
      this.dgWorker.BorderStyle = System.Windows.Forms.BorderStyle.None;
      this.dgWorker.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
      this.dgWorker.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.ID,
            this.FIO,
            this.EMAIL});
      this.dgWorker.ContextMenuStrip = this.contextMenuStrip;
      this.dgWorker.Dock = System.Windows.Forms.DockStyle.Fill;
      this.dgWorker.Location = new System.Drawing.Point(0, 0);
      this.dgWorker.MultiSelect = false;
      this.dgWorker.Name = "dgWorker";
      this.dgWorker.ReadOnly = true;
      this.dgWorker.RowHeadersVisible = false;
      this.dgWorker.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
      this.dgWorker.Size = new System.Drawing.Size(792, 473);
      this.dgWorker.TabIndex = 1;
      // 
      // ID
      // 
      this.ID.HeaderText = "ID";
      this.ID.Name = "ID";
      this.ID.ReadOnly = true;
      // 
      // FIO
      // 
      this.FIO.HeaderText = "ФИО";
      this.FIO.Name = "FIO";
      this.FIO.ReadOnly = true;
      // 
      // EMAIL
      // 
      this.EMAIL.HeaderText = "E-mail";
      this.EMAIL.Name = "EMAIL";
      this.EMAIL.ReadOnly = true;
      // 
      // contextMenuStrip
      // 
      this.contextMenuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.cmAdd,
            this.cmEdit,
            this.cmDelete});
      this.contextMenuStrip.Name = "contextMenuStrip";
      this.contextMenuStrip.Size = new System.Drawing.Size(154, 70);
      this.contextMenuStrip.Opening += new System.ComponentModel.CancelEventHandler(this.contextMenuStrip_Opening);
      // 
      // cmAdd
      // 
      this.cmAdd.Image = global::WorkOnProjects.Properties.Resources.add;
      this.cmAdd.Name = "cmAdd";
      this.cmAdd.Size = new System.Drawing.Size(153, 22);
      this.cmAdd.Text = "добавить";
      this.cmAdd.Click += new System.EventHandler(this.добавитьToolStripMenuItem_Click);
      // 
      // cmEdit
      // 
      this.cmEdit.Image = global::WorkOnProjects.Properties.Resources.edit;
      this.cmEdit.Name = "cmEdit";
      this.cmEdit.Size = new System.Drawing.Size(153, 22);
      this.cmEdit.Text = "редактировать";
      this.cmEdit.Click += new System.EventHandler(this.редактироватьToolStripMenuItem_Click);
      // 
      // cmDelete
      // 
      this.cmDelete.Image = global::WorkOnProjects.Properties.Resources.delete;
      this.cmDelete.Name = "cmDelete";
      this.cmDelete.Size = new System.Drawing.Size(153, 22);
      this.cmDelete.Text = "удалить";
      this.cmDelete.Click += new System.EventHandler(this.удалитьToolStripMenuItem_Click);
      // 
      // frmWorker
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(792, 473);
      this.Controls.Add(this.dgWorker);
      this.Name = "frmWorker";
      this.Text = "Работники";
      this.Shown += new System.EventHandler(this.frmWorker_Shown);
      ((System.ComponentModel.ISupportInitialize)(this.dgWorker)).EndInit();
      this.contextMenuStrip.ResumeLayout(false);
      this.ResumeLayout(false);

    }

    #endregion

    private System.Windows.Forms.ContextMenuStrip contextMenuStrip;
    private System.Windows.Forms.ToolStripMenuItem cmAdd;
    private System.Windows.Forms.ToolStripMenuItem cmEdit;
    private System.Windows.Forms.ToolStripMenuItem cmDelete;
    private System.Windows.Forms.DataGridViewTextBoxColumn ID;
    private System.Windows.Forms.DataGridViewTextBoxColumn FIO;
    private System.Windows.Forms.DataGridViewTextBoxColumn EMAIL;
    public System.Windows.Forms.DataGridView dgWorker;
  }
}