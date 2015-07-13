namespace WorkOnProjects
{
  partial class frmProject
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
      this.pnlProject = new System.Windows.Forms.Panel();
      this.dgProject = new System.Windows.Forms.DataGridView();
      this.contextMenuStrip = new System.Windows.Forms.ContextMenuStrip(this.components);
      this.cmAdd = new System.Windows.Forms.ToolStripMenuItem();
      this.cmEdit = new System.Windows.Forms.ToolStripMenuItem();
      this.cmDelete = new System.Windows.Forms.ToolStripMenuItem();
      this.splitter1 = new System.Windows.Forms.Splitter();
      this.pnlFilter = new System.Windows.Forms.Panel();
      this.lblPeriod = new System.Windows.Forms.Label();
      this.tbManager = new System.Windows.Forms.TextBox();
      this.lblEDate = new System.Windows.Forms.Label();
      this.lblPriority = new System.Windows.Forms.Label();
      this.lblManager = new System.Windows.Forms.Label();
      this.cbEDate = new System.Windows.Forms.DateTimePicker();
      this.cbBDate = new System.Windows.Forms.DateTimePicker();
      this.lblBDate = new System.Windows.Forms.Label();
      this.cbPriority = new System.Windows.Forms.ComboBox();
      this.tbName = new System.Windows.Forms.TextBox();
      this.pnlFilterCaption = new System.Windows.Forms.Panel();
      this.lblFilterCaption = new System.Windows.Forms.Label();
      this.splitter2 = new System.Windows.Forms.Splitter();
      this.pnlWorkerInProject = new System.Windows.Forms.Panel();
      this.dgWorkerInProject = new System.Windows.Forms.DataGridView();
      this.dataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.dataGridViewTextBoxColumn2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.pnlWorkerInCaption = new System.Windows.Forms.Panel();
      this.lblWorkerInCaption = new System.Windows.Forms.Label();
      this.pnlWorkerOut = new System.Windows.Forms.Panel();
      this.btnWorkerOut = new System.Windows.Forms.Button();
      this.pnlWorkerOutProject = new System.Windows.Forms.Panel();
      this.dgWorkerOutProject = new System.Windows.Forms.DataGridView();
      this.dataGridViewTextBoxColumn4 = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.dataGridViewTextBoxColumn5 = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.pnlWorkerOutCaption = new System.Windows.Forms.Panel();
      this.lblWorkerOutCaption = new System.Windows.Forms.Label();
      this.pnlWorkerIn = new System.Windows.Forms.Panel();
      this.btnWorkerIn = new System.Windows.Forms.Button();
      this.toolTip = new System.Windows.Forms.ToolTip(this.components);
      this.ID = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.NAME = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.CLIENT = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.EXECUTOR = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.MANAGER = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.BDATE = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.EDATE = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.PRIORITY = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.COMMENT = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.MANAGER_ID = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.pnlProject.SuspendLayout();
      ((System.ComponentModel.ISupportInitialize)(this.dgProject)).BeginInit();
      this.contextMenuStrip.SuspendLayout();
      this.pnlFilter.SuspendLayout();
      this.pnlFilterCaption.SuspendLayout();
      this.pnlWorkerInProject.SuspendLayout();
      ((System.ComponentModel.ISupportInitialize)(this.dgWorkerInProject)).BeginInit();
      this.pnlWorkerInCaption.SuspendLayout();
      this.pnlWorkerOut.SuspendLayout();
      this.pnlWorkerOutProject.SuspendLayout();
      ((System.ComponentModel.ISupportInitialize)(this.dgWorkerOutProject)).BeginInit();
      this.pnlWorkerOutCaption.SuspendLayout();
      this.pnlWorkerIn.SuspendLayout();
      this.SuspendLayout();
      // 
      // pnlProject
      // 
      this.pnlProject.Controls.Add(this.dgProject);
      this.pnlProject.Controls.Add(this.splitter1);
      this.pnlProject.Controls.Add(this.pnlFilter);
      this.pnlProject.Dock = System.Windows.Forms.DockStyle.Top;
      this.pnlProject.Location = new System.Drawing.Point(0, 0);
      this.pnlProject.Name = "pnlProject";
      this.pnlProject.Size = new System.Drawing.Size(792, 225);
      this.pnlProject.TabIndex = 0;
      // 
      // dgProject
      // 
      this.dgProject.AllowUserToAddRows = false;
      this.dgProject.AllowUserToDeleteRows = false;
      this.dgProject.AllowUserToResizeRows = false;
      this.dgProject.BorderStyle = System.Windows.Forms.BorderStyle.None;
      this.dgProject.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
      this.dgProject.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.ID,
            this.NAME,
            this.CLIENT,
            this.EXECUTOR,
            this.MANAGER,
            this.BDATE,
            this.EDATE,
            this.PRIORITY,
            this.COMMENT,
            this.MANAGER_ID});
      this.dgProject.ContextMenuStrip = this.contextMenuStrip;
      this.dgProject.Dock = System.Windows.Forms.DockStyle.Fill;
      this.dgProject.Location = new System.Drawing.Point(203, 0);
      this.dgProject.MultiSelect = false;
      this.dgProject.Name = "dgProject";
      this.dgProject.ReadOnly = true;
      this.dgProject.RowHeadersVisible = false;
      this.dgProject.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
      this.dgProject.Size = new System.Drawing.Size(589, 225);
      this.dgProject.TabIndex = 2;
      this.dgProject.SelectionChanged += new System.EventHandler(this.dgProject_SelectionChanged);
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
      this.cmAdd.Click += new System.EventHandler(this.cmAdd_Click);
      // 
      // cmEdit
      // 
      this.cmEdit.Image = global::WorkOnProjects.Properties.Resources.edit;
      this.cmEdit.Name = "cmEdit";
      this.cmEdit.Size = new System.Drawing.Size(153, 22);
      this.cmEdit.Text = "редактировать";
      this.cmEdit.Click += new System.EventHandler(this.cmEdit_Click);
      // 
      // cmDelete
      // 
      this.cmDelete.Image = global::WorkOnProjects.Properties.Resources.delete;
      this.cmDelete.Name = "cmDelete";
      this.cmDelete.Size = new System.Drawing.Size(153, 22);
      this.cmDelete.Text = "удалить";
      this.cmDelete.Click += new System.EventHandler(this.cmDelete_Click);
      // 
      // splitter1
      // 
      this.splitter1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
      this.splitter1.Location = new System.Drawing.Point(200, 0);
      this.splitter1.Name = "splitter1";
      this.splitter1.Size = new System.Drawing.Size(3, 225);
      this.splitter1.TabIndex = 1;
      this.splitter1.TabStop = false;
      // 
      // pnlFilter
      // 
      this.pnlFilter.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
      this.pnlFilter.Controls.Add(this.lblPeriod);
      this.pnlFilter.Controls.Add(this.tbManager);
      this.pnlFilter.Controls.Add(this.lblEDate);
      this.pnlFilter.Controls.Add(this.lblPriority);
      this.pnlFilter.Controls.Add(this.lblManager);
      this.pnlFilter.Controls.Add(this.cbEDate);
      this.pnlFilter.Controls.Add(this.cbBDate);
      this.pnlFilter.Controls.Add(this.lblBDate);
      this.pnlFilter.Controls.Add(this.cbPriority);
      this.pnlFilter.Controls.Add(this.tbName);
      this.pnlFilter.Controls.Add(this.pnlFilterCaption);
      this.pnlFilter.Dock = System.Windows.Forms.DockStyle.Left;
      this.pnlFilter.Location = new System.Drawing.Point(0, 0);
      this.pnlFilter.Name = "pnlFilter";
      this.pnlFilter.Size = new System.Drawing.Size(200, 225);
      this.pnlFilter.TabIndex = 0;
      this.pnlFilter.Resize += new System.EventHandler(this.pnlFilter_Resize);
      // 
      // lblPeriod
      // 
      this.lblPeriod.AutoSize = true;
      this.lblPeriod.ForeColor = System.Drawing.SystemColors.ControlText;
      this.lblPeriod.Location = new System.Drawing.Point(5, 105);
      this.lblPeriod.Name = "lblPeriod";
      this.lblPeriod.Size = new System.Drawing.Size(48, 13);
      this.lblPeriod.TabIndex = 35;
      this.lblPeriod.Text = "Период:";
      // 
      // tbManager
      // 
      this.tbManager.Location = new System.Drawing.Point(5, 40);
      this.tbManager.Name = "tbManager";
      this.tbManager.Size = new System.Drawing.Size(190, 20);
      this.tbManager.TabIndex = 34;
      this.tbManager.TextChanged += new System.EventHandler(this.tbManager_TextChanged);
      // 
      // lblEDate
      // 
      this.lblEDate.AutoSize = true;
      this.lblEDate.ForeColor = System.Drawing.SystemColors.ControlText;
      this.lblEDate.Location = new System.Drawing.Point(5, 150);
      this.lblEDate.Name = "lblEDate";
      this.lblEDate.Size = new System.Drawing.Size(22, 13);
      this.lblEDate.TabIndex = 33;
      this.lblEDate.Text = "по:";
      // 
      // lblPriority
      // 
      this.lblPriority.AutoSize = true;
      this.lblPriority.ForeColor = System.Drawing.SystemColors.ControlText;
      this.lblPriority.Location = new System.Drawing.Point(5, 65);
      this.lblPriority.Name = "lblPriority";
      this.lblPriority.Size = new System.Drawing.Size(64, 13);
      this.lblPriority.TabIndex = 31;
      this.lblPriority.Text = "Приоритет:";
      // 
      // lblManager
      // 
      this.lblManager.AutoSize = true;
      this.lblManager.ForeColor = System.Drawing.SystemColors.ControlText;
      this.lblManager.Location = new System.Drawing.Point(5, 25);
      this.lblManager.Name = "lblManager";
      this.lblManager.Size = new System.Drawing.Size(81, 13);
      this.lblManager.TabIndex = 26;
      this.lblManager.Text = "Руководитель:";
      // 
      // cbEDate
      // 
      this.cbEDate.Format = System.Windows.Forms.DateTimePickerFormat.Short;
      this.cbEDate.Location = new System.Drawing.Point(27, 145);
      this.cbEDate.Name = "cbEDate";
      this.cbEDate.Size = new System.Drawing.Size(93, 20);
      this.cbEDate.TabIndex = 30;
      this.cbEDate.ValueChanged += new System.EventHandler(this.tbManager_TextChanged);
      // 
      // cbBDate
      // 
      this.cbBDate.Format = System.Windows.Forms.DateTimePickerFormat.Short;
      this.cbBDate.Location = new System.Drawing.Point(27, 120);
      this.cbBDate.Name = "cbBDate";
      this.cbBDate.Size = new System.Drawing.Size(93, 20);
      this.cbBDate.TabIndex = 29;
      this.cbBDate.ValueChanged += new System.EventHandler(this.tbManager_TextChanged);
      // 
      // lblBDate
      // 
      this.lblBDate.AutoSize = true;
      this.lblBDate.ForeColor = System.Drawing.SystemColors.ControlText;
      this.lblBDate.Location = new System.Drawing.Point(5, 125);
      this.lblBDate.Name = "lblBDate";
      this.lblBDate.Size = new System.Drawing.Size(16, 13);
      this.lblBDate.TabIndex = 27;
      this.lblBDate.Text = "с:";
      // 
      // cbPriority
      // 
      this.cbPriority.FormattingEnabled = true;
      this.cbPriority.Location = new System.Drawing.Point(5, 80);
      this.cbPriority.Name = "cbPriority";
      this.cbPriority.Size = new System.Drawing.Size(190, 21);
      this.cbPriority.TabIndex = 32;
      this.cbPriority.SelectedIndexChanged += new System.EventHandler(this.tbManager_TextChanged);
      // 
      // tbName
      // 
      this.tbName.Location = new System.Drawing.Point(-61, -19);
      this.tbName.Name = "tbName";
      this.tbName.Size = new System.Drawing.Size(320, 20);
      this.tbName.TabIndex = 28;
      // 
      // pnlFilterCaption
      // 
      this.pnlFilterCaption.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
      this.pnlFilterCaption.Controls.Add(this.lblFilterCaption);
      this.pnlFilterCaption.Dock = System.Windows.Forms.DockStyle.Top;
      this.pnlFilterCaption.Location = new System.Drawing.Point(0, 0);
      this.pnlFilterCaption.Name = "pnlFilterCaption";
      this.pnlFilterCaption.Size = new System.Drawing.Size(198, 20);
      this.pnlFilterCaption.TabIndex = 2;
      // 
      // lblFilterCaption
      // 
      this.lblFilterCaption.AutoSize = true;
      this.lblFilterCaption.Location = new System.Drawing.Point(5, 2);
      this.lblFilterCaption.Name = "lblFilterCaption";
      this.lblFilterCaption.Size = new System.Drawing.Size(109, 13);
      this.lblFilterCaption.TabIndex = 0;
      this.lblFilterCaption.Text = "Панель фильтрации";
      // 
      // splitter2
      // 
      this.splitter2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
      this.splitter2.Dock = System.Windows.Forms.DockStyle.Top;
      this.splitter2.Location = new System.Drawing.Point(0, 225);
      this.splitter2.Name = "splitter2";
      this.splitter2.Size = new System.Drawing.Size(792, 3);
      this.splitter2.TabIndex = 1;
      this.splitter2.TabStop = false;
      // 
      // pnlWorkerInProject
      // 
      this.pnlWorkerInProject.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
      this.pnlWorkerInProject.Controls.Add(this.dgWorkerInProject);
      this.pnlWorkerInProject.Controls.Add(this.pnlWorkerInCaption);
      this.pnlWorkerInProject.Controls.Add(this.pnlWorkerOut);
      this.pnlWorkerInProject.Dock = System.Windows.Forms.DockStyle.Left;
      this.pnlWorkerInProject.Location = new System.Drawing.Point(0, 228);
      this.pnlWorkerInProject.Name = "pnlWorkerInProject";
      this.pnlWorkerInProject.Size = new System.Drawing.Size(400, 245);
      this.pnlWorkerInProject.TabIndex = 2;
      // 
      // dgWorkerInProject
      // 
      this.dgWorkerInProject.AllowUserToAddRows = false;
      this.dgWorkerInProject.AllowUserToDeleteRows = false;
      this.dgWorkerInProject.AllowUserToResizeRows = false;
      this.dgWorkerInProject.BorderStyle = System.Windows.Forms.BorderStyle.None;
      this.dgWorkerInProject.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
      this.dgWorkerInProject.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.dataGridViewTextBoxColumn1,
            this.dataGridViewTextBoxColumn2});
      this.dgWorkerInProject.Dock = System.Windows.Forms.DockStyle.Fill;
      this.dgWorkerInProject.Location = new System.Drawing.Point(0, 20);
      this.dgWorkerInProject.MultiSelect = false;
      this.dgWorkerInProject.Name = "dgWorkerInProject";
      this.dgWorkerInProject.ReadOnly = true;
      this.dgWorkerInProject.RowHeadersVisible = false;
      this.dgWorkerInProject.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
      this.dgWorkerInProject.Size = new System.Drawing.Size(398, 193);
      this.dgWorkerInProject.TabIndex = 2;
      // 
      // dataGridViewTextBoxColumn1
      // 
      this.dataGridViewTextBoxColumn1.HeaderText = "ID";
      this.dataGridViewTextBoxColumn1.Name = "dataGridViewTextBoxColumn1";
      this.dataGridViewTextBoxColumn1.ReadOnly = true;
      // 
      // dataGridViewTextBoxColumn2
      // 
      this.dataGridViewTextBoxColumn2.HeaderText = "ФИО";
      this.dataGridViewTextBoxColumn2.Name = "dataGridViewTextBoxColumn2";
      this.dataGridViewTextBoxColumn2.ReadOnly = true;
      // 
      // pnlWorkerInCaption
      // 
      this.pnlWorkerInCaption.Controls.Add(this.lblWorkerInCaption);
      this.pnlWorkerInCaption.Dock = System.Windows.Forms.DockStyle.Top;
      this.pnlWorkerInCaption.Location = new System.Drawing.Point(0, 0);
      this.pnlWorkerInCaption.Name = "pnlWorkerInCaption";
      this.pnlWorkerInCaption.Size = new System.Drawing.Size(398, 20);
      this.pnlWorkerInCaption.TabIndex = 1;
      // 
      // lblWorkerInCaption
      // 
      this.lblWorkerInCaption.AutoSize = true;
      this.lblWorkerInCaption.Location = new System.Drawing.Point(0, 5);
      this.lblWorkerInCaption.Name = "lblWorkerInCaption";
      this.lblWorkerInCaption.Size = new System.Drawing.Size(105, 13);
      this.lblWorkerInCaption.TabIndex = 0;
      this.lblWorkerInCaption.Text = "Работники проекта";
      // 
      // pnlWorkerOut
      // 
      this.pnlWorkerOut.Controls.Add(this.btnWorkerOut);
      this.pnlWorkerOut.Dock = System.Windows.Forms.DockStyle.Bottom;
      this.pnlWorkerOut.Location = new System.Drawing.Point(0, 213);
      this.pnlWorkerOut.Name = "pnlWorkerOut";
      this.pnlWorkerOut.Size = new System.Drawing.Size(398, 30);
      this.pnlWorkerOut.TabIndex = 0;
      // 
      // btnWorkerOut
      // 
      this.btnWorkerOut.Dock = System.Windows.Forms.DockStyle.Fill;
      this.btnWorkerOut.Image = global::WorkOnProjects.Properties.Resources.worker_out;
      this.btnWorkerOut.Location = new System.Drawing.Point(0, 0);
      this.btnWorkerOut.Name = "btnWorkerOut";
      this.btnWorkerOut.Size = new System.Drawing.Size(398, 30);
      this.btnWorkerOut.TabIndex = 1;
      this.btnWorkerOut.UseVisualStyleBackColor = true;
      this.btnWorkerOut.Click += new System.EventHandler(this.btnWorkerOut_Click);
      // 
      // pnlWorkerOutProject
      // 
      this.pnlWorkerOutProject.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
      this.pnlWorkerOutProject.Controls.Add(this.dgWorkerOutProject);
      this.pnlWorkerOutProject.Controls.Add(this.pnlWorkerOutCaption);
      this.pnlWorkerOutProject.Controls.Add(this.pnlWorkerIn);
      this.pnlWorkerOutProject.Dock = System.Windows.Forms.DockStyle.Fill;
      this.pnlWorkerOutProject.Location = new System.Drawing.Point(400, 228);
      this.pnlWorkerOutProject.Name = "pnlWorkerOutProject";
      this.pnlWorkerOutProject.Size = new System.Drawing.Size(392, 245);
      this.pnlWorkerOutProject.TabIndex = 3;
      // 
      // dgWorkerOutProject
      // 
      this.dgWorkerOutProject.AllowUserToAddRows = false;
      this.dgWorkerOutProject.AllowUserToDeleteRows = false;
      this.dgWorkerOutProject.AllowUserToResizeRows = false;
      this.dgWorkerOutProject.BorderStyle = System.Windows.Forms.BorderStyle.None;
      this.dgWorkerOutProject.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
      this.dgWorkerOutProject.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.dataGridViewTextBoxColumn4,
            this.dataGridViewTextBoxColumn5});
      this.dgWorkerOutProject.Dock = System.Windows.Forms.DockStyle.Fill;
      this.dgWorkerOutProject.Location = new System.Drawing.Point(0, 20);
      this.dgWorkerOutProject.MultiSelect = false;
      this.dgWorkerOutProject.Name = "dgWorkerOutProject";
      this.dgWorkerOutProject.ReadOnly = true;
      this.dgWorkerOutProject.RowHeadersVisible = false;
      this.dgWorkerOutProject.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
      this.dgWorkerOutProject.Size = new System.Drawing.Size(390, 193);
      this.dgWorkerOutProject.TabIndex = 3;
      // 
      // dataGridViewTextBoxColumn4
      // 
      this.dataGridViewTextBoxColumn4.HeaderText = "ID";
      this.dataGridViewTextBoxColumn4.Name = "dataGridViewTextBoxColumn4";
      this.dataGridViewTextBoxColumn4.ReadOnly = true;
      // 
      // dataGridViewTextBoxColumn5
      // 
      this.dataGridViewTextBoxColumn5.HeaderText = "ФИО";
      this.dataGridViewTextBoxColumn5.Name = "dataGridViewTextBoxColumn5";
      this.dataGridViewTextBoxColumn5.ReadOnly = true;
      // 
      // pnlWorkerOutCaption
      // 
      this.pnlWorkerOutCaption.Controls.Add(this.lblWorkerOutCaption);
      this.pnlWorkerOutCaption.Dock = System.Windows.Forms.DockStyle.Top;
      this.pnlWorkerOutCaption.Location = new System.Drawing.Point(0, 0);
      this.pnlWorkerOutCaption.Name = "pnlWorkerOutCaption";
      this.pnlWorkerOutCaption.Size = new System.Drawing.Size(390, 20);
      this.pnlWorkerOutCaption.TabIndex = 2;
      // 
      // lblWorkerOutCaption
      // 
      this.lblWorkerOutCaption.AutoSize = true;
      this.lblWorkerOutCaption.Location = new System.Drawing.Point(0, 5);
      this.lblWorkerOutCaption.Name = "lblWorkerOutCaption";
      this.lblWorkerOutCaption.Size = new System.Drawing.Size(126, 13);
      this.lblWorkerOutCaption.TabIndex = 0;
      this.lblWorkerOutCaption.Text = "Работники вне проекта";
      // 
      // pnlWorkerIn
      // 
      this.pnlWorkerIn.Controls.Add(this.btnWorkerIn);
      this.pnlWorkerIn.Dock = System.Windows.Forms.DockStyle.Bottom;
      this.pnlWorkerIn.Location = new System.Drawing.Point(0, 213);
      this.pnlWorkerIn.Name = "pnlWorkerIn";
      this.pnlWorkerIn.Size = new System.Drawing.Size(390, 30);
      this.pnlWorkerIn.TabIndex = 1;
      // 
      // btnWorkerIn
      // 
      this.btnWorkerIn.Dock = System.Windows.Forms.DockStyle.Fill;
      this.btnWorkerIn.Image = global::WorkOnProjects.Properties.Resources.worker_in;
      this.btnWorkerIn.Location = new System.Drawing.Point(0, 0);
      this.btnWorkerIn.Name = "btnWorkerIn";
      this.btnWorkerIn.Size = new System.Drawing.Size(390, 30);
      this.btnWorkerIn.TabIndex = 1;
      this.btnWorkerIn.UseVisualStyleBackColor = true;
      this.btnWorkerIn.Click += new System.EventHandler(this.btnWorkerIn_Click);
      // 
      // ID
      // 
      this.ID.HeaderText = "ID";
      this.ID.Name = "ID";
      this.ID.ReadOnly = true;
      // 
      // NAME
      // 
      this.NAME.HeaderText = "Название";
      this.NAME.Name = "NAME";
      this.NAME.ReadOnly = true;
      // 
      // CLIENT
      // 
      this.CLIENT.HeaderText = "Компания заказчик";
      this.CLIENT.Name = "CLIENT";
      this.CLIENT.ReadOnly = true;
      // 
      // EXECUTOR
      // 
      this.EXECUTOR.HeaderText = "Компания исполнитель";
      this.EXECUTOR.Name = "EXECUTOR";
      this.EXECUTOR.ReadOnly = true;
      // 
      // MANAGER
      // 
      this.MANAGER.HeaderText = "Руководитель";
      this.MANAGER.Name = "MANAGER";
      this.MANAGER.ReadOnly = true;
      // 
      // BDATE
      // 
      this.BDATE.HeaderText = "Дата начала";
      this.BDATE.MaxInputLength = 10;
      this.BDATE.Name = "BDATE";
      this.BDATE.ReadOnly = true;
      // 
      // EDATE
      // 
      this.EDATE.HeaderText = "Дата окончания";
      this.EDATE.MaxInputLength = 10;
      this.EDATE.Name = "EDATE";
      this.EDATE.ReadOnly = true;
      // 
      // PRIORITY
      // 
      this.PRIORITY.HeaderText = "Приоритет";
      this.PRIORITY.Name = "PRIORITY";
      this.PRIORITY.ReadOnly = true;
      // 
      // COMMENT
      // 
      this.COMMENT.HeaderText = "Комментарий";
      this.COMMENT.Name = "COMMENT";
      this.COMMENT.ReadOnly = true;
      // 
      // MANAGER_ID
      // 
      this.MANAGER_ID.HeaderText = "MANAGER_ID";
      this.MANAGER_ID.Name = "MANAGER_ID";
      this.MANAGER_ID.ReadOnly = true;
      this.MANAGER_ID.Visible = false;
      // 
      // frmProject
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(792, 473);
      this.Controls.Add(this.pnlWorkerOutProject);
      this.Controls.Add(this.pnlWorkerInProject);
      this.Controls.Add(this.splitter2);
      this.Controls.Add(this.pnlProject);
      this.Name = "frmProject";
      this.Text = "Проекты";
      this.Shown += new System.EventHandler(this.frmProject_Shown);
      this.Resize += new System.EventHandler(this.frmProject_Resize);
      this.pnlProject.ResumeLayout(false);
      ((System.ComponentModel.ISupportInitialize)(this.dgProject)).EndInit();
      this.contextMenuStrip.ResumeLayout(false);
      this.pnlFilter.ResumeLayout(false);
      this.pnlFilter.PerformLayout();
      this.pnlFilterCaption.ResumeLayout(false);
      this.pnlFilterCaption.PerformLayout();
      this.pnlWorkerInProject.ResumeLayout(false);
      ((System.ComponentModel.ISupportInitialize)(this.dgWorkerInProject)).EndInit();
      this.pnlWorkerInCaption.ResumeLayout(false);
      this.pnlWorkerInCaption.PerformLayout();
      this.pnlWorkerOut.ResumeLayout(false);
      this.pnlWorkerOutProject.ResumeLayout(false);
      ((System.ComponentModel.ISupportInitialize)(this.dgWorkerOutProject)).EndInit();
      this.pnlWorkerOutCaption.ResumeLayout(false);
      this.pnlWorkerOutCaption.PerformLayout();
      this.pnlWorkerIn.ResumeLayout(false);
      this.ResumeLayout(false);

    }

    #endregion

    private System.Windows.Forms.Panel pnlProject;
    private System.Windows.Forms.Panel pnlFilter;
    private System.Windows.Forms.Splitter splitter1;
    private System.Windows.Forms.Splitter splitter2;
    public System.Windows.Forms.DataGridView dgProject;
    private System.Windows.Forms.Panel pnlWorkerInProject;
    private System.Windows.Forms.Panel pnlWorkerOutProject;
    private System.Windows.Forms.Panel pnlWorkerOut;
    private System.Windows.Forms.Button btnWorkerOut;
    private System.Windows.Forms.Panel pnlWorkerIn;
    private System.Windows.Forms.Button btnWorkerIn;
    private System.Windows.Forms.Panel pnlWorkerInCaption;
    private System.Windows.Forms.Label lblWorkerInCaption;
    private System.Windows.Forms.Panel pnlWorkerOutCaption;
    private System.Windows.Forms.Label lblWorkerOutCaption;
    public System.Windows.Forms.DataGridView dgWorkerInProject;
    public System.Windows.Forms.DataGridView dgWorkerOutProject;
    private System.Windows.Forms.Panel pnlFilterCaption;
    private System.Windows.Forms.Label lblFilterCaption;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn4;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn5;
    private System.Windows.Forms.ToolTip toolTip;
    private System.Windows.Forms.ContextMenuStrip contextMenuStrip;
    private System.Windows.Forms.ToolStripMenuItem cmAdd;
    private System.Windows.Forms.ToolStripMenuItem cmEdit;
    private System.Windows.Forms.ToolStripMenuItem cmDelete;
    private System.Windows.Forms.Label lblPriority;
    private System.Windows.Forms.Label lblManager;
    public System.Windows.Forms.DateTimePicker cbEDate;
    public System.Windows.Forms.DateTimePicker cbBDate;
    private System.Windows.Forms.Label lblBDate;
    public System.Windows.Forms.ComboBox cbPriority;
    public System.Windows.Forms.TextBox tbName;
    private System.Windows.Forms.Label lblEDate;
    private System.Windows.Forms.Label lblPeriod;
    public System.Windows.Forms.TextBox tbManager;
    private System.Windows.Forms.DataGridViewTextBoxColumn ID;
    private System.Windows.Forms.DataGridViewTextBoxColumn NAME;
    private System.Windows.Forms.DataGridViewTextBoxColumn CLIENT;
    private System.Windows.Forms.DataGridViewTextBoxColumn EXECUTOR;
    private System.Windows.Forms.DataGridViewTextBoxColumn MANAGER;
    private System.Windows.Forms.DataGridViewTextBoxColumn BDATE;
    private System.Windows.Forms.DataGridViewTextBoxColumn EDATE;
    private System.Windows.Forms.DataGridViewTextBoxColumn PRIORITY;
    private System.Windows.Forms.DataGridViewTextBoxColumn COMMENT;
    private System.Windows.Forms.DataGridViewTextBoxColumn MANAGER_ID;
  }
}