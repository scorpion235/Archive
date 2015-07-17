//Настройки
unit fOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RtColorPicker, ComCtrls, ExtCtrls, RXSpin;

type
  TfrmOptions = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    PageOption: TPageControl;
    TabSheetInfo: TTabSheet;
    TabSheetInterface: TTabSheet;
    cbUnCorrectStreet: TCheckBox;
    Bevel1: TBevel;
    lblValue1: TLabel;
    lblTimeOut1: TLabel;
    edUnCorrectStreetTimeOut: TRxSpinEdit;
    edUnCorrectStreetValue: TRxSpinEdit;
    lblValue2: TLabel;
    lblTimeOut2: TLabel;
    cbReeArc: TCheckBox;
    Bevel2: TBevel;
    lblValue3: TLabel;
    lblTimeOut3: TLabel;
    edReeArcValue: TRxSpinEdit;
    edReeArcTimeOut: TRxSpinEdit;
    lblValue4: TLabel;
    lblTimeOut4: TLabel;
    cbUseColorMode: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbUnCorrectStreetClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbReeArcClick(Sender: TObject);
private
    procedure LoadFromIni;
    procedure SaveToIni;
public
    { Public declarations }
end;

implementation

uses
        uCommon;

{$R *.dfm}

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
	PageOption.ActivePageIndex := 0;

   	LoadFromIni;

        //TODO: почему-то не срабатывает при вызове метода "cbUnCorrectStreetClick"
        edUnCorrectStreetValue.Enabled   := cbUnCorrectStreet.Checked;
        edUnCorrectStreetTimeOut.Enabled := cbUnCorrectStreet.Checked;

        edReeArcValue.Enabled            := cbReeArc.Checked;
        edReeArcTimeOut.Enabled          := cbReeArc.Checked;
end;

procedure TfrmOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmOptions.LoadFromIni;
var
	sect: String;
begin
	sect := 'Options';

	cbUnCorrectStreet.Checked      := OptionsIni.ReadBool(sect, 'UnCorrectStreet', false);
        edUnCorrectStreetValue.Value   := OptionsIni.ReadFloat(sect, 'UnCorrectStreetValue', 1000);
        edUnCorrectStreetTimeOut.Value := OptionsIni.ReadFloat(sect, 'UnCorrectStreetTimeOut', 600);

        cbReeArc.Checked               := OptionsIni.ReadBool(sect, 'ReeArc', false);
        edReeArcValue.Value            := OptionsIni.ReadFloat(sect, 'ReeArcValue', 0);
        edReeArcTimeOut.Value          := OptionsIni.ReadFloat(sect, 'ReeArcTimeOut', 600);

        cbUseColorMode.Checked         := OptionsIni.ReadBool(sect, 'UseColorMode', true);
end;

//сохранение параметров в ini-файл
procedure TfrmOptions.SaveToIni;
var
	sect: String;
begin
	sect := 'Options';

        OptionsIni.WriteBool(sect, 'UnCorrectStreet', cbUnCorrectStreet.Checked);
        OptionsIni.WriteFloat(sect, 'UnCorrectStreetValue', edUnCorrectStreetValue.Value);
        OptionsIni.WriteFloat(sect, 'UnCorrectStreetTimeOut', edUnCorrectStreetTimeOut.Value);

	OptionsIni.WriteBool(sect, 'ReeArc', cbReeArc.Checked);
        OptionsIni.WriteFloat(sect, 'ReeArcValue', edReeArcValue.Value);
        OptionsIni.WriteFloat(sect, 'ReeArcTimeOut', edReeArcTimeOut.Value);

        OptionsIni.WriteBool(sect, 'UseColorMode', cbUseColorMode.Checked);
end;

procedure TfrmOptions.cbUnCorrectStreetClick(Sender: TObject);
begin
	edUnCorrectStreetValue.Enabled   := cbUnCorrectStreet.Checked;
        edUnCorrectStreetTimeOut.Enabled := cbUnCorrectStreet.Checked;
end;

procedure TfrmOptions.cbReeArcClick(Sender: TObject);
begin
	edReeArcValue.Enabled   := cbReeArc.Checked;
        edReeArcTimeOut.Enabled := cbReeArc.Checked;
end;

procedure TfrmOptions.btnOKClick(Sender: TObject);
begin
	SaveToIni;
end;

end.
