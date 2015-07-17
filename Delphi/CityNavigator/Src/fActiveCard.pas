//Персонализация карт
unit fActiveCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList,
  ToolEdit, CurrEdit, LMDMaskEdit, LMDSpinEdit, LMDCustomExtSpinEdit,
  LMDExtSpinEdit, LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel,
  LMDBaseEdit, LMDCustomEdit, LMDCustomMaskEdit, LMDCalendarEdit;

type
  TfrmActiveCard = class(TForm)
    lblCardNum: TLabel;
    edCardNum1: TEdit;
    bthOK: TButton;
    btnCancel: TButton;
    edCardNum2: TEdit;
    edCardNum3: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edCardNum2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCardNum2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCardNum3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCardNum3KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bthOKClick(Sender: TObject);
  private
    procedure LoadFromIni;
    procedure SaveToIni;
    //персонализация карты
    procedure ActiveCard;
    //проверка корректного заполнения всех полей
    function CorrectData: boolean;
    //запрос в Оракл
    procedure QueryFromOracle;
  public
    fCardNum2: string;
    fCardNum3: string;
  end;

var
  frmActiveCard: TfrmActiveCard;

implementation

uses
	dmCityNavigator,
        uCommon;

{$R *.dfm}

procedure TfrmActiveCard.FormCreate(Sender: TObject);
begin
	edCardNum1.Enabled := false;
        LoadFromIni;
end;

procedure TfrmActiveCard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmActiveCard.LoadFromIni;
var
	sect: String;
begin
	sect := 'ActiveCard';
        edCardNum1.Text := OptionsIni.ReadString(sect, 'CardNum1', '990002');
        edCardNum2.Text := OptionsIni.ReadString(sect, 'CardNum2', '0000');
        edCardNum3.Text := OptionsIni.ReadString(sect, 'CardNum3', '000000');
end;

//сохранение параметров в ini-файл
procedure TfrmActiveCard.SaveToIni;
var
	sect: String;
begin
	sect := 'ActiveCard';
        OptionsIni.WriteString(sect, 'CardNum1', edCardNum1.Text);
        OptionsIni.WriteString(sect, 'CardNum2', edCardNum2.Text);
        OptionsIni.WriteString(sect, 'CardNum3', edCardNum3.Text);
end;

procedure TfrmActiveCard.edCardNum2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	fCardNum2 := edCardnum2.Text;
end;

procedure TfrmActiveCard.edCardNum2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (Key = VK_RETURN) then
        	ActiveCard

        //проверка использования корректных символов
        else if (((Key < 96) or (Key > 105)) //не цифра
        	and (Key <> VK_LEFT) and (Key <> VK_RIGHT)   //ни LEFT, ни RIGHT
                and (Key <> VK_HOME) and (Key <> VK_END)     //ни HOME, ни END
                and (Key <> VK_BACK) and (Key <> VK_DELETE)  //ни BACKSPACE, ни DELETE
                and (Key <> VK_TAB)  and (Key <> VK_INSERT)) //ни TAB, ни INSERT
                and (Key <> VK_SHIFT)                        //не SHIFT
                then
        begin
        	WarningBox('Использован недопустимый символ "' + chr(Key) + '" (' + IntToStr(Key) + ').');
	        edCardnum2.Text := fCardNum2;
                edCardnum2.SetFocus;
        end;

        if (Length(edCardNum2.Text) > 4) then
        begin
            	WarningBox('Количество символов для данного поля равно 4.');
	        edCardnum2.Text := fCardNum2;
        end;
end;

procedure TfrmActiveCard.edCardNum3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	fCardNum3 := edCardnum3.Text;
end;

procedure TfrmActiveCard.edCardNum3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (Key = VK_RETURN) then
        	ActiveCard

        //проверка использования корректных символов
        else if (((Key < 96) or (Key > 105)) //не цифра
        	and (Key <> VK_LEFT) and (Key <> VK_RIGHT)   //ни LEFT, ни RIGHT
                and (Key <> VK_HOME) and (Key <> VK_END)     //ни HOME, ни END
                and (Key <> VK_BACK) and (Key <> VK_DELETE)  //ни BACKSPACE, ни DELETE
                and (Key <> VK_TAB)  and (Key <> VK_INSERT)) //ни TAB, ни INSERT
                and (Key <> VK_SHIFT)                        //не SHIFT
                then
        begin
        	WarningBox('Использован недопустимый символ "' + chr(Key) + '" (' + IntToStr(Key) + ').');
	        edCardnum3.Text := fCardNum3;
                edCardnum3.SetFocus;
        end;

       	if (Length(edCardNum3.Text) > 6) then
        begin
            	WarningBox('Количество символов для данного поля равно 6.');
	        edCardnum3.Text := fCardNum3;
        end;
end;

procedure TfrmActiveCard.ActiveCard;
begin
	//MsgBox('ActiveCard');
	Screen.Cursor := crHourGlass;
        if (CorrectData) then
	        QueryFromOracle;
        Screen.Cursor := crDefault;
end;

//проверка корректного заполнения всех полей
function TfrmActiveCard.CorrectData: boolean;
var
	card_num: string;
begin
        result := false;

  	if (edCardNum2.Text = '') then
        begin
           	StopClose(self, 'Не полностью заполнен номер карты:'
                + #13 + 'В первом поле должно быть 6 цифр,'
                + #13 + 'во втором - 4 цифры,'
                + #13 + 'в третьем - 6 цифр.', edCardNum2);
                exit;
        end

	else if (edCardNum3.Text = '') then
        begin
           	StopClose(self, 'Не полностью заполнен номер карты:'
                + #13 + 'в первом поле должно быть 6 цифр,'
                + #13 + 'во втором - 4 цифры,'
                + #13 + 'в третьем - 6 цифр.', edCardNum3);
                exit;
        end

        else if (Length(edCardNum2.Text) <> 4) then
        begin
           	StopClose(self, 'Количество символов для данного поля должно быть равно 4.', edCardNum2);
                exit;
        end

	else if (Length(edCardNum3.Text) <> 6) then
        begin
           	StopClose(self, 'Количество символов для данного поля должно быть равно 6.', edCardNum3);
                exit;
        end;

        card_num := edCardNum1.Text + edCardNum2.Text + edCardNum3.Text;

        if (Length(card_num) <> 16) then
        begin
           	StopClose(self, 'Число цифр в номере карты не равна 16 (' + IntToStr(Length(card_num)) + ').'
                + #13 + #13 + 'Обратитесь к разработчику.', edCardNum2);
                exit;
        end;

        //последняя контрольная проверка всех символов номера карты
        {for i := 0 to Length(card_num) - 1 do
        begin
        	//не цифра
        	if ((card_num[i] < '0') or (card_num[i] > '9')) then
                begin
        		StopClose(self, 'Использован недопустимый символ.', edCardNum2);
                        exit;
                end;
        end;}

        result := true;
end;

//запрос в Оракл
procedure TfrmActiveCard.QueryFromOracle;
var
	card_num: string;
begin
        card_num := edCardNum1.Text + edCardNum2.Text + edCardNum3.Text;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Text := 'DECLARE rez varchar2(1024);'
        + 'BEGIN rez := PERS.CINV_CARDCREATE.CreateInRange(' + card_num + ', ' + card_num + ', 0);'
        + 'END;';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        Screen.Cursor := crHourGlass;

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fActiveCard).'
                + #13 + 'Возможно у вас нет требуемых прав для запуска запроса.'
                + #13 + 'Попробуйте персанолизировать карту под пользователем "KP_REPORT".'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        Screen.Cursor := crDefault;

        MsgBox('Карта "' + card_num + '" успешно персонализирована.');
end;

//нажатие на кнопку "OK"
procedure TfrmActiveCard.bthOKClick(Sender: TObject);
begin
    	ActiveCard;
end;

end.
