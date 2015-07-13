//������
unit fLim;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList;

type
  TfrmLim = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    edOrg: TDBEditEh;
    pnlFilterTop: TPanel;
    mdLim: TRxMemoryData;
    dsLim: TDataSource;
    GridLim: TDBGridEh;
    lblOrg: TLabel;
    mdLimIS_ACTIVE: TStringField;
    mdLimLIM_NAME: TStringField;
    mdLimAGENT_NAME: TStringField;
    mdLimSUBAGENT_NAME: TStringField;
    mdLimDEL_PERIOD: TStringField;
    mdLimLIMIT: TFloatField;
    mdLimVALUE: TFloatField;
    mdLimCOMMISS: TStringField;
    mdLimPOSSIBLE_PAY: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridLimSortMarkingChanged(Sender: TObject);
    procedure edOrgKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridLimGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure RunQuery;
    //������ � �����
    function QueryFromOracle: boolean;
    //����������� ������ �� ��������� �������
    procedure CopyToMemoryData;
  public
    fStartQuery: boolean;
    fColorMode : boolean;
  end;

var
  frmLim: TfrmLim;

implementation

uses
	dmCityNavigator,
        uCommon,
        fProgress;

{$R *.dfm}

procedure TfrmLim.FormCreate(Sender: TObject);
begin
	//c�������� ��� ������������ �� ������� �����
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;

        mdLim.Active := true;
        fStartQuery  := false;

        LoadFromIni;

        fStartQuery := true;
end;

procedure TfrmLim.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmLim.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdLim.Active := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//�������� ���������� �� ini-�����
procedure TfrmLim.LoadFromIni;
var
	sect: String;
begin
	sect := 'Lim';
	pnlFilter.Width := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edOrg.Text      := OptionsIni.ReadString(sect, 'Org', '');

        sect := 'Options';
        fColorMode := OptionsIni.ReadBool(sect, 'UseColorMode', true);
end;

//���������� ���������� � ini-����
procedure TfrmLim.SaveToIni;
var
	sect: String;
begin
	sect := 'Lim';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'Org', edOrg.Text);
end;

//��������
procedure TfrmLim.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridLim.Columns.Count - 1 do
        	GridLim.Columns[i].Title.SortMarker := smNoneEh;
                
	RunQuery;
end;

procedure TfrmLim.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracle) then
	        CopyToMemoryData;
        Screen.Cursor := crDefault;
end;

//������ � �����
function TfrmLim.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Add('SELECT lim.IS_ACTIVE'
     		+ ', lim.NAME AS LIM_NAME'
     		+ ', org2.NAME AS AGENT_NAME'
     		+ ', org.NAME AS SUBAGENT_NAME'
     		+ ', lim.DEL_PERIOD'
     		+ ', lim.LIMIT# AS LIMIT'
     		+ ', lim.VALUE# AS VALUE'
     		+ ', lim.COMMISS'
	+ ' FROM KP.LIM_VALUES lim'
   		+ ', KP.ORGS org'
   		+ ', KP.ORGS org2'
	+ ' WHERE lim.SUBAGENT_ID = org.SUBJ_ID'
		+ ' AND lim.AGENT_ID = org2.SUBJ_ID');

	//������ ������ �������� �����������
        if (edOrg.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(org2.NAME) LIKE UPPER(''%' + edOrg.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY org2.NAME');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //������ �������
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('������ ���������� ������� (fManualLim).'
                + #13 + '��������, � ��� ��� ��������� ���� ��� ������� �������.'
                + #13 + #13 + '���������� � ������������.');
                exit;
	end;

        result := true;
end;

//����������� ������ �� ��������� �������
procedure TfrmLim.CopyToMemoryData;
var
	record_count: integer;
begin
	GridLim.DataSource.DataSet.DisableControls;

   	mdLim.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdLim.Append;
                mdLim.FieldByName('IS_ACTIVE').AsString     := DataMod.OracleDataSet.FieldByName('IS_ACTIVE').AsString;
                mdLim.FieldByName('LIM_NAME').AsString      := DataMod.OracleDataSet.FieldByName('LIM_NAME').AsString;
                mdLim.FieldByName('AGENT_NAME').AsString    := DataMod.OracleDataSet.FieldByName('AGENT_NAME').AsString;
                mdLim.FieldByName('SUBAGENT_NAME').AsString := DataMod.OracleDataSet.FieldByName('SUBAGENT_NAME').AsString;

                if (DataMod.OracleDataSet.FieldByName('DEL_PERIOD').AsString = 'P') then
                	mdLim.FieldByName('DEL_PERIOD').AsString := '�������'
                else if (DataMod.OracleDataSet.FieldByName('DEL_PERIOD').AsString = 'D') then
                	mdLim.FieldByName('DEL_PERIOD').AsString := '����'
                else if (DataMod.OracleDataSet.FieldByName('DEL_PERIOD').AsString = 'W') then
                	mdLim.FieldByName('DEL_PERIOD').AsString := '������'
                else if (DataMod.OracleDataSet.FieldByName('DEL_PERIOD').AsString = 'M') then
                	mdLim.FieldByName('DEL_PERIOD').AsString := '�����'
                else if (DataMod.OracleDataSet.FieldByName('DEL_PERIOD').AsString = 'Q') then
                	mdLim.FieldByName('DEL_PERIOD').AsString := '�������';

                mdLim.FieldByName('LIMIT').AsFloat          := DataMod.OracleDataSet.FieldByName('LIMIT').AsFloat;
                mdLim.FieldByName('VALUE').AsFloat          := DataMod.OracleDataSet.FieldByName('VALUE').AsFloat;
                mdLim.FieldByName('COMMISS').AsString       := DataMod.OracleDataSet.FieldByName('COMMISS').AsString;

                //����������� ����
                mdLim.FieldByName('POSSIBLE_PAY').AsFloat := mdLim.FieldByName('LIMIT').AsFloat - mdLim.FieldByName('VALUE').AsFloat;

                mdLim.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdLim.First;
        GridLim.Columns[0].Footer.Value := IntToStr(record_count);
        GridLim.DataSource.DataSet.EnableControls;
end;

procedure TfrmLim.pnlFilterResize(Sender: TObject);
begin
	edOrg.Width := pnlFilter.Width - 20;
end;

procedure TfrmLim.GridLimSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridLim = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridLim.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridLim.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridLim.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdLim.SortOnFields(fields, false, desc);
end;

procedure TfrmLim.edOrgKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edOrg.Text) > 2) then
                	RunQuery;
end;

procedure TfrmLim.GridLimGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

	if (mdLim.FieldByName('POSSIBLE_PAY').AsFloat <= 2000) then
		Background := $00FFC4C4
	else
		Background := $00FFDDDD;
end;

end.
