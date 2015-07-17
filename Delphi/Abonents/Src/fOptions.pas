//Настройки
unit fOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RtColorPicker, ComCtrls, ExtCtrls, RXSpin,
  LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit,
  LMDCustomEdit, LMDCustomBrowseEdit, LMDBrowseEdit;

type
  TfrmOptions = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    PageControl: TPageControl;
    tsReestr: TTabSheet;
    edExportPath: TLMDBrowseEdit;
    lblExportPath: TLabel;
    edImportPath: TLMDBrowseEdit;
    lblImportPath: TLabel;
    tsAbonent: TTabSheet;
    cbVisibleAccClose: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
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
	PageControl.ActivePage := tsReestr;
   	LoadFromIni;
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
	sect: string;
begin
	sect := 'Options';
        edExportPath.Text         := OptionsIni.ReadString(sect, 'ExportPath', 'C:\Invest\Saldo');
        edImportPath.Text         := OptionsIni.ReadString(sect, 'ImportPath', 'C:\Invest\Pays');
        cbVisibleAccClose.Checked := OptionsIni.ReadBool(sect, 'VisibleAccClose', false);
end;

//сохранение параметров в ini-файл
procedure TfrmOptions.SaveToIni;
var
	sect: string;
begin
	sect := 'Options';
        OptionsIni.WriteString(sect, 'ExportPath', edExportPath.Text);
        OptionsIni.WriteString(sect, 'ImportPath', edImportPath.Text);
        OptionsIni.WriteBool(sect, 'VisibleAccClose', cbVisibleAccClose.Checked);
end;

procedure TfrmOptions.btnOKClick(Sender: TObject);
begin
	SaveToIni;
end;

end.
