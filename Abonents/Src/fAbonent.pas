//��������
unit fAbonent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList,
  DBCtrls, LMDCustomControl, LMDCustomPanel,
  LMDCustomBevelPanel, LMDCustomParentPanel, LMDCustomPanelFill,
  LMDWndButtonShape, IB_UpdateBar, IB_TransactionBar, IB_SearchBar,
  IB_NavigationBar, IB_Controls, ComCtrls, LMDControl, LMDBaseControl,
  LMDBaseGraphicControl, LMDGraphicControl, LMDBaseMeter,
  LMDCustomProgress, LMDDBProgress, LMDDBBtn, TB97Ctls, TB97, TB97Tlbr,
  ActnList, IB_Components, PrnDbgeh, EasyGraph;

type
  TfrmAbonent = class(TForm)
    pnlFilter: TPanel;
    SplitterVertical: TRxSplitter;
    pnlFilterTop: TPanel;
    mdAbonent: TRxMemoryData;
    dsAbonent: TDataSource;
    lblFIO: TLabel;
    edFIO: TDBEditEh;
    pnlGrid: TPanel;
    GridAbonent: TDBGridEh;
    mdSaldo: TRxMemoryData;
    dsSaldo: TDataSource;
    pmAbonent: TPopupMenu;
    pmAbonentAdd: TMenuItem;
    pmAbonentEdit: TMenuItem;
    pmAbonentDelete: TMenuItem;
    N1: TMenuItem;
    pmAbonentRefresh: TMenuItem;
    pnlBuhInfo: TPanel;
    SplitterHorizontal: TRxSplitter;
    ImageList: TImageList;
    SaldoActions: TActionList;
    AcAddSaldo: TAction;
    AcEditSaldo: TAction;
    AcDeleteSaldo: TAction;
    AcRefreshSaldo: TAction;
    pmSaldo: TPopupMenu;
    pmSaldoAdd: TMenuItem;
    pmSaldoEdit: TMenuItem;
    pmSaldoDelete: TMenuItem;
    N2: TMenuItem;
    pmSaldoRefresh: TMenuItem;
    PageControl: TPageControl;
    tsSaldo: TTabSheet;
    tsPay: TTabSheet;
    GridSaldo: TDBGridEh;
    pnlSaldoControl: TPanel;
    DockSaldo: TDock97;
    SaldoToolbar: TToolbar97;
    btnRefresh: TToolbarButton97;
    btnAdd: TToolbarButton97;
    btnEdit: TToolbarButton97;
    btnDelete: TToolbarButton97;
    cbVisibleBuhInfo: TCheckBox;
    mdAbonentABONENT_ID: TStringField;
    mdAbonentSERVICE: TStringField;
    mdAbonentSUB_SRV: TStringField;
    mdAbonentCITY: TStringField;
    mdAbonentSTREET: TStringField;
    mdAbonentFIO: TStringField;
    mdAbonentBUILDING: TStringField;
    mdAbonentAPARTMENT: TStringField;
    mdAbonentACC_PU: TStringField;
    mdAbonentOPEN_TIME: TDateTimeField;
    mdAbonentCLOSE_TIME: TDateTimeField;
    mdAbonentIS_ACC_LOCK: TSmallintField;
    mdAbonentIS_ACC_CLOSE: TSmallintField;
    mdAbonentBALANCE: TFloatField;
    lblService: TLabel;
    cbService: TDBComboBoxEh;
    lblSubSrv: TLabel;
    cbCity: TDBComboBoxEh;
    lblCity: TLabel;
    cbSubSrv: TDBComboBoxEh;
    edStreet: TDBEditEh;
    lblStreet: TLabel;
    ID: TIntegerField;
    mdSaldoPERIOD_END: TDateField;
    mdSaldoSUMM: TFloatField;
    mdSaldoPERIOD_BEGIN: TDateField;
    mdSaldoIS_EXPORT: TSmallintField;
    GridPay: TDBGridEh;
    dsPay: TDataSource;
    mdPay: TRxMemoryData;
    mdPayDATE_PAY: TDateField;
    mdPaySUMM: TFloatField;
    mdPayPAY_ID: TIntegerField;
    mdAbonentSERVICE_ID: TIntegerField;
    mdAbonentSUB_SRV_ID: TIntegerField;
    mdPayREE_ID: TIntegerField;
    mdPayAGENT: TStringField;
    tbGraph: TTabSheet;
    pnlEGraph: TPanel;
    mdPayUNO: TStringField;
    mdSaldoEXPORT_DATE: TDateField;
    mdPayBALANCE: TFloatField;
    pmAccountStatement: TMenuItem;
    xlAccStatement: TxlReport;
    mdAccStatement: TRxMemoryData;
    mdAccStatementTXT: TStringField;
    mdAccStatementREG_DATE: TDateField;
    mdAccStatementSUMM_PAY: TFloatField;
    mdAccStatementNOTE: TStringField;
    mdAccStatementSUMM_SALDO: TFloatField;
    xlExcel: TxlReport;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcFilterPanelExecute(Sender: TObject);
    procedure AcAddExecute(Sender: TObject);
    procedure AcEditExecute(Sender: TObject);
    procedure AcDeleteExecute(Sender: TObject);
    procedure AcRefreshExecute(Sender: TObject);
    procedure AcToExcel(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridAbonentSortMarkingChanged(Sender: TObject);
    procedure mdAbonentAfterScroll(DataSet: TDataSet);
    procedure GridSaldoSortMarkingChanged(Sender: TObject);
    procedure GridAbonentGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure AcAddSaldoExecute(Sender: TObject);
    procedure AcEditSaldoExecute(Sender: TObject);
    procedure AcDeleteSaldoExecute(Sender: TObject);
    procedure AcRefreshSaldoExecute(Sender: TObject);
    procedure cbVisibleBuhInfoClick(Sender: TObject);
    procedure cbServiceChange(Sender: TObject);
    procedure cbSubSrvChange(Sender: TObject);
    procedure GridAbonentCellClick(Column: TColumnEh);
    procedure mdSaldoAfterScroll(DataSet: TDataSet);
    procedure GridPaySortMarkingChanged(Sender: TObject);
    procedure pmAccountStatementClick(Sender: TObject);
    procedure pmAbonentPopup(Sender: TObject);
  private
    fChildInfo: PChildInfo;
    fGetAbonentList: boolean;
    fGetBuhInfo: boolean;
    fIsAccCloseVisible: boolean;
    //��������� ��� ������������ ������������� ������
    fEGraph: TEasyGraph;
    fHintList: TStringList;
    procedure SetServiceList(cb: TDBComboBoxEh);
    procedure SetSubSrvList(cb: TDBComboBoxEh);
    procedure SetCityList(cb: TDBComboBoxEh);
    procedure SetEnableAbonentEditor;
    procedure SetEnableSaldoEditor;
    procedure LoadFromIni;
    procedure SaveToIni;
    //��������� ����� ����� �� �����������
    function GetSaldoSumm: double;
    //��������� ������ ���������
    procedure GetAbonentList;
    //��������� ������ ���������� � ��������
    procedure GetBuhInfo;
    //������ � ����� (��������)
    function QueryFromOracleAbonent: boolean;
    //����������� ������ �� ��������� ������� (��������)
    procedure CopyToMemoryDataAbonent;
    //������ � ����� (����������)
    function QueryFromOracleSaldo: boolean;
    //����������� ������ �� ��������� ������� (����������)
    procedure CopyToMemoryDataSaldo;
    //������ � ����� (�������)
    function QueryFromOraclePay: boolean;
    //����������� ������ �� ��������� ������� (�������)
    procedure CopyToMemoryDataPay;
    procedure OnMouseHint(Sender: TObject; id: Integer);
    //�������������� ���������
    procedure RedrawDiag(eg: TEasyGraph);
  public
    //������� ���������� ����� �� �������
    procedure Print;
  end;

var
  frmAbonent: TfrmAbonent;

implementation

uses
	dmAbonents,
        fMain,
        fAbonentEd,
        fSaldoEd,
        fAbonentPrint,
        fProgress,
        uCommon;

{$R *.dfm}

procedure TfrmAbonent.FormCreate(Sender: TObject);
begin
	//c�������� ��� ������������ �� ������� �����
	NewChildInfo(fChildInfo, self);
        fChildInfo.Actions[childFilterPanel] := AcFilterPanelExecute;
        fChildInfo.Actions[childAdd]         := AcAddExecute;
        fChildInfo.Actions[childEdit]        := AcEditExecute;
        fChildInfo.Actions[childDelete]      := AcDeleteExecute;
	fChildInfo.Actions[childRefresh]     := AcRefreshExecute;
        fChildInfo.Actions[childToExcel]     := AcToExcel;
        fChildInfo.abAdd     := true;
        fChildInfo.abRefresh := true;

        PageControl.ActivePage := tsSaldo;
        mdAbonent.Active       := true;
        mdSaldo.Active         := true;
        mdPay.Active           := true;
        mdAccStatement.Active  := true;
        fGetAbonentList        := false;

        //������������ ������������� ������
        fHintList := TStringList.Create;
	fEGraph := TEasyGraph.Create(pnlEGraph);
	fEGraph.OnMouseHint := OnMouseHint;
	fEGraph.Align := alClient;
	pnlEGraph.InsertControl(fEGraph);
	fEGraph.HelpContext := 0; //������ ��� ��� ��������� ������������ ������ ������ ����
	HelpContext := 5380;

        SetServiceList(cbService);
        //SetSubSrvList ���������� � LoadFromIni
        SetCityList(cbCity);
        LoadFromIni;

        pnlFilter.Visible        := fChildInfo.abFilterPanelOn;
	SplitterVertical.Visible := fChildInfo.abFilterPanelOn;

        //TODO: ��������� "cbVisibleSubSrvClick" �� ������������ ��� �������� �����
        pnlBuhInfo.Visible         := cbVisibleBuhInfo.Checked;
        SplitterHorizontal.Visible := cbVisibleBuhInfo.Checked;

        fGetAbonentList := true;
end;

procedure TfrmAbonent.FormShow(Sender: TObject);
begin
	GetAbonentList;
end;

procedure TfrmAbonent.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;

        fEGraph.Free;
	fEGraph := nil;
	fHintList.Free;

	mdAbonent.Active      := false;
        mdSaldo.Active        := false;
        mdPay.Active          := false;
        mdAccStatement.Active := false;
        
	Action := caFree;
end;

//������� ������ �����
procedure TfrmAbonent.SetServiceList(cb: TDBComboBoxEh);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT SERVICE_ID, NAME'
	+ ' FROM SERVICES'
        + ' WHERE VISIBLE = 1'
        + ' AND "TYPE" = ''MAIN''' //������������ ������ �������� ������
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������ �����.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[��� ������]');
        cb.KeyItems.Add('[��� ������]');

        //���������� ����� = 0
        {if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
        	WarningBox('�� ������� �� ���� �������� ������ ��� �����������.' + #13 +
                '���� ���������� "������" ����� ����������.' + #13 + #13 +
		'�������� ������(�) � ����������� �����.');
                cb.Enabled := false;
           	DataMod.IB_Cursor.Close;
                exit;
        end;}

        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('SERVICE_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//������� ������ ��������
procedure TfrmAbonent.SetSubSrvList(cb: TDBComboBoxEh);
begin
	cb.Items.Clear;
        cb.Enabled := false;

	//������� [��� ������]
	if (cbService.ItemIndex = 0) then
        begin
                cb.Items.Add('�������� ������');
                cb.KeyItems.Add('�������� ������');
                cb.ItemIndex := 0;
		exit;
        end;

        DataMod.IB_Cursor.SQL.Text := 'SELECT SUBSRV_ID, NAME'
        + ' FROM SUBSRV'
	+ ' WHERE SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]
	+ ' ORDER BY NAME';
        
        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������ ��������.');
                exit;
	end;

	//� ������ ��� ��������
        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
        	cb.Items.Add('��� ��������');
                cb.KeyItems.Add('��� ��������');
                cb.ItemIndex := 0;
        	cb.Enabled := false;
           	DataMod.IB_Cursor.Close;
                exit;
        end;

        cb.Enabled := true;
        cb.Items.Add('[��� ���������]');
        cb.KeyItems.Add('[��� ���������]');

        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('SUBSRV_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        cb.ItemIndex := 0;
        DataMod.IB_Cursor.Close;
end;

//������� ������ �������
procedure TfrmAbonent.SetCityList(cb: TDBComboBoxEh);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT CITY_ID, NAME'
	+ ' FROM CITY_LIST'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������ �������.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[��� ������]');
        cb.KeyItems.Add('[��� ������]');

        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('CITY_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//����������� �������������� ������� ������� ���������
procedure TfrmAbonent.SetEnableAbonentEditor;
begin
    	//�������������� � �������� �� ��������
	if ((mdAbonent.IsEmpty) or (mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1)) then
        begin
        	fChildInfo.abEdit   := false;
        	fChildInfo.abDelete := false;
        end

        //�������������� ��������
        //�������� ��������, ���� ��� ���������� ��� ��������
        else
        begin
        	fChildInfo.abEdit   := true;
                fChildInfo.abDelete := mdSaldo.IsEmpty and mdPay.IsEmpty;
        end;
end;

//����������� �������������� ������� ������� ����������
procedure TfrmAbonent.SetEnableSaldoEditor;
begin
	btnAdd.Enabled         := not mdAbonent.IsEmpty and not ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1));
        btnEdit.Enabled        := not mdSaldo.IsEmpty   and not (mdSaldo.FieldByName('IS_EXPORT').AsInteger = 1)      and not ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1));
        btnDelete.Enabled      := not mdSaldo.IsEmpty   and not (mdSaldo.FieldByName('IS_EXPORT').AsInteger = 1)      and not ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1));
        btnRefresh.Enabled     := not mdAbonent.IsEmpty and not ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1));

        pmSaldoAdd.Enabled     := not mdAbonent.IsEmpty and not ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1));
        pmSaldoEdit.Enabled    := not mdSaldo.IsEmpty   and not (mdSaldo.FieldByName('IS_EXPORT').AsInteger = 1)      and not ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1));
        pmSaldoDelete.Enabled  := not mdSaldo.IsEmpty   and not (mdSaldo.FieldByName('IS_EXPORT').AsInteger = 1)      and not ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1));
        pmSaldoRefresh.Enabled := not mdAbonent.IsEmpty and not ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1));
end;

//��������� ������ ���������� � ��������
procedure TfrmAbonent.GetBuhInfo;
begin
	//������
        if (QueryFromOracleSaldo) then
	        CopyToMemoryDataSaldo;

        //����������
        if (QueryFromOraclePay) then
	        CopyToMemoryDataPay;

	//���������
        try
	        RedrawDiag(fEGraph);
        except
              	Hint := '�� ������� ������� ��������� ���������� � ��������';
        end;

        SetEnableAbonentEditor;
        SetEnableSaldoEditor;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//�������� ���������� �� ini-�����
procedure TfrmAbonent.LoadFromIni;
var
	sect: string;
        i: integer;
begin
	sect := 'Abonent';
	fChildInfo.abFilterPanelOn := OptionsIni.ReadBool(sect, 'FilterPanelOn', true);
	pnlFilter.Width            := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 160);
        pnlBuhInfo.Height          := OptionsIni.ReadInteger(sect, 'pnlBuhInfoHeight', 200);

        cbService.Text             := OptionsIni.ReadString(sect, 'Service', '[��� ������]');
        if (cbService.Text = '') then
         	cbService.ItemIndex := 0;

        SetSubSrvList(cbSubSrv);

        cbSubSrv.Text              := OptionsIni.ReadString(sect, 'SubSrv', '[��� ���������]');
        if (cbSubSrv.Text = '') then
         	cbSubSrv.ItemIndex := 0;

        edFIO.Text                 := OptionsIni.ReadString(sect, 'FIO', '');

        cbCity.Text                := OptionsIni.ReadString(sect, 'City', '[��� ������]');
        if (cbCity.Text = '') then
         	cbCity.ItemIndex := 0;

        edStreet.Text              := OptionsIni.ReadString(sect, 'Street', '');
        cbVisibleBuhInfo.Checked   := OptionsIni.ReadBool(sect, 'VisibleBuhInfo', false);

        sect := 'Options';
        fIsAccCloseVisible         := OptionsIni.ReadBool(sect, 'VisibleAccClose', false);

        //�� ������ ���� ������� ������������� �������
        for i := 0 to GridAbonent.Columns.Count - 1 do
        	if (GridAbonent.Columns.Items[i].FieldName = 'CLOSE_TIME') then
        		GridAbonent.Columns.Items[i].Visible := fIsAccCloseVisible;
end;

//���������� ���������� � ini-����
procedure TfrmAbonent.SaveToIni;
var
	sect: string;
begin
	sect := 'Abonent';
	OptionsIni.WriteBool(sect, 'FilterPanelOn', fChildInfo.abFilterPanelOn);
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteInteger(sect, 'pnlBuhInfoHeight', pnlBuhInfo.Height);
	OptionsIni.WriteString(sect, 'Service', cbService.Text);
        OptionsIni.WriteString(sect, 'SubSrv', cbSubSrv.Text);
        OptionsIni.WriteString(sect, 'FIO', edFIO.Text);
        OptionsIni.WriteString(sect, 'City', cbCity.Text);
        OptionsIni.WriteString(sect, 'Street', edStreet.Text);
        OptionsIni.WriteBool(sect, 'VisibleBuhInfo', cbVisibleBuhInfo.Checked);
end;

//������ ����������
procedure TfrmAbonent.AcFilterPanelExecute(Sender: TObject);
begin
        fChildInfo.abFilterPanelOn := not fChildInfo.abFilterPanelOn;
	SplitterVertical.Visible   := fChildInfo.abFilterPanelOn;
	pnlFilter.Visible 	   := fChildInfo.abFilterPanelOn;
end;

//------------------------------------------------------------------------------
//
//	���������� �������� (��������)
//
//------------------------------------------------------------------------------

//�������� ������
procedure TfrmAbonent.AcAddExecute(Sender: TObject);
var
	i: word;
	AbonentEd: TfrmAbonentEd;
begin
	AbonentEd := TfrmAbonentEd.Create(Application);
	if AbonentEd = nil then
		exit;

	fGetBuhInfo := false;

	AbonentEd.AddAbonent(dsAbonent);
	AbonentEd.Free;

        fGetBuhInfo := true;

        GetBuhInfo;

        for i := 0 to GridAbonent.Columns.Count - 1 do
                if (GridAbonent.Columns.Items[i].FieldName = 'IS_ACC_LOCK') then
                 	GridAbonent.Columns[i].Footer.Value := IntToStr(mdAbonent.RecordCount);
end;

//������������� ������
procedure TfrmAbonent.AcEditExecute(Sender: TObject);
var
	AbonentEd: TfrmAbonentEd;
        rec_no, result: word;
        service,
        city,
        street,
        fio,
        building,
        apartment,
        acc_pu: string;
begin
	//�������������� ����������
	if ((mdAbonent.IsEmpty) or (mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1)) then
        	exit;

	AbonentEd := TfrmAbonentEd.Create(Application);
	if AbonentEd = nil then
		exit;

	result := AbonentEd.EditAbonent(dsAbonent);
	AbonentEd.Free;

        //� ������� ��������� ��������� ������� � ����� �� �/� �� ��������� ������,
        //��������� �������������� �� ��� ����� ������ ������� ���������
        if (result > 1) then
        begin
                fGetBuhInfo := false;
         	GridAbonent.DataSource.DataSet.DisableControls;

                rec_no    := mdAbonent.RecNo;
                service   := mdAbonent.FieldByName('SERVICE').AsString;
                city      := mdAbonent.FieldByName('CITY').AsString;
                street    := mdAbonent.FieldByName('STREET').AsString;
                fio       := mdAbonent.FieldByName('FIO').AsString;
                building  := mdAbonent.FieldByName('BUILDING').AsString;
                apartment := mdAbonent.FieldByName('APARTMENT').AsString;
                acc_pu    := mdAbonent.FieldByName('ACC_PU').AsString;

                mdAbonent.First;
                while (not (mdAbonent.Eof)) do
                begin
                	if ((mdAbonent.FieldByName('SERVICE').AsString = service) and(mdAbonent.FieldByName('ACC_PU').AsString = acc_pu)) then
                        begin
                        	mdAbonent.Edit;
                        	mdAbonent.FieldByName('CITY').AsString:=city;
                		mdAbonent.FieldByName('STREET').AsString:=street;
                		mdAbonent.FieldByName('FIO').AsString:=fio;
                		mdAbonent.FieldByName('BUILDING').AsString:=building;
                        	mdAbonent.FieldByName('APARTMENT').AsString:=apartment;
                                mdAbonent.Post;
                        end;

                    	mdAbonent.Next;
                end;
                mdAbonent.RecNo := rec_no;

                GridAbonent.DataSource.DataSet.EnableControls;
                fGetBuhInfo := true;
        end;
end;

//������� ������
procedure TfrmAbonent.AcDeleteExecute(Sender: TObject);
var
	i: word;
begin
        //�������� ����������
	if ((mdAbonent.IsEmpty) or (mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1)) then
        	exit;

        //� �������� ���� ���������� ��� �������
        if (not (mdSaldo.IsEmpty) or not (mdPay.IsEmpty)) then
        	exit;

	//������ ������������� ��������
        if (YesNoBox(format('������� �������� "%s" (ID #%d)?', [mdAbonent.FieldByName('FIO').AsString, mdAbonent.FieldByName('ABONENT_ID').AsInteger])) = IDYES) then
	begin
          	//��������
        	DataMod.IB_Cursor.SQL.Text := 'DELETE FROM ABONENTS WHERE ABONENT_ID = ' + mdAbonent.FieldByName('ABONENT_ID').AsString;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	ErrorBox('�� ������� ������� ������ �������.' + #13 +
                	'��������, ��������� ������� ������������ � ������ ��������.' + #313 +
                        '���� � ���������� �������� ���������� ����������, �� ������� ��� ����������.');
                	exit;
		end;

                DataMod.IB_Cursor.Close;
	        DataMod.IB_Transaction.Commit;

                mdAbonent.Delete;

        	for i := 0 to GridAbonent.Columns.Count - 1 do
                	if (GridAbonent.Columns.Items[i].FieldName = 'IS_ACC_LOCK') then
                 		GridAbonent.Columns[i].Footer.Value := IntToStr(mdAbonent.RecordCount);
        end;
end;

//�������� ������
procedure TfrmAbonent.AcRefreshExecute(Sender: TObject);
var
	i: word;
	sect: String;
begin
	//SetServiceList(cbType);
        //LoadFromIni;

        for i := 0 to GridAbonent.Columns.Count - 1 do
        	GridAbonent.Columns[i].Title.SortMarker := smNoneEh;

        for i := 0 to GridSaldo.Columns.Count - 1 do
        	GridSaldo.Columns[i].Title.SortMarker := smNoneEh;

        sect := 'Options';
        fIsAccCloseVisible := OptionsIni.ReadBool(sect, 'VisibleAccClose', false);

        //�� ������ ���� ������� ������������� �������
        for i := 0 to GridAbonent.Columns.Count - 1 do
        	if (GridAbonent.Columns.Items[i].FieldName = 'CLOSE_TIME') then
        		GridAbonent.Columns.Items[i].Visible := fIsAccCloseVisible;

	GetAbonentList;
        
end;

//�������������� � Excel
procedure TfrmAbonent.AcToExcel(Sender: TObject);
begin
        ProgressReport(xlExcel);
end;
//------------------------------------------------------------------------------
//TODO: ��� ����� � ���������� ������� � �������� �������������� �������
//��������� ����� ����� �� �����������
function TfrmAbonent.GetSaldoSumm: double;
var
	rec_no: integer;
        summ: double;
begin
        rec_no := mdSaldo.RecNo;
        summ   := 0;

        GridSaldo.DataSource.DataSet.DisableControls;
        mdSaldo.First;

        while (not (mdSaldo.Eof)) do
        begin
                summ := summ + mdSaldo.FieldByName('SUMM').AsFloat;
        	mdSaldo.Next;
        end;

        mdSaldo.RecNo := rec_no;
        GridSaldo.DataSource.DataSet.EnableControls;

        result := summ;
end;

//------------------------------------------------------------------------------
//
//	���������� �������� (����������)
//
//------------------------------------------------------------------------------

//�������� ������
procedure TfrmAbonent.AcAddSaldoExecute(Sender: TObject);
var
	i: word;
        rec_no: integer;
	SaldoEd: TfrmSaldoEd;
begin
	//���������� ����������
        if ((mdAbonent.IsEmpty) or (mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1)) then
        	exit;

        //��������, ��� ��������� ���������� ����������
        rec_no := mdSaldo.RecNo;
        mdSaldo.Last;
        if ((not mdSaldo.IsEmpty) and (mdSaldo.FieldByName('IS_EXPORT').AsInteger = 0)) then
        begin
                WarningBox(format('��������� ����������%s�� ������ %s - %s%s�� %f ���. (ID #%d)%s�� ���������.', [#13, mdSaldo.FieldByName('PERIOD_BEGIN').AsString, mdSaldo.FieldByName('PERIOD_END').AsString, #13, mdSaldo.FieldByName('SUMM').AsFloat, mdSaldo.FieldByName('SALDO_ID').AsInteger, #13]));
                exit;
        end;
	mdSaldo.RecNo := rec_no;

	SaldoEd := TfrmSaldoEd.Create(Application);
	if SaldoEd = nil then
		exit;

	SaldoEd.AddSaldo(dsSaldo, mdAbonent.FieldByName('ABONENT_ID').AsInteger);
	SaldoEd.Free;

        SetEnableAbonentEditor;
        SetEnableSaldoEditor;

        for i := 0 to GridSaldo.Columns.Count - 1 do
        begin
                if (GridSaldo.Columns.Items[i].FieldName = 'SALDO_ID') then
                 	GridSaldo.Columns[i].Footer.Value := IntToStr(mdSaldo.RecordCount);

                if (GridSaldo.Columns.Items[i].FieldName = 'SUMM') then
                 	GridSaldo.Columns[i].Footer.Value := format('%f ���.', [GetSaldoSumm]);
        end;

        tsSaldo.Caption := format('����������: %d', [mdSaldo.RecordCount]);
end;

//������������� ������
procedure TfrmAbonent.AcEditSaldoExecute(Sender: TObject);
var
        i: word;
	SaldoEd: TfrmSaldoEd;
begin
	//�������������� ����������
        if ((mdSaldo.IsEmpty) or (mdSaldo.FieldByName('IS_EXPORT').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1)) then
        	exit;

	SaldoEd := TfrmSaldoEd.Create(Application);
	if SaldoEd = nil then
		exit;

	SaldoEd.EditSaldo(dsSaldo, mdAbonent.FieldByName('ABONENT_ID').AsInteger);
	SaldoEd.Free;

        for i := 0 to GridSaldo.Columns.Count - 1 do
                if (GridSaldo.Columns.Items[i].FieldName = 'SUMM') then
                 	GridSaldo.Columns[i].Footer.Value := format('%f ���.', [GetSaldoSumm]);
end;

//������� ������
procedure TfrmAbonent.AcDeleteSaldoExecute(Sender: TObject);
var
	i: word;
begin
	//�������� ����������
        if ((mdSaldo.IsEmpty) or (mdSaldo.FieldByName('IS_EXPORT').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1)) then
        	exit;

	//������ ������������� ��������
        if (YesNoBox(format('������� ���������� "%f ���." (ID #%d)?', [mdSaldo.FieldByName('SUMM').AsFloat, mdSaldo.FieldByName('SALDO_ID').AsInteger])) = IDYES) then
	begin
          	//��������
        	DataMod.IB_Cursor.SQL.Text := 'DELETE FROM SALDO WHERE SALDO_ID = ' + mdSaldo.FieldByName('SALDO_ID').AsString;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	ErrorBox('�� ������� ������� ������ �������.' + #13 +
                	'��������, ��������� ���������� ������������ � ������ ��������.');
                	exit;
		end;

                DataMod.IB_Cursor.Close;
	        DataMod.IB_Transaction.Commit;

                mdSaldo.Delete;

                SetEnableAbonentEditor;
                SetEnableSaldoEditor;

        	for i := 0 to GridSaldo.Columns.Count - 1 do
        	begin
                	if (GridSaldo.Columns.Items[i].FieldName = 'SALDO_ID') then
                 		GridSaldo.Columns[i].Footer.Value := IntToStr(mdSaldo.RecordCount);

                	if (GridSaldo.Columns.Items[i].FieldName = 'SUMM') then
                 		GridSaldo.Columns[i].Footer.Value := format('%f ���.', [GetSaldoSumm]);
        	end;

                tsSaldo.Caption := format('����������: %d', [mdSaldo.RecordCount]);
        end;
end;

//�������� ������
procedure TfrmAbonent.AcRefreshSaldoExecute(Sender: TObject);
var
	i: word;
begin
	//���������� ����������
        if ((mdAbonent.IsEmpty) or (mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) or (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1)) then
        	exit;

        for i := 0 to GridSaldo.Columns.Count - 1 do
        	GridSaldo.Columns[i].Title.SortMarker := smNoneEh;

	GetBuhInfo;
end;

//------------------------------------------------------------------------------
//��������� ������ ���������
procedure TfrmAbonent.GetAbonentList;
begin
	//MsgBox('GetAbonentList');

        //��������� ����� GetBuhInfo ��� ������������ ������ ���������
        fGetBuhInfo := false;

        if (QueryFromOracleAbonent) then
	        CopyToMemoryDataAbonent;

        fGetBuhInfo := true;
        GetBuhInfo;
end;

//������ � ����� (��������)
function TfrmAbonent.QueryFromOracleAbonent: boolean;
begin
	result := false;

        DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Add('SELECT A.ABONENT_ID'
        	+ ', A.SERVICE_ID'
                + ', A.SUBSRV_ID'
     		+ ', SE.NAME AS SERVICE'
       		+ ', SU.NAME AS SUB_SRV'
     		+ ', C.NAME  AS CITY'
     		+ ', ST.NAME AS STREET'
     		+ ', A.FIO'
     		+ ', A.BUILDING'
     		+ ', A.APARTMENT'
     		+ ', A.ACC_PU'
     		+ ', A.OPEN_TIME'
     		+ ', A.CLOSE_TIME'
     		+ ', A.IS_ACC_LOCK'
     		+ ', A.IS_ACC_CLOSE'
     		+ ', A.BALANCE'
	+ ' FROM ABONENTS A'
	+ ' INNER JOIN SERVICES SE    ON A.SERVICE_ID = SE.SERVICE_ID'
	+ ' LEFT  JOIN SUBSRV SU      ON A.SUBSRV_ID  = SU.SUBSRV_ID'
        + ' LEFT  JOIN CITY_LIST C    ON A.CITY_ID    = C.CITY_ID'
	+ ' LEFT  JOIN STREET_LIST ST ON A.STREET_ID  = ST.STREET_ID'
        //����������� ������
        + ' WHERE A.ABONENT_ID IS NOT NULL');

        //������� ������
        if (cbService.ItemIndex <> 0) then
                DataMod.IB_Cursor.SQL.Add(' AND A.SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]);

        //������� ���������
        if (cbSubSrv.ItemIndex <> 0) then
	        DataMod.IB_Cursor.SQL.Add(' AND A.SUBSRV_ID = ' + cbSubSrv.KeyItems.Strings[cbSubSrv.ItemIndex]);

        //������ ������ ��� ��������
        if (edFIO.Text <> '') then
        	DataMod.IB_Cursor.SQL.Add(' AND UPPER(A.FIO) LIKE UPPER(''%' + edFIO.Text + '%'')');

        //������ �����
        if (cbCity.ItemIndex <> 0) then
                DataMod.IB_Cursor.SQL.Add(' AND A.CITY_ID = ' + cbCity.KeyItems.Strings[cbCity.ItemIndex]);

        //������ ������ �������� �����
        if (edStreet.Text <> '') then
        	DataMod.IB_Cursor.SQL.Add(' AND UPPER(ST.NAME) LIKE UPPER(''%' + edStreet.Text + '%'')');

	DataMod.IB_Cursor.SQL.Add(' ORDER BY A.IS_ACC_CLOSE, SE.NAME, A.ACC_PU, SU.NAME');
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������� ���������.');
                exit;
	end;

        result := true;
end;

//����������� ������ �� ��������� ������� (��������)
procedure TfrmAbonent.CopyToMemoryDataAbonent;
var
        i, record_count,
        sub_srv_count,
        acc_close,
        step: integer;
        balance: double;
begin
	GridAbonent.DataSource.DataSet.DisableControls;

   	mdAbonent.EmptyTable;
        acc_close     := 0;
        record_count  := 0;
        sub_srv_count := 0;
        step          := 1000;
        balance       := 0;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	//���� � ���������� ������ �� ���������� ��������� � ��������� �/�, �� ����� ��������� �� ���������� � Grid
        	if ((DataMod.IB_Cursor.FieldByName('IS_ACC_LOCK').AsInteger = 1) and (DataMod.IB_Cursor.FieldByName('IS_ACC_CLOSE').AsInteger = 1)) then
                begin
                	inc(acc_close);
                	if (not (fIsAccCloseVisible)) then
                        begin
                		DataMod.IB_Cursor.Next;
                		continue;
                        end;
                end;

        	//TODO: �� ������������ ����:
                //SUB_SRV, FIO, CITY, BUILDING, APARTMENT, CLOSE_TIME
        	mdAbonent.Append;
                mdAbonent.FieldByName('ABONENT_ID').AsInteger := DataMod.IB_Cursor.FieldByName('ABONENT_ID').AsInteger;
                mdAbonent.FieldByName('SERVICE_ID').AsInteger := DataMod.IB_Cursor.FieldByName('SERVICE_ID').AsInteger;

                if (DataMod.IB_Cursor.FieldByName('SUBSRV_ID').IsNotNull) then
                	mdAbonent.FieldByName('SUBSRV_ID').AsInteger := DataMod.IB_Cursor.FieldByName('SUBSRV_ID').AsInteger;

                mdAbonent.FieldByName('SERVICE').AsString := DataMod.IB_Cursor.FieldByName('SERVICE').AsString;

                if (DataMod.IB_Cursor.FieldByName('SUB_SRV').IsNotNull) then
                begin
                	mdAbonent.FieldByName('SUB_SRV').AsString := DataMod.IB_Cursor.FieldByName('SUB_SRV').AsString;
                        inc(sub_srv_count);
                end;

                if (DataMod.IB_Cursor.FieldByName('FIO').IsNotNull) then
                	mdAbonent.FieldByName('FIO').AsString := DataMod.IB_Cursor.FieldByName('FIO').AsString;

                if (DataMod.IB_Cursor.FieldByName('CITY').IsNotNull) then
                	mdAbonent.FieldByName('CITY').AsString := DataMod.IB_Cursor.FieldByName('CITY').AsString;

                mdAbonent.FieldByName('STREET').AsString := DataMod.IB_Cursor.FieldByName('STREET').AsString;

                if (DataMod.IB_Cursor.FieldByName('BUILDING').IsNotNull) then
                	mdAbonent.FieldByName('BUILDING').AsString := DataMod.IB_Cursor.FieldByName('BUILDING').AsString;

                if (DataMod.IB_Cursor.FieldByName('APARTMENT').IsNotNull) then
                	mdAbonent.FieldByName('APARTMENT').AsString := DataMod.IB_Cursor.FieldByName('APARTMENT').AsString;

                mdAbonent.FieldByName('ACC_PU').AsString      := DataMod.IB_Cursor.FieldByName('ACC_PU').AsString;
                mdAbonent.FieldByName('OPEN_TIME').AsDateTime := DataMod.IB_Cursor.FieldByName('OPEN_TIME').AsDateTime;

                if (DataMod.IB_Cursor.FieldByName('CLOSE_TIME').IsNotNull) then
                	mdAbonent.FieldByName('CLOSE_TIME').AsDateTime := DataMod.IB_Cursor.FieldByName('CLOSE_TIME').AsDateTime;
                mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger  := DataMod.IB_Cursor.FieldByName('IS_ACC_LOCK').AsInteger;
                mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger := DataMod.IB_Cursor.FieldByName('IS_ACC_CLOSE').AsInteger;
                mdAbonent.FieldByName('BALANCE').AsFloat        := DataMod.IB_Cursor.FieldByName('BALANCE').AsFloat;
                mdAbonent.Post;
                DataMod.IB_Cursor.Next;

                if (record_count = step) then
                begin
                	frmMain.StatusBar.Panels[0].Text := format('���������: %d �������', [record_count]);
                        frmMain.StatusBar.Refresh;
                    	step := step + 1000;
                end;

                inc(record_count);
                balance := balance + mdAbonent.FieldByName('BALANCE').AsFloat;
        end;
        DataMod.IB_Cursor.Close;
        mdAbonent.First;
        frmMain.StatusBar.Panels[0].Text := '';

        //�� ������ ���� ������� ������������� �������
        for i := 0 to GridAbonent.Columns.Count - 1 do
        begin
        	if (GridAbonent.Columns.Items[i].FieldName = 'IS_ACC_LOCK') then
                	GridAbonent.Columns[i].Footer.Value := IntToStr(record_count);
                if (GridAbonent.Columns.Items[i].FieldName = 'SERVICE') then
        		GridAbonent.Columns[i].Footer.Value := format('%d �������� ������� ������',[acc_close]);
        	if (GridAbonent.Columns.Items[i].FieldName = 'SUB_SRV') then
        		GridAbonent.Columns.Items[i].Visible := sub_srv_count > 0;
                if (GridAbonent.Columns.Items[i].FieldName = 'BALANCE') then
        		GridAbonent.Columns.Items[i].Footer.Value := format('%f ���.', [balance]);
        end;

        GridAbonent.DataSource.DataSet.EnableControls;
end;

//������ � ����� (����������)
function TfrmAbonent.QueryFromOracleSaldo: boolean;
var i: word;
begin
	result := false;

        //������ ��������� ����
        if (mdAbonent.IsEmpty) then
        begin
                mdSaldo.EmptyTable;
                for i := 0 to GridSaldo.Columns.Count - 1 do
                begin
                	if (GridSaldo.Columns.Items[i].FieldName = 'IS_EXPORT') then
                 		GridSaldo.Columns[i].Footer.Value := '0';
                	if (GridSaldo.Columns.Items[i].FieldName = 'SUMM') then
        			GridSaldo.Columns.Items[i].Footer.Value := format('%f ���.', [0.00]);
                end;

                tsSaldo.Caption := '����������: 0';

        	exit;
        end;

        DataMod.IB_Cursor.SQL.Text := 'SELECT SALDO_ID'
        	+ ', PERIOD_BEGIN'
        	+ ', PERIOD_END'
                + ', SUMM'
                + ', IS_EXPORT'
                + ', EXPORT_DATE'
        + ' FROM SALDO'
        + ' WHERE ABONENT_ID = ' + mdAbonent.FieldByName('ABONENT_ID').AsString
        + ' ORDER BY SALDO_ID';
        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������� ����������.');
                exit;
	end;

        result := true;
end;

//����������� ������ �� ��������� ������� (����������)
procedure TfrmAbonent.CopyToMemoryDataSaldo;
var
	i, record_count: integer;
        summ: double;
begin
	GridSaldo.DataSource.DataSet.DisableControls;

   	mdSaldo.EmptyTable;
        record_count := 0;
        summ         := 0;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdSaldo.Append;
                mdSaldo.FieldByName('SALDO_ID').AsInteger      := DataMod.IB_Cursor.FieldByName('SALDO_ID').AsInteger;
                mdSaldo.FieldByName('PERIOD_BEGIN').AsDateTime := DataMod.IB_Cursor.FieldByName('PERIOD_BEGIN').AsDateTime;
                mdSaldo.FieldByName('PERIOD_END').AsDateTime   := DataMod.IB_Cursor.FieldByName('PERIOD_END').AsDateTime;
                mdSaldo.FieldByName('SUMM').AsFloat            := DataMod.IB_Cursor.FieldByName('SUMM').AsFloat;
                mdSaldo.FieldByName('IS_EXPORT').AsInteger     := DataMod.IB_Cursor.FieldByName('IS_EXPORT').AsInteger;
                mdSaldo.FieldByName('EXPORT_DATE').AsDateTime  := DataMod.IB_Cursor.FieldByName('EXPORT_DATE').AsDateTime;
                mdSaldo.Post;
                DataMod.IB_Cursor.Next;
                inc(record_count);
                summ := summ + mdSaldo.FieldByName('SUMM').AsFloat;
        end;
        DataMod.IB_Cursor.Close;
        mdSaldo.First;

        //�� ������ ���� ������� ������������� �������
        for i := 0 to GridSaldo.Columns.Count - 1 do
        begin
                if (GridSaldo.Columns.Items[i].FieldName = 'SALDO_ID') then
                 	GridSaldo.Columns[i].Footer.Value := IntToStr(record_count);
                if (GridSaldo.Columns.Items[i].FieldName = 'SUMM') then
        		GridSaldo.Columns.Items[i].Footer.Value := format('%f ���.', [summ]);
        end;

        tsSaldo.Caption := format('����������: %d', [record_count]);

        GridSaldo.DataSource.DataSet.EnableControls;
end;

//������ � ����� (�������)
function TfrmAbonent.QueryFromOraclePay: boolean;
var
	acc_pu: string;
        i, service_id,
        subsrv_id: integer;
begin
	result := false;

        //������ ��������� ����
        if (mdAbonent.IsEmpty) then
        begin
        	mdPay.EmptyTable;

                for i := 0 to GridPay.Columns.Count - 1 do
                begin
                	if (GridPay.Columns.Items[i].FieldName = 'PAY_ID') then
                 		GridPay.Columns[i].Footer.Value := '0';
                        if (GridPay.Columns.Items[i].FieldName = 'SUMM') then
        			GridPay.Columns.Items[i].Footer.Value := format('%f ���.', [0.00]);
                end;

                tsPay.Caption := '�������: 0';

        	exit;
        end;

        acc_pu     := mdAbonent.FieldByName('ACC_PU').AsString;
        service_id := mdAbonent.FieldByName('SERVICE_ID').AsInteger;

        subsrv_id  := 0;
        //� ������ ���� ���������
        if (mdAbonent.FieldByName('SUB_SRV').AsString <> '') then
        	subsrv_id := mdAbonent.FieldByName('SUBSRV_ID').AsInteger;

        DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Add('SELECT P.PAY_ID'
        	+ ', P.REE_ID'
        	+ ', P.DATE_PAY'
                + ', P.AGENT_ID'
                + ', A.NAME AS AGENT'
                + ', P.SUMM'
                + ', P.UNO'
                + ', P.BALANCE'
        + ' FROM PAYS P'
        + ' LEFT JOIN AGENT_LIST A ON P.AGENT_ID = A.AGENT_ID'
        + ' WHERE P.ACC_PU   = ''' + acc_pu + ''''
        + ' AND P.SERVICE_ID = ' + IntToStr(service_id));

        if (mdAbonent.FieldByName('SUB_SRV').AsString <> '') then
                DataMod.IB_Cursor.SQL.Add(' AND SUB_SRV_PU = (SELECT SUB_SRV_PU FROM SUBSRV WHERE SUBSRV_ID = ' + IntToStr(subsrv_id) + ')');

        DataMod.IB_Cursor.SQL.Add(' ORDER BY PAY_ID');

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������� ��������.');
                exit;
	end;

        result := true;
end;

//����������� ������ �� ��������� ������� (�������)
procedure TfrmAbonent.CopyToMemoryDataPay;
var
	i, record_count: integer;
        summ: double;
begin
	GridPay.DataSource.DataSet.DisableControls;

   	mdPay.EmptyTable;
        record_count := 0;
        summ         := 0;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdPay.Append;
                mdPay.FieldByName('PAY_ID').AsInteger    := DataMod.IB_Cursor.FieldByName('PAY_ID').AsInteger;
                mdPay.FieldByName('REE_ID').AsInteger    := DataMod.IB_Cursor.FieldByName('REE_ID').AsInteger;
                mdPay.FieldByName('DATE_PAY').AsDateTime := DataMod.IB_Cursor.FieldByName('DATE_PAY').AsDateTime;

                if (DataMod.IB_Cursor.FieldByName('AGENT').IsNotNull) then
                	mdPay.FieldByName('AGENT').AsString := DataMod.IB_Cursor.FieldByName('AGENT').AsString
                else
                        mdPay.FieldByName('AGENT').AsString := '����� #' + DataMod.IB_Cursor.FieldByName('AGENT_ID').AsString;

                mdPay.FieldByName('UNO').AsString        := DataMod.IB_Cursor.FieldByName('UNO').AsString;
                mdPay.FieldByName('SUMM').AsFloat        := DataMod.IB_Cursor.FieldByName('SUMM').AsFloat;
                mdPay.FieldByName('BALANCE').AsFloat     := DataMod.IB_Cursor.FieldByName('BALANCE').AsFloat;
	        mdPay.Post;
                DataMod.IB_Cursor.Next;
                inc(record_count);
                summ := summ + mdPay.FieldByName('SUMM').AsFloat;
        end;
        DataMod.IB_Cursor.Close;
        mdSaldo.First;

        //�� ������ ���� ������� ������������� �������
        for i := 0 to GridPay.Columns.Count - 1 do
        begin
                if (GridPay.Columns.Items[i].FieldName = 'PAY_ID') then
                 	GridPay.Columns[i].Footer.Value := IntToStr(record_count);
                if (GridPay.Columns.Items[i].FieldName = 'SUMM') then
        		GridPay.Columns.Items[i].Footer.Value := format('%f ���.', [summ]);
        end;

        tsPay.Caption := format('�������: %d', [record_count]);

        GridPay.DataSource.DataSet.EnableControls;
end;

procedure TfrmAbonent.pnlFilterResize(Sender: TObject);
begin
	cbService.Width := pnlFilter.Width - 20;
        cbSubSrv.Width  := pnlFilter.Width - 20;
        cbCity.Width    := pnlFilter.Width - 20;
        edStreet.Width  := pnlFilter.Width - 20;
	edFIO.Width     := pnlFilter.Width - 20;
end;

procedure TfrmAbonent.GridAbonentSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridAbonent = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridAbonent.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridAbonent.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridAbonent.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdAbonent.SortOnFields(fields, false, desc);
end;

procedure TfrmAbonent.GridSaldoSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridSaldo = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridSaldo.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridSaldo.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridSaldo.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdSaldo.SortOnFields(fields, false, desc);
end;

procedure TfrmAbonent.GridPaySortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridPay = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridPay.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridPay.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridPay.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdPay.SortOnFields(fields, false, desc);
end;

procedure TfrmAbonent.mdAbonentAfterScroll(DataSet: TDataSet);
var
	i: word;
begin
	if (not (fGetBuhInfo)) then
        	exit;

	for i := 0 to GridSaldo.Columns.Count - 1 do
        	GridSaldo.Columns[i].Title.SortMarker := smNoneEh;

        for i := 0 to GridPay.Columns.Count - 1 do
        	GridPay.Columns[i].Title.SortMarker := smNoneEh;

        GetBuhInfo;
end;

procedure TfrmAbonent.mdSaldoAfterScroll(DataSet: TDataSet);
begin
    	SetEnableSaldoEditor;
end;

procedure TfrmAbonent.cbVisibleBuhInfoClick(Sender: TObject);
begin
	pnlBuhInfo.Visible         := cbVisibleBuhInfo.Checked;
        SplitterHorizontal.Visible := cbVisibleBuhInfo.Checked;
end;

procedure TfrmAbonent.GridAbonentGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 0) and (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 0)) then
		Background := $00FFDDDD
        else if ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) and (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 0)) then
		Background := $00FFC4C4
        else if ((mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 1) and (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1)) then
		Background := $0000FF;
end;

procedure TfrmAbonent.cbServiceChange(Sender: TObject);
begin
	if (fGetAbonentList) then
        begin
        	fGetAbonentList := false;
        	SetSubSrvList(cbSubSrv);
                fGetAbonentList := true;

   		GetAbonentList;
        end;
end;

procedure TfrmAbonent.cbSubSrvChange(Sender: TObject);
begin
   	if (fGetAbonentList) then
   		GetAbonentList;
end;

//TODO: ���� ��� ����������� �������� �/� �������� �� �������� � ����������
procedure TfrmAbonent.GridAbonentCellClick(Column: TColumnEh);
var
	visible: word;
        msg: string;
begin
	if (Column.FieldName <> 'IS_ACC_LOCK') then
        	exit;

        //���� �������� ������
        if (mdAbonent.FieldByName('IS_ACC_CLOSE').AsInteger = 1) then
        	exit;

        if (mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger = 0) then
        	msg := '�������� ������� ���� �������� �� ��������?'
        else
        	msg := '����� ������� �� ��������?';

        if (YesNoBox(msg) = IDNO) then
        	exit;

        visible := 1 - mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger;

        mdAbonent.Edit;
        mdAbonent.FieldByName('IS_ACC_LOCK').AsInteger := visible;
        mdAbonent.Post;

	DataMod.IB_Cursor.SQL.Text := 'UPDATE ABONENTS SET IS_ACC_LOCK = ' + IntToStr(visible)
        + ' WHERE ABONENT_ID = ' + mdAbonent.FieldByName('ABONENT_ID').AsString;
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� �������������� ������� ���������.');
                exit;
	end;

        DataMod.IB_Cursor.Close;
        DataMod.IB_Transaction.Commit;

        SetEnableAbonentEditor;
        SetEnableSaldoEditor;
end;

//������� ���������� ����� �� �������
procedure TfrmAbonent.Print;
var
	frm: TfrmAbonentPrint;
begin
  	frm := TfrmAbonentPrint.Create(self);
        frm.cbCloseTime.Enabled := fIsAccCloseVisible;
        frm.ShowModal;
end;

procedure TfrmAbonent.OnMouseHint(Sender: TObject; id: Integer);
begin
	Hint := fHintList.Strings[id];
end;

//�������������� ���������
procedure TfrmAbonent.RedrawDiag(eg: TEasyGraph);
var
	hint: string;
        hint_id: integer;
begin
	if ((mdSaldo = nil) or (mdPay = nil) or (eg = nil)) then
		exit;

	fHintList.Clear;
	eg.Caption := '��������� ���������� � ��������';

	//���������� ����
	eg.Clear;
	eg.Pits.Add;
	eg.Pits[0].fMinHeight := 100;
	eg.Pits[0].DrawStyle  := dsValues;

	//���������� �������
	eg.Legend.Clear;
	eg.Legend.Add (clSkyBlue, '����������', '');
	eg.Legend.Add (clRed,  '�������', '');

        //������ ����������
        GridSaldo.DataSource.DataSet.DisableControls;
   	mdSaldo.First;
        while (not (mdSaldo.Eof)) do
        begin
        	if (mdSaldo.FieldByName('IS_EXPORT').AsInteger = 1) then
                begin
                	//���������
                	hint    := format('���������� �� ������ %s - %s �� %f ���.', [mdSaldo.FieldByName('PERIOD_BEGIN').AsString, mdSaldo.FieldByName('PERIOD_END').AsString, mdSaldo.FieldByName('SUMM').AsFloat]);
			hint_id := fHintList.Add(hint);

                	eg.Add(0, mdSaldo.FieldByName('PERIOD_BEGIN').AsDateTime, mdSaldo.FieldByName('PERIOD_END').AsDateTime, mdSaldo.FieldByName('SUMM').AsFloat, galValue, clSkyBlue, hint_id);
                end;

                mdSaldo.Next;
        end;
        mdSaldo.First;
        GridSaldo.DataSource.DataSet.EnableControls;

        //������ �������
        GridPay.DataSource.DataSet.DisableControls;
   	mdPay.First;
        while (not (mdPay.Eof)) do
        begin
	        //���������
        	hint    := format('������ ����: %s, ������: %s, �����: %f ���., ���������: %s, �����: %s', [mdPay.FieldByName('DATE_PAY').AsString, mdPay.FieldByName('REE_ID').AsString, mdPay.FieldByName('SUMM').AsFloat, mdPay.FieldByName('UNO').AsString, mdPay.FieldByName('AGENT').AsString]);
		hint_id := fHintList.Add(hint);

                eg.Add(0, mdPay.FieldByName('DATE_PAY').AsDateTime - (1 / 1000), mdPay.FieldByName('DATE_PAY').AsDateTime + (1 / 1000), mdPay.FieldByName('SUMM').AsFloat, galValue, clRed, hint_id);
                mdPay.Next;
        end;
        mdPay.First;
        GridPay.DataSource.DataSet.EnableControls;

        eg.FitToWindow;
end;

//������� �� �����
procedure TfrmAbonent.pmAccountStatementClick(Sender: TObject);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT TXT, REG_DATE, SUMM_SALDO, SUMM_PAY, NOTE FROM ACCOUNT_STATEMENT('
                + '''' + mdAbonent.FieldByName('ACC_PU').AsString + ''','
                + mdAbonent.FieldByName('SERVICE_ID').AsString + ')';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ������������ ������� �� �����.');
                exit;
	end;

        mdAccStatement.EmptyTable;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdAccStatement.Append;
                mdAccStatement.FieldByName('TXT').AsString        := DataMod.IB_Cursor.FieldByName('TXT').AsString;
                mdAccStatement.FieldByName('REG_DATE').AsDateTime := DataMod.IB_Cursor.FieldByName('REG_DATE').AsDateTime;

                if (DataMod.IB_Cursor.FieldByName('SUMM_SALDO').IsNotNull) then
                        mdAccStatement.FieldByName('SUMM_SALDO').AsFloat  := DataMod.IB_Cursor.FieldByName('SUMM_SALDO').AsFloat;

                if (DataMod.IB_Cursor.FieldByName('SUMM_PAY').IsNotNull) then
                        mdAccStatement.FieldByName('SUMM_PAY').AsFloat    := DataMod.IB_Cursor.FieldByName('SUMM_PAY').AsFloat;

                mdAccStatement.FieldByName('NOTE').AsString       := DataMod.IB_Cursor.FieldByName('NOTE').AsString;
	        mdAccStatement.Post;
                DataMod.IB_Cursor.Next;
        end;
        DataMod.IB_Cursor.Close;

        xlAccStatement.Params.Items[0].AsString := mdAbonent.FieldByName('ACC_PU').AsString;
        xlAccStatement.Params.Items[1].AsString := mdAbonent.FieldByName('FIO').AsString;
        xlAccStatement.Params.Items[2].AsFloat  := mdAbonent.FieldByName('BALANCE').AsFloat;
    	ProgressReport(xlAccStatement);
end;

procedure TfrmAbonent.pmAbonentPopup(Sender: TObject);
begin
        if (mdAbonent.IsEmpty) then
                pmAccountStatement.Enabled := false
        else
                pmAccountStatement.Enabled := true;
end;

end.
