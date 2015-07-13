// Файл: EasyGraph.pas
// Авторские права © 2003 НПО "Барс"
// Автор: Пнёв Денис Иванович
// Based on code of Vit Kovalcik
//
// Класс для отображения столбчатых графиков.
// ----------------------------------------------------------------------------

unit EasyGraph;


interface

{{$DEFINE Allow_SavetoJPEG_Func}
{Because using unit JPEG cause problems, when you are also using RX Library,
it is possible to turn off saving as JPEG}


uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
	Dialogs, Math, StdCtrls, ExtCtrls, ClipBrd
{$IFDEF Allow_SavetoJPEG_Func}
	, JPEG
{$ENDIF}
	;

const
	MaxRects 		= 10000;   // Максимальное количество блоков.
	MaxPits			= 1000;    // Максимальное количество питов.
	MinVisRectLength	= 0.0001;  // Минимальный размер видимой области
	{This component sometimes didn't draw series correctly
	because of too small numbers. This constant defines minimal
	distance between VisRect.X1-VisRect.X2 or VisRect.Y1-VisRect.Y2
	You shouldn't modify this.}
	{Well, 0.000001 works perfectly for grid and mathematical
	formulas, but series with points connected with lines are still
	not drawn correctly}

	MaxVisRectLength	= 100000; // Максимальный размер видимой области
	{Maximum distance between VisRect.X1-VisRect.X2 or
	VisRect.Y1-VisRect.Y2}

// TODO:
	{Log10(MaxVisRectLength) and Log10(MinVisRectLength) should/must be
	integral numbers !}

	MinMousePointsMove	= 3;
	{Minimum number of pixels, which must cursor cover to begin move
	with view}

type
	TDrawStyle	= (
		dsValues,     	// Блоки в пите разного размера в зависимости от
				// указанной для каждого блока высоты.
				// Блок с максимальной высотой занимает 100%
				// высоты пита.
		dsRectangles	// Все блоки в пите одного размера.
	);
	TBorderStyle	= (bstNone, bstSingle, bstRaised, bstLowered);
	TMouseAction	= (maNone, maRight, maShift, maCtrl, maAlt);
	{
	Action can be zooming or moving view.
	User can zoom IN with mouse, when MouseZoom isn't maNone
	and can zoon OUT by pressing mouse button and key depending
	on following constants:

	maNone - specified action cannot be done
	maRight - action will occur when user presses right
		  mouse button
	maShift - do action when left button with Shift is pressed
	maCtrl - left button + Ctrl
	maAlt - left button + Alt
	}

	TGridStyle	= (gsNone, gsXAxis, gsYAxis, gsAxises, gsXGrid,
			   gsYGrid, gsFull);
	TBgStyle	= (bgsSolid, bgsLineHoriz, bgsLineVert,
			   bgsImageStretch, bgsImageTile);
	{bgsLineHoriz means vertical blend between two colors}
	TEGQuadrant	= (egqAll, egqFirst, egqSecond, egqThird, egqFourth,
			   egqRight, egqLeft);

qFloat = Double;

TPoint2D = record
	X: qFloat;
	Y: qFloat;
end;

TRect2D = record
	X1,Y1: qFloat;
	X2,Y2: qFloat;
end;

TGanntAlign = (
	galClient, 	// на всю ширину Pit'a
	galValue,	// высота соответствует значению
	galTop,		// верхняя треть Pit'a
	galBottom,	// нижняя треть Pit'a
	galMiddle);	// средняя часть Pit'a

// Прямоугольный блок соответствующий состоянию.
TGannt = record
	Time1:	TDateTime;	// Нижняя граница промежутка времени.
	Time2:	TDateTime;	// Верхня граница промежутка времени.
	Height:	qFloat;		// Высота блоков с типом dsValues.
	Align: 	TGanntAlign;	// Выравнивание внутри Pit'а
	Color:	TColor;		// Цвет блока
//	Hint:	PChar;		// Подсказка отображаемая в строке статуса,
//				// которую можно получить по блоку.
	Tag: Integer;	// просто число
	// Видимые координаты на экране, для быстрых хинтов.
	DrawRect: TRect;
end;

PRect2DArray = ^TRect2DArray;
TRect2DArray = array [0..MaxRects-1] of TGannt;

// Горизонтальная полоса графика в которой располагаются ее объекты (блоки).
// Список областей Rect'ов принадлежащих одному Pit'у.
TPit = class {Max. = MaxRects (= 10000)}
private
	fAllocBy: Integer;
	fOnChange: TNotifyEvent;
	fCount: Integer;
//	fColor: TColor;
	fCaption: String; // Заголовок пита. Строки разделяются символом #13.
	fRects: PRect2DArray;	// Массив блоков.
//	FPointSymbol:Char;
	fDrawStyle:TDrawStyle;
	fVisible:Boolean;
	XAllocated:Integer;
public
	// Высота занимаемого питом на диаграмме
	fMinHeight: Integer;	// в процентах, 0 авто.
	// Фактическая высота в пиксехал экрана перед отрисовкой.
	fHeight: Integer;	// TODO: remove
	//TODO: Фактические размеры координатной сетки для отображения.
	// Смещение в процентах от 0 до 1
	fYShift: qFloat;
	// Высота в процентах от 0 до 1
	fYHeight: qFloat;
	// Максимальное высота блока, соответствующуя 100% высоты пита
	// при отображении.
	fMaxValue: qFloat;
protected
	function GetPoints (AIndex:Integer):TGannt;
	procedure SetAllocBy (AValue:Integer);
	procedure SetCaption (AValue:String);
//	procedure SetColor (AValue:TColor);
	procedure SetDrawStyle (AValue:TDrawStyle);
	procedure SetVisible (AValue:Boolean);
public
//	procedure Add (time1, time2: TDateTime; height: qFloat;
//		align: TGanntAlign; color: TColor; hint: String);
	procedure Add (time1, time2: TDateTime; height: qFloat;
		align: TGanntAlign; color: TColor; tag: Integer);
public
	constructor Create;
	destructor Destroy; override;
	procedure Delete (AIndex:Integer);
	procedure Clear;
	property Points[AIndex:Integer]:TGannt read GetPoints; default;
published
	property AllocBy: Integer read FAllocBy write SetAllocBy;
	property Caption: String read FCaption write SetCaption;
	property Count: Integer read FCount;
	property DrawStyle: TDrawStyle read FDrawStyle write SetDrawStyle
		default dsRectangles;
	property OnChange: TNotifyEvent read FOnChange write FOnChange;
	property Visible:Boolean read FVisible write SetVisible;
end;

PPitsArray = ^TPitsArray;
TPitsArray = array [0..MaxPits-1] of TPit;

// Описывает Pit'ы. Список всех питов.
// Горизонтальные области диаграммы, в которой размещаются Rect'ы (блоки).
TPits = class {Max. = MaxPits (= 1000)}
private
	fCount:Integer;
	fOnChange:TNotifyEvent;
	fPits: PPitsArray;
	XNeedUpdate:Boolean;
	XUpdateCounter:Integer;
protected
	function GetPits (AIndex:Integer):TPit;
	procedure PointsChange (Sender:TObject);
public
	constructor Create;
	destructor Destroy; override;

	function Add: Integer;
	procedure Delete (AIndex:Integer);
	procedure Clear;
	procedure BeginUpdate;
	procedure EndUpdate;
	property Pits[AIndex:Integer]:TPit read GetPits; default;
published
	property Count:Integer read FCount;
	property OnChange:TNotifyEvent read FOnChange write FOnChange;
end;

// Текст легенды не зависит от списка питов. 
PLegendItem = ^TLegendItem;
TLegendItem = record
	Color: TColor;	// Цвет отображаемый рядом с блоков.
	Text: PChar;	// Текст отображаемый в легенде.
	Hint: PChar;	// Подсказка отображаемая в строке статуса.
end;

// Информация легенды
TLegend = class
private
	fList: TList;
	// Высота текста в пикселях при последней отрисовке на канве.
	fTextHeight: Integer;
	function GetItems (AIndex: Integer): TLegendItem;
	function GetCount: Integer;
public
	constructor Create;
	destructor Destroy; override;

	property Count: Integer read GetCount;
	property Items[AIndex: Integer]: TLegendItem read GetItems; default;
	property TextHeight: Integer read fTextHeight write fTextHeight;
public
	// Координаты в которых прорисована Легенда (относительно диаграммы).
	DrawRect: TRect;
	// Координаты блока с элементами легенды, для быстрого показа Хинтов.
	ItemsRect: TRect;
	function Add (Color: TColor; Text: String; Hint: String): Boolean;
	procedure Delete (AIndex: Integer);
	procedure Clear;
end;

TEasyGraph = class;

TZoomThread=class(TThread)
private
	Graph:TEasyGraph;
	ToRect:TRect2D;
	NowRect:TRect2D;
	ZoomTime, TimeToDraw:Integer;
public
	constructor Create (AGraph:TEasyGraph; ANowRect, AToRect:TRect2D;
		AZoomTime, ATimeToDraw: Integer);
	procedure Execute; override;
	procedure DrawGraph;
end;

THintById = procedure (Sender: TObject; Id: Integer) of object;

TEasyGraph = class(TGraphicControl)
private
	FAspectRatio:Extended; {X/Y}
	FBgImage:String;
	FBgStyle:TBgStyle;
	FBorderStyle:TBorderStyle;
	FGraphBorder:TBorderStyle;
	FColorBg:TColor;
	FColorBg2:TColor;
	FColorGrid:TColor;
	FColorAxis:TColor;
	FColorBorder:TColor;
	FColorNumb:TColor;
	// список горизонтальных полос
	FPits:TPits;
	FGridStyle:TGridStyle;
	FMaintainRatio:Boolean;
	FNumbHoriz:Boolean;
	FNumbVert:Boolean;
	FOnChange:TNotifyEvent;
	FOnVisChange:TNotifyEvent;
	fOnMouseHint: THintById;	// для получения справки при Shift+click
	FZoomTime:Integer;
	FMouseZoom:TMouseAction;
	FMousePan:TMouseAction;
	FMouseFuncHint:TMouseAction;
	// Видимый участок в координатах рисунка
	FVisRect: TRect2D;
	// Область с данными. Нужна для zoom'а.
	FMaxRect: TRect2D;
	XTempBmp:TBitmap;
	XBgBmp:TBitmap;
	XRenderNeed:Boolean;
	XBgRedraw:Boolean;
	// Видимый участок в координатах экрана
	XGraphRect:TRect;
	XMouseAction:Byte;
	{0..no action
	1..zooming out
	2..moving (can be set together with zooming out)
	4..zooming in
	8..showing function hint}
	XMousePos:TPoint;
	XMousePointsMove:Integer;
	XLastZoomR:TRect;
	XLastBPP:Integer;
	XZoomThread:TZoomThread;
	XTimeToDraw:Integer; {in ms, time to draw last frame}
	XWnd:HWnd;
	XUpdateCounter:Integer;
	//
	fFontCaption: TFont;
	fFontAxis: TFont;
	fFontLegend: TFont;
protected
	procedure MyWndProc (var Message:TMessage);
	procedure SetAspectRatio (AValue:Extended);
	procedure SetBgImage (AValue:String);
	procedure SetBgStyle (AValue:TBgStyle);
	procedure SetBorderStyle (AValue:TBorderStyle);
	procedure SetGridStyle (AValue:TGridStyle);
	procedure SetPits (AValue:TPits);
	procedure SetVisRect (AValue:TRect2D);
	procedure SetColorAxis (AValue:TColor);
	procedure SetColorBg (AValue:TColor);
	procedure SetColorBg2 (AValue:TColor);
	procedure SetColorGrid (AValue:TColor);
	procedure SetColorBorder (AValue:TColor);
	procedure SetColorNumb (AValue:TColor);
	procedure SetGraphBorder (AValue:TBorderStyle);
	procedure SetNumbHoriz (AValue:Boolean);
	procedure SetNumbVert (AValue:Boolean);
	procedure PointsChanged (Sender:TObject);
	procedure Render  (ACanvas:TCanvas);
	procedure Paint; override;
	procedure PitsChange (Sender:TObject);
	procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
		X, Y: Integer); override;
	procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
	procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
		X, Y: Integer); override;

	procedure LineRect (X1,Y1,X2,Y2:Integer);
	procedure GraphZoom;
	procedure AdjustZoom (var R:TRect2D);
	procedure CalculateHint;
public
	constructor Create (AOwner:TComponent);override;
	destructor Destroy; override;

	property Pits:TPits read FPits write SetPits;
	property VisRect:TRect2D read FVisRect write SetVisRect;
	procedure SaveAsBmp (FileName:String);
{$IFDEF Allow_SavetoJPEG_Func}
	procedure SaveAsJpeg (FileName:String);
{$ENDIF}
	procedure ToBMP (var bmp:TBitmap);
	procedure Print;
	procedure CopyToClipboard;
	function GetGraphCoords (X, Y:Integer; GX, GY:PExtended):Boolean;
	// input: [X,Y] are the pixel coordinates relative to upper left corner of the component
	// output: [GX, GY] are "graph-coordinates" of that point
	//    if the input point is outside of the graph (on numbers around it),
	//    the function will return false and will not retrun proper GX and GY
	procedure BeginUpdate;
	// No Invalidate will be called when points/series are updated
	procedure EndUpdate;
published
	property Align;
	property AspectRatio:Extended read FAspectRatio write SetAspectRatio;
	property BgImage:String read FBgImage write SetBgImage;
	property BgStyle:TBgStyle read FBgStyle write SetBgStyle default bgsSolid;
	property BorderStyle:TBorderStyle read FBorderStyle write SetBorderStyle default bstNone;
	property ColorAxis:TColor read FColorAxis write SetColorAxis default clBlack;
	property ColorBg:TColor read FColorBg write SetColorBg default clBtnFace;
	property ColorBg2:TColor read FColorBg2 write SetColorBg2 default clBtnShadow;
	property ColorBorder:TColor read FColorBorder write SetColorBorder default clBlack;
	property ColorGrid:TColor read FColorGrid write SetColorGrid default clGray;
	property ColorNumb:TColor read FColorNumb write SetColorNumb default clBlack;
	property GraphBorder:TBorderStyle read FGraphBorder write SetGraphBorder default bstLowered;
	property GridStyle:TGridStyle read FGridStyle write SetGridStyle default gsFull;
	property MaintainRatio:Boolean read FMaintainRatio write FMaintainRatio;
	property MousePan:TMouseAction read FMousePan write FMousePan;
	property MouseZoom:TMouseAction read FMouseZoom write FMouseZoom;
	property MouseFuncHint:TMouseAction read FMouseFuncHint write FMouseFuncHint;
	property NumbHoriz:Boolean read FNumbHoriz write SetNumbHoriz default True;
	property NumbVert:Boolean read FNumbVert write SetNumbVert default True;
	property OnChange:TNotifyEvent read FOnChange write FOnChange;
	property OnClick;
	property OnDblClick;
	property OnMouseDown;
	property OnMouseUp;
	property OnVisChange:TNotifyEvent read FOnVisChange write FOnVisChange;
	property ZoomTime:Integer read FZoomTime write FZoomTime; {In ms}
	property Caption;
	property OnMouseHint: THintById read fOnMouseHint write fOnMouseHint;
public
	procedure Add (pit: Integer; time1, time2: TDateTime; height: qFloat;
		align: TGanntAlign; color: TColor; tag: Integer);
	procedure Zoom (ZoomFactor: qFloat);
        // Обновляет изображение так чтобы картинка занимало все место.
        procedure FitToWindow;
	procedure Clear;
private
	fLegend: TLegend;
	fCurrentZoom: qFloat;
	procedure UpdateHeights;

	function GetLegendHint (X, Y: Integer): String;
	function GetCurrentZoom: qFloat;
public
	property Legend: TLegend read fLegend;
	property FontCaption: TFont read fFontCaption;
	property FontAxis: TFont read fFontAxis;
	property FontLegend: TFont read fFontLegend;
	property CurrentZoom: qFloat read GetCurrentZoom;
public
	tipOfTheUsing: String;
	tipOfTheShift: String;
end;


procedure Register;

// Вспомогательные функции.

function Gannt (time1, time2: TDateTime; height: qFloat; align: TGanntAlign;
	color: TColor; hint: String): TGannt;

function Rect2D (x1,y1,x2,y2:Extended):TRect2D;

implementation

uses
	Printers;


//resourcestring

//tipOfTheShift = 'Кликните по нужному элементу и удерживайте клавишу Shift.';


// Временные шаги для отображения "красивых значений" на шкале времени.
const
time_steps: array [1..42] of qFloat =
	(100000, 50000, 40000, 20000,
	10000, 5000, 4000, 2000, 1000, 500, 400, 200, 100, 50, 40, 20, 10, 5,
	4, 2, 1, 1/2, 1/3, 1/4, 1/6, 1/8, 1/12, 1/24, 1/48, 1/72, 1/96, 1/144,
	1/288, 1/720, 1/1440, 1/2880, 1/4320, 1/8640, 1/17280, 1/43200,
	1/86400, 1/172800);

// Временные шаги для отображения "объема" на шкале объема (вертикальной).
krug_steps: array [1..38] of qFloat =
	(100000, 50000, 40000, 20000,
	10000, 5000, 4000, 2000, 1000, 500, 400, 200, 100, 50, 40, 20, 10, 5,
	4, 2, 1, 1/2, 1/5, 1/10, 1/20, 1/50, 1/100, 1/200, 1/500, 1/1000,
	1/2000, 1/5000, 1/10000, 1/20000, 1/50000,
	1/100000, 1/200000, 1/500000);


// ----------------------------------------------------------------------------
//
//	Реализация
//
// ----------------------------------------------------------------------------

// TODO:
function Gannt (time1, time2: TDateTime; height: qFloat; align: TGanntAlign;
	color: TColor; hint: String): TGannt;
begin
end;

function Rect2D (x1,y1,x2,y2: Extended): TRect2D;
begin
	Result.x1 := x1;
	Result.y1 := y1;
	Result.x2 := x2;
	Result.y2 := y2;
end;

// ----------------------------------------------------------------------------
//
// 	TPit
//
// ----------------------------------------------------------------------------

constructor TPit.Create;
begin
	FAllocBy	:= 100;
//	FColor		:= clRed;
	FCount		:= 0;
	XAllocated	:= 0;
	FRects		:= nil;
	FDrawStyle	:= dsRectangles;
	FVisible	:= True;

	fMinHeight	:= 0;	// в процентах, 0 авто
	// Фактическая высота в пиксехал экрана перед отрисовкой.
	fHeight		:= 0;
end;

destructor TPit.Destroy;
begin
	Clear;
	inherited Destroy;
end;

// Добавляет новый блок в упорядоченный по полю time1 список.
procedure TPit.Add (time1, time2: TDateTime; height: qFloat;
	align: TGanntAlign; color: TColor; tag: Integer);

	procedure AllocNextPoint;
	begin
		if XAllocated > FCount then
			Exit;

		Inc (XAllocated, FAllocBy);
		ReallocMem (FRects, XAllocated * SizeOf(TGannt));
	end;
var
	A: Integer; // место вставки
	B, C: Integer;
begin
	AllocNextPoint;

	If (FCount = 0) or (time1 > FRects[FCount-1].Time1) then
	begin
		A := fCount;
	end else
	begin	// Бинарный поиск места вставки
		A := 0;
		B := FCount - 1;
		while (A < B) do
		begin
			C := (B - A) div 2 + A;
			If (time1 > FRects[C].Time1) then
				A := C + 1
			else
				B := C;
		end;
		Move (FRects[A], FRects[A+1], (FCount-A) * SizeOf(TGannt));
	end;
	FRects[A].Time1 := time1;
	FRects[A].Time2 := time2;
	FRects[A].Height:= height;
	FRects[A].Align	:= align;
	FRects[A].Color	:= color;
	FRects[A].Tag	:= tag;
	Inc (FCount);

	// Обновим инфу о максимальном значении.
	if fMaxValue < height then
		fMaxValue := height;

	If Assigned (FOnChange) then
		FOnChange (Self);
end;

function TPit.GetPoints (AIndex:Integer):TGannt;
begin
	If (AIndex < FCount) and (AIndex >= 0) then
		Result := FRects[AIndex]
	else
		raise Exception.Create ('TPit.GetPoints: Out of fRects bounds.');
end;

procedure TPit.SetAllocBy (AValue:Integer);
begin
	If (AValue <> FAllocBy) AND (AValue > 0) then
		FAllocBy := AValue;
end;

procedure TPit.Delete (AIndex:Integer);
var
	I: Integer;
begin
	if (AIndex >= FCount) or (AIndex < 0) then
	begin
		raise Exception.Create ('TPit.Delete: Index >= Count!');
		Exit;
	end;

	If AIndex<FCount-1 then
		Move (FRects[AIndex+1], FRects[AIndex],
			(FCount-AIndex-1)*SizeOf(TGannt));
	Dec (FCount);

	If FCount < (XAllocated - FAllocBy*2) then
	begin
		Dec (XAllocated, FAllocBy);
		If (XAllocated <= 0) then
		begin
			FreeMem (FRects);
			FRects := nil;
		end else
		begin
			// Theoretically, there is no need to add FreeMem as
			// ReallocMem could do the same thing, but there is
			// probably a bug, for which it doesn't free allocated memory.
			ReallocMem (FRects, XAllocated*SizeOf(TGannt));
		end;
	end;

	// TODO: not for all, only for values bar
	// Найдем новый максимум.
	fMaxValue := 0;
	for I := 0 to Count - 1 do
		fMaxValue := Max (fMaxValue, fRects[I].Height);

	If Assigned (FOnChange) then
    		FOnChange (Self);
end;

procedure TPit.Clear;
begin
	// Подчищаем память (стоки) размещенные для блоков
	FreeMem (fRects);
	FCount	   := 0;
	XAllocated := 0;
	FRects	   := nil;
	fMaxValue  := 0;

	If Assigned (FOnChange) then
		FOnChange (Self);
end;

{
procedure TPit.SetColor (AValue:TColor);
begin
	If FColor = AValue then
		Exit;

	FColor:=AValue;
	If Assigned (FOnChange) then
		FOnChange (Self);
end;
}

procedure TPit.SetCaption (AValue:String);
begin
	If (FCaption = AValue) then
		Exit;

	FCaption := AValue;
	If (Assigned (FOnChange)) then
		FOnChange (Self);
end;


procedure TPit.SetDrawStyle (AValue:TDrawStyle);
begin
	If FDrawStyle = AValue then
		Exit;

	FDrawStyle:=AValue;
	If Assigned(OnChange) then
		OnChange (Self);
end;

procedure TPit.SetVisible (AValue:Boolean);
begin
	If FVisible = AValue then
		Exit;

	FVisible:=AValue;
	If Assigned(OnChange) then
		OnChange (Self);
end;

// ----------------------------------------------------------------------------
//
// 	class TPits
//
// ----------------------------------------------------------------------------

constructor TPits.Create;
begin
	FCount	:= 0;
	FPits 	:= nil;
	XNeedUpdate:=False;
end;

destructor TPits.Destroy;
begin
	FreeMem (FPits);
	inherited Destroy;
end;

function TPits.GetPits (AIndex:Integer): TPit;
begin
	If (AIndex > FCount) or (AIndex < 0) then
		raise Exception.Create ('TPits.GetPits: Out of bounds.');

	Result := FPits[AIndex];
end;

function TPits.Add: Integer;
begin
	Result := -1;
	Inc (FCount);
	ReallocMem (FPits, FCount*SizeOf(TPit));
	if (fPits <> nil) then
		Result := fCount;
	FPits[FCount-1]	:= TPit.Create;
	FPits[FCount-1].OnChange := PointsChange;
	If XUpdateCounter=0 then
	begin
		If Assigned (FOnChange) then
			FOnChange (Self);
	end
	else
		XNeedUpdate:=True;
end;

procedure TPits.Delete (AIndex:Integer);
begin
	If (AIndex<0) OR (AIndex>=FCount) then
	begin
		raise Exception.Create ('TPits.Delete: Index out of bound.');
		Exit;
	end;

	FPits[AIndex].Free;
	If AIndex < FCount-1 then
		Move (FPits[AIndex+1], FPits[AIndex],
			(FCount-AIndex-1)*SizeOf(TPit));

	Dec (FCount);
	If (FCount <= 0) then
	begin
		FreeMem (FPits);
		FPits := nil;
	end else
	begin
		// Theoretically, there is no need to add FreeMem as
		// ReallocMem could do the same thing, but there is
		// probably a bug, for which it doesn't free allocated memory.
		ReallocMem (FPits, FCount*SizeOf(TPit));
	end;

	If XUpdateCounter=0 then
	begin
		If Assigned (FOnChange) then
			FOnChange (Self);
	end
	else
		XNeedUpdate:=True;
end;

procedure TPits.Clear;
var
	A:Integer;
begin
	for A := 0 to FCount - 1 do
		FPits[A].Free;

	FreeMem (FPits);
	FCount := 0;
	FPits := nil;
	If XUpdateCounter=0 then
	begin
		If Assigned (FOnChange) then
			FOnChange (Self);
	end
	else
		XNeedUpdate:=True;
end;

procedure TPits.PointsChange (Sender:TObject);
begin
  If XUpdateCounter=0 then
  begin
    If Assigned(OnChange) then
      OnChange (Self);
  end
  else
    XNeedUpdate:=True;
end;

procedure TPits.BeginUpdate;
begin
	Inc (XUpdateCounter);
	XNeedUpdate:=False;
end;

procedure TPits.EndUpdate;
begin
  If XUpdateCounter>0 then
    Dec (XUpdateCounter);
  If (XUpdateCounter=0) AND (XNeedUpdate) then
  begin
    XNeedUpdate:=False;
    FOnChange (Self);
  end;
end;


//------------------------------------------------------------------------------
//
//	TEasyGraph
//
//------------------------------------------------------------------------------

procedure TEasyGraph.MyWndProc (var Message:TMessage);
var
	P:TPoint;
begin
	case Message.Msg of
	WM_MOUSEMOVE:
	begin
		P := ClientToScreen (Point(0,0));
		XMousePos := Point(LOWORD(Message.lParam)-P.X,
				   HIWORD(Message.lParam)-P.Y);
		If not PtInRect (XGraphRect,XMousePos) then
//		begin
			XMouseAction := 0;
//			XHintForm.Hide;
//		end else
		CalculateHint;
	end;
	WM_LBUTTONDOWN,
	WM_RBUTTONDOWN,
	WM_MBUTTONDOWN,
	WM_LBUTTONUP,
	WM_RBUTTONUP,
	WM_MBUTTONUP,
	WM_LBUTTONDBLCLK,
	WM_RBUTTONDBLCLK,
	WM_MBUTTONDBLCLK:
	begin
		XMouseAction := 0;
		//XHintForm.Hide;
		ReleaseCapture;
		DeallocateHWnd (XWnd);
	end;
	end; {case}	
end;


constructor TEasyGraph.Create (AOwner:TComponent);
begin
	inherited Create (AOwner);
	XLastBPP:=0;
	XZoomThread:=nil;
	XMouseAction:=0;
	FAspectRatio:=1;
	FBgImage:='';
	FBgStyle:=bgsSolid;
	FMaintainRatio:=False;
	FMouseZoom:=maRight;
	FMousePan:=maRight;
	FMouseFuncHint:=maShift;
	FZoomTime:=200;
	FColorAxis:=clBlack;
	FColorBg:=clBtnFace;
	FColorBg2:=clBtnShadow;
	FColorGrid:=clGray;
	FColorBorder:=clBlack;
	FColorNumb:=clBlack;
	FGridStyle:=gsFull;
	FNumbHoriz:=True;
	FNumbVert:=True;
	FOnChange:=nil;
	FOnVisChange:=nil;
	//  FOnXLabeling:=nil;
	//  FOnYLabeling:=nil;
	FPits:=TPits.Create;
	FPits.OnChange:=PitsChange;
	FBorderStyle:=bstNone;
	FGraphBorder:=bstSingle;//bstLowered;
	Width:=60;
	Height:=40;
	XRenderNeed:=True;
	XBgRedraw:=True;
	XTempBmp:=nil;
	XBgBmp:=nil;
	//  XLegend:=nil;
	FVisRect.X1:=-10;
	FVisRect.Y1:=-10;
	FVisRect.X2:=10;
	FVisRect.Y2:=10;

	FMaxRect.X1 := MaxVisRectLength;
	FMaxRect.X2 := -MaxVisRectLength;
	FMaxRect.Y1 := MaxVisRectLength;
	FMaxRect.Y2 := -MaxVisRectLength;
	//  XHintForm:=TEGHintForm.Create (Self);
	//  XHintForm.Width:=80;
	//  XHintForm.Height:=50;
	//  XHintForm.BorderStyle:=bsNone;
	XUpdateCounter := 0;

	//
	fLegend := TLegend.Create;

	fFontCaption := TFont.Create;
	fFontCaption.Name := 'Arial Cyr';
	fFontCaption.Size := 8;

	fFontAxis := TFont.Create;
	fFontAxis.Name := 'Arial Cyr';
	fFontAxis.Size := 8;

	fFontLegend := TFont.Create;
	fFontLegend.Name := 'Arial Cyr';
	fFontLegend.Size := 8;

	tipOfTheUsing  := 'Для получения дополнительной информации по элементам диаграммы нажмите клавишу Shift и кликните по нужному элементу'
end;

destructor TEasyGraph.Destroy;
begin
	If XZoomThread<>nil then
		XZoomThread.Free;

	fFontCaption.Free;
	fFontAxis.Free;
	fFontLegend.Free;

	Pits.Free;
	fLegend.Free;
	inherited Destroy;
end;


procedure TEasyGraph.SetAspectRatio (AValue:Extended);
begin
  If (FAspectRatio<>AValue) AND (AValue<>0) then
  begin
    FAspectRatio:=AValue;
    XRenderNeed:=True;
    Invalidate;
    If Assigned (OnChange) then
      OnChange (Self);
  end;
end;

procedure TEasyGraph.SetBgImage (AValue:String);
begin
  If FBgImage<>AValue then
  begin
    FBgImage:=AValue;
    If (FBgStyle=bgsImageStretch) OR (FBgStyle=bgsImageTile) then
    begin
      XRenderNeed:=True;
      XBgRedraw:=True;
      Invalidate;
    end;
    If Assigned (OnChange) then
      OnChange (Self);
  end;
end;

procedure TEasyGraph.SetBgStyle (AValue:TBgStyle);
begin
  If FBgStyle<>AValue then
  begin
    FBgStyle:=AValue;
    XRenderNeed:=True;
    XBgRedraw:=True;
    Invalidate;
    If Assigned (OnChange) then
      OnChange (Self);
  end;
end;

procedure TEasyGraph.SetBorderStyle (AValue:TBorderStyle);
begin
  If FBorderStyle<>AValue then
  begin
    FBorderStyle:=AValue;
    XRenderNeed:=True;
    Invalidate;
    If Assigned (OnChange) then
      OnChange (Self);
  end;
end;

procedure TEasyGraph.SetPits (AValue:TPits);
begin
  If (AValue<>FPits) AND (AValue<>nil) then
  begin
    FPits :=AValue;
    XRenderNeed:=True;
    Invalidate;
    If Assigned (OnChange) then
      OnChange (Self);
  end;
end;

procedure TEasyGraph.PointsChanged (Sender:TObject);
begin
  XRenderNeed:=True;
  If (XUpdateCounter = 0) then
    Invalidate;
end;

procedure TEasyGraph.SetVisRect (AValue:TRect2D);
var Z:Extended;
begin
  If (AValue.X1<>AValue.X2) AND (AValue.Y1<>AValue.Y2) then
  begin
    FVisRect:=AValue;
    with FVisRect do
    begin
      If X2<X1 then
      begin
	Z:=X1;
	X1:=X2;
	X2:=Z;
      end;
      If Y2<Y1 then
      begin
	Z:=Y1;
	Y1:=Y2;
	Y2:=Z;
      end;
    end;
    XRenderNeed:=True;
    If Assigned (FOnVisChange) then
      FOnVisChange (Self);
    Paint;
  end;
end;


procedure TEasyGraph.Render (ACanvas:TCanvas);
var R:TRect;
    A,B,C:Integer;
    S: String;
    DC:HDC;
    XBmp:TBitmap;
    DrawCanvas:TCanvas;
    Rgn:HRgn;
    TempR:TRect;

	procedure DrawBorder (ABS: TBorderStyle; AClr: TColor);

		procedure DrawUp;
		begin
			DrawCanvas.MoveTo (R.Left,R.Bottom-1);
			DrawCanvas.LineTo (R.Left,R.Top);
			DrawCanvas.LineTo (R.Right+1,R.Top);
		end;

		procedure DrawDown;
		begin
			DrawCanvas.MoveTo (R.Left,R.Bottom);
			DrawCanvas.LineTo (R.Right,R.Bottom);
			DrawCanvas.LineTo (R.Right,R.Top);
		end;

	begin
		DrawCanvas.Pen.Style:=psSolid;
		Case ABS of
		bstSingle:
		begin
			DrawCanvas.Pen.Color := AClr;
			DrawCanvas.Rectangle(R.Left,R.Top,R.Right+1,R.Bottom+1);
		end;
		bstRaised:
		begin
			DrawCanvas.Pen.Color := clBtnHighlight;
			DrawUp;
			DrawCanvas.Pen.Color := clBtnShadow;
			DrawDown;
		end;
		bstLowered:
		begin
			DrawCanvas.Pen.Color := clBtnHighlight;
			DrawDown;
			DrawCanvas.Pen.Color := clBtnShadow;
			DrawUp;
		end;
		end;
		If ABS <> bstNone then
			InflateRect (R,-1,-1);
	end;
(*
  procedure DrawGridAndNumbers;
  var A:Integer;
      B:Integer;
      Re,Re2,Re3:Extended;
      Two:Boolean;
      TR:TRect;
  begin
    with DrawCanvas do
    begin
{Vertical numbers}
      If (FGridStyle<>gsNone) OR
         (FNumbVert) then
      begin
	C:=DrawCanvas.TextHeight ('Xy');
	A:=Round(((XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1)*MaxVisRectLength)/C);
	  {'A' now means maximum number of numbers in range 1..MaxVisRectLength}
          {Don't try to understand it :) }
	Re:=MaxVisRectLength;
	B:=1;
	Two:=True;
        while B<A do
	begin
	  If Two then
          begin
	    B:=B*2;
	    If B<A then
	      Re:=Re/2;
	  end
	  else
	  begin
	    B:=B*5;
            If B<A then
	      Re:=Re/5;
          end;
          Two:=not Two;
	end;
	Re2:=FVisRect.Y1/Re;
	If Re2<=0 then
	  Re2:=Trunc (Re2)*Re-Re
        else
          Re2:=Trunc (Re2)*Re+Re;
	Re3:=(XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1);
	DrawCanvas.Pen.Color:=FColorGrid;
	DrawCanvas.Font.Color:=FColorNumb;
	DrawCanvas.Pen.Style := psDot;
	C:=C div 2;
	TR.Left:=R.Left;
	TR.Top:=R.Top;
	TR.Right:=XGraphRect.Left;
	TR.Bottom:=XGraphRect.Bottom;
	DrawCanvas.Brush.Style:=bsClear;
	while Re2<=FVisRect.Y2 do
	  {Warning: Should be probably '=' but then it sometimes does stange things}
	begin
{          A:=Round((Re2-FVisRect.Y1)*Re3);}
	  A:=Trunc((Re2-FVisRect.Y1)*Re3);
	  If A>=0 then
	  begin
	    A:=XGraphRect.Bottom-A;
            If (FGridStyle=gsXAxis) OR (FGridStyle=gsAxises) OR
	       (FGridStyle=gsXGrid) OR (FGridStyle=gsFull) then
	    begin
              If Abs(Re2)<0.00001 then
		{Warning : This depends on MinVisRectLength}
                {...this should be 0, but computer isn't 100% accurate}
	      begin
		DrawCanvas.Pen.Color:=FColorAxis;
		DrawCanvas.MoveTo (XGraphRect.Left,A);
                DrawCanvas.LineTo (XGraphRect.Right+1,A);
                DrawCanvas.Pen.Color:=FColorGrid;
	      end
	      else
	      begin
                If (FGridStyle=gsXGrid) OR (FGridStyle=gsFull) then
                begin
                  DrawCanvas.MoveTo (XGraphRect.Left,A);
                  DrawCanvas.LineTo (XGraphRect.Right+1,A);
		end;
              end;
	    end;
	    If NumbVert then
            begin
	      DrawCanvas.Brush.Style:=bsClear;
	      S:=FloatToStrF (Re2,ffFixed,16,Abs(Round(Log10(MinVisRectLength)))+1);
	      B:=DrawCanvas.TextWidth (S);
              DrawCanvas.TextRect (TR,XGraphRect.Left-B-3,A-C,S);
	    end;
	  end;
	  Re2:=Re2+Re;
	end;
      end;
{Horizontal numbers}
      If (FGridStyle<>gsNone) OR
	 (FNumbHoriz) then
      begin
	  S:='';
	  If ((FVisRect.X1 < 0.00001) AND (FVisRect.X1 > -0.00001)) then
	    A := 5
	  else
	    A := Round(Abs(log10(Abs(FVisRect.X1))));
	  If ((FVisRect.X2 < 0.00001) AND (FVisRect.X2 > -0.00001)) then
	    B := 5
	  else
	    B := Round(Abs(log10(Abs(FVisRect.X2))));
	  If B>A then
	    A:=B;
	  For B:=0 to A do
	    S:=S+'8';
	  A:=Round(-log10(MinVisRectLength))+1;
	  If A>0 then
	  begin
	    S:=S+',';
	    For B:=1 to A do
	      S:=S+'8';
	  end;

	If (Length (S) > 0) then
        begin
          C:=DrawCanvas.TextWidth (S);
	  A:=Round(((XGraphRect.Right-XGraphRect.Left)/(FVisRect.X2-FVisRect.X1)*MaxVisRectLength)/C);
        end
	else
          A:=10;   
        Re:=MaxVisRectLength;
        B:=1;
	Two:=True;
        while B<A do
	begin
	  If Two then
          begin
            B:=B*2;
            If B<A then
              Re:=Re/2;
	  end
          else
          begin
	    B:=B*5;
            If B<A then
              Re:=Re/5;
	  end;
	  Two:=not Two;
        end;
	Re2:=FVisRect.X1/Re;
	If Re2<=0 then
	  Re2:=Trunc (Re2)*Re-Re
        else
	  Re2:=Trunc (Re2)*Re+Re;
	Re3:=(XGraphRect.Right-XGraphRect.Left)/(FVisRect.X2-FVisRect.X1);
        DrawCanvas.Pen.Color:=FColorGrid;
	C:=C div 2;
        TR.Left:=XGraphRect.Left;
	TR.Top:=XGraphRect.Bottom+1;
        TR.Right:=R.Right;
	TR.Bottom:=R.Bottom;
        DrawCanvas.Brush.Style:=bsClear;
	while Re2<=FVisRect.X2 do
          {Warning: Should be probably '=' but then it sometimes does stange things}
        begin
{          A:=Round((Re2-FVisRect.X1)*Re3);}
          A:=Trunc((Re2-FVisRect.X1)*Re3);
          If A>=0 then
	  begin
            A:=A+XGraphRect.Left;
            If (FGridStyle=gsYAxis) OR (FGridStyle=gsAxises) OR
	       (FGridStyle=gsYGrid) OR (FGridStyle=gsFull) then
            begin
              If Abs(Re2)<0.00001 then
		{Warning : This depends on MinVisRectLength}
		{...this should be 0, but computer isn't 100% accurate}
	      begin
                DrawCanvas.Pen.Color:=FColorAxis;
		DrawCanvas.MoveTo (A,XGraphRect.Top);
		DrawCanvas.LineTo (A,XGraphRect.Bottom+1);
                DrawCanvas.Pen.Color:=FColorGrid;
              end
	      else
	      begin
		If (FGridStyle=gsYGrid) OR (FGridStyle=gsFull) then
		begin
		  DrawCanvas.MoveTo (A,XGraphRect.Top);
		  DrawCanvas.LineTo (A,XGraphRect.Bottom+1);
                end;
              end;
	    end;
	    If NumbHoriz then
	    begin
	      S:=TimeToSTr (Re2);
//	      if MinVisRectLength < 0.01 then
	      if Length (s) > 7 then
		s := copy (s, 1, 5)
	      else
		s := copy (s, 1, 4);
	      //S:=FloatToStrF (Re2,ffFixed,16,Abs(Round(Log10(MinVisRectLength)))+1);
	      B:=DrawCanvas.TextWidth (S);
	      DrawCanvas.TextRect (TR,A-B div 2,XGraphRect.Bottom+4,S);
	    end;
	  end;
	  Re2:=Re2+Re;
        end;
      end;
      R:=XGraphRect;
      InflateRect(R,1,1);
      DrawBorder (FGraphBorder,FColorBorder);
    end;
  end;
*)
//  procedure DrawFuncLines (Ind:Integer);
  {
  Var A:Integer;
      RY,Incr:Extended;
      Clr:TColor;
      ZY:Integer;
      PrevDef:Boolean;}
	 {If the previous value was correctly computed and now is in graph.
	  For example: It is not possible to display function ln(x) for x<0.}
  {    Ext:Extended;
      FuncOK:Boolean;
      TP:Array [0..1] of TPoint;
      MinY, MaxY:Extended;
  }
//  begin
    (*
    Clr:=FSeries[Ind].Color;
    RY:=(R.Bottom-R.Top)/(FVisRect.Y2-FVisRect.Y1);
    Incr:=(FVisRect.X2-FVisRect.X1)/(R.Right-R.Left);
    MinY:=FVisRect.Y1-Incr/2;
    MaxY:=FVisRect.Y2+Incr/2;
    Ext := MaxY - MinY;
    MinY := MinY - Ext * 20; // estimation
    MaxY := MaxY + Ext * 20;
    XParser.X:=FVisRect.X1;
    PrevDef:=False;
    with DrawCanvas do
    begin
      Pen.Style:=psSolid;
      Pen.Color:=Clr;
      ZY:=0;
      For A:=R.Left to R.Right do
      begin
	If (XParser.X > FSeries[Ind].FFuncDomX2) then
          break;

        If (XParser.X < FSeries[Ind].FFuncDomX1) then
          FuncOK := False
        else
        begin
	  try
            Ext:=XParser.Value;
	    FuncOK:=not XParser.CalcError;
            If (FuncOK) then
            begin
              If (Ext < MinY) OR (Ext > MaxY) then
		FuncOK := False
              else
                ZY:=R.Bottom-Round((Ext-FVisRect.Y1)*RY);
	    end;
	  except
	    FuncOK:=False;
          end;
	end;

        If FuncOK then
	begin
          If NOT PrevDef then
          begin
            TP[0].X:=A;
            TP[0].Y:=ZY;
	  end
          else
          begin
            TP[1].X:=A;
            TP[1].Y:=ZY;
            If NOT
	       (((TP[0].Y<0) AND (TP[1].Y<0)) OR
	       ((TP[0].Y>Height) AND (TP[1].Y>Height))) then
	      DrawCanvas.PolyLine (TP);
	    TP[0]:=TP[1];
	  end;
	  PrevDef:=True;
	end
	else
	  PrevDef:=False;
	XParser.X:=XParser.X+Incr;
      end; {For A:=R.Left to R.Right}
      If PrevDef then
	Pixels [R.Right,ZY]:=Clr;
    end; {with DrawCanvas}
    *)
//  end;

//  procedure DrawFuncPoints (Ind:Integer);
  {
  Var A,Y:Integer;
      RY,Incr:Extended;
      Clr:TColor;
      MinY,MaxY:Extended;
      Ext:Extended;
      FuncOK:Boolean;
  }
//  begin
  (*
    Clr:=FSeries[Ind].Color;
    RY:=(R.Bottom-R.Top)/(FVisRect.Y2-FVisRect.Y1);
    Incr:=(FVisRect.X2-FVisRect.X1)/(R.Right-R.Left);
    XParser.X:=FVisRect.X1;
    MinY:=FVisRect.Y1-Incr/2;
    MaxY:=FVisRect.Y2+Incr/2;
    Y:=0;
    For A:=R.Left to R.Right do
    begin
      If (XParser.X > FSeries[Ind].FFuncDomX2) then
        break;

      If (XParser.X < FSeries[Ind].FFuncDomX1) then
	FuncOK := False
      else
      begin                         
	try
          Ext:=XParser.Value;
	  FuncOK:=not XParser.CalcError;
          If (FuncOK) then
          begin
            If (Ext <= MinY) OR (Ext >= MaxY) then
	      FuncOK := False
            else
              Y := R.Bottom-Round((Ext-FVisRect.Y1)*RY);
	  end;
        except
          FuncOK:=False;
        end;
      end;

      If (FuncOK) then
	DrawCanvas.Pixels [A,Y]:=Clr;
      XParser.X:=XParser.X+Incr;
    end; {For A:=R.Left to R.Right}
  *)
//  end;

//  procedure DrawLines (Ind:Integer);
  {
  Var A:Integer;
      RX,RY:Extended;
      P:TPoint2D;
      First:Boolean;
      }
//  begin
    (*
    with DrawCanvas do
    begin
      with FSeries[Ind] do
      begin
        RX:=(R.Right-R.Left)/(FVisRect.X2-FVisRect.X1);
        RY:=(R.Bottom-R.Top)/(FVisRect.Y2-FVisRect.Y1);
        First:=True;
	Pen.Style:=psSolid;
        Pen.Color:=Color;
        For A:=0 to Count-1 do
        begin
          P:=FPoints[A];
	  If P.X>=FVisRect.X1 then
	  begin
	    If P.X>FVisRect.X2 then
            begin
	      If not First then
                LineTo (R.Left+Round((P.X-FVisRect.X1)*RX),R.Bottom-Round((P.Y-FVisRect.Y1)*RY));
              Break;
	    end
            else
            begin
              If (Count=1) then
		Pixels[R.Left+Round((FPoints[0].X-FVisRect.X1)*RX),R.Bottom-Round((FPoints[0].Y-FVisRect.Y1)*RY)]:=Color
	      else
              begin
                If First then
		  MoveTo (R.Left+Round((P.X-FVisRect.X1)*RX),R.Bottom-Round((P.Y-FVisRect.Y1)*RY))
                else
		  LineTo (R.Left+Round((P.X-FVisRect.X1)*RX),R.Bottom-Round((P.Y-FVisRect.Y1)*RY));
              end;
	    end;
	    First:=False;
          end {If FPoints[A].X>=FVisRect.X1}
	  else
            If Count>A+1 then
              If FPoints[A+1].X>FVisRect.X1 then
              begin
                MoveTo (R.Left+Round((P.X-FVisRect.X1)*RX),R.Bottom-Round((P.Y-FVisRect.Y1)*RY));
		First:=False;
	      end;
	end; {For A:=0 to Count-1}
      end; {with FSeries[Ind]}
    end; {with DrawCanvas}
    *)
//  end;

//  procedure DrawPoints (Ind:Integer);
  {
  Var A:Integer;
      RX,RY:Extended;
      P:TPoint2D;
      OldClr:TColor;
      TW,TH:Integer;
      PS:Char;}
//  begin
    (*
    with FSeries[Ind] do
    begin
      RX:=(R.Right-R.Left)/(FVisRect.X2-FVisRect.X1);
      RY:=(R.Bottom-R.Top)/(FVisRect.Y2-FVisRect.Y1);
      OldClr := DrawCanvas.Font.Color;
      DrawCanvas.Font.Color := Color;
      DrawCanvas.Brush.Style := bsClear;
      PS := FSeries[Ind].PointSymbol;
      TW := DrawCanvas.TextWidth (PS) div 2;
      TH := DrawCanvas.TextHeight (PS) div 2;
      For A:=0 to Count-1 do
      begin
        P:=Points[A];
	If P.X>=FVisRect.X1 then
        begin
	  If P.X>FVisRect.X2 then
	    Break;
          If (P.Y>=FVisRect.Y1) AND (P.Y<=FVisRect.Y2) then
          begin
	    If FSeries[Ind].PointSymbol = #0 then
              DrawCanvas.Pixels [R.Left+Round((P.X-FVisRect.X1)*RX),R.Bottom-Round((P.Y-FVisRect.Y1)*RY)]:=Color
            else
	    begin
              DrawCanvas.TextOut (R.Left+Round((P.X-FVisRect.X1)*RX) - TW,
				  R.Bottom-Round((P.Y-FVisRect.Y1)*RY) - TH, PS);
            end;
          end;
	end; {If FPoints[A].X>=FVisRect.X1}
      end; {For A:=0 to Count-1}
      DrawCanvas.Font.Color := OldClr;
      DrawCanvas.Brush.Style := bsSolid;
    end; {with FSeries[Ind]}
  *)
//  end;
	procedure DrawBars2 (Index:Integer);
	var
		I:Integer;
		RX,RY:Extended;
		P: TGannt;
		d_r: TRect;
		e_shiftY, e_heightY: qFloat;
		max_height: qFloat;
		k_h: qFloat;
	begin
		RX := (R.Right-R.Left)/(FVisRect.X2-FVisRect.X1);
		RY := (R.Bottom-R.Top)/(FVisRect.Y2-FVisRect.Y1);
		DrawCanvas.Pen.Style:=psSolid;
		DrawCanvas.Pen.Color:=clBlack;

		e_shiftY := fPits[A].fYShift;
		e_heightY := fPits[A].fYHeight;

		// Найдем максимум у блоков.
		//TODO: other max search.

		max_height := 0;
		for I := 0 to fPits[Index].Count-1 do
		begin
			P:=fPits[Index].FRects[I];
			if (P.Align = galValue) then
				max_height := Max (P.Height, max_height);
		end;
		if max_height <> 0 then
			k_h := e_heightY / max_height
		else
			k_h := 0;

		DrawCanvas.Brush.Style := bsSolid;
		for I := 0 to fPits[Index].Count-1 do
		begin
			P:=fPits[Index].FRects[I];
			if DrawCanvas.Brush.Color <> P.Color then
				DrawCanvas.Brush.Color := P.Color;
			d_r.Left := R.Left + Trunc((P.Time1-FVisRect.X1)*RX);
			d_r.Right := R.Left + Trunc((P.Time2-FVisRect.X1)*RX);
			if (p.Align <> galValue) then
			begin
			d_r.Bottom := R.Bottom-Trunc(((e_shiftY)-FVisRect.Y1)*RY);
			d_r.Top := R.Bottom-Trunc(((e_shiftY + e_heightY)-FVisRect.Y1)*RY);
			end else
			begin
			d_r.Bottom := R.Bottom-Trunc(((e_shiftY)-FVisRect.Y1)*RY);
			d_r.Top := R.Bottom-Trunc(((e_shiftY + k_h*p.Height)-FVisRect.Y1)*RY);
			end;
			// Защита для Вин98 от кривого рисования.
			d_r.Left 	:= Max (d_r.Left, -1);
			d_r.Right 	:= Max (d_r.Right, -1);
			d_r.Top 	:= Max (d_r.Top, -1);
			d_r.Bottom 	:= Max (d_r.Bottom, -1);

			d_r.Left 	:= Min (d_r.Left, 2400);
			d_r.Right 	:= Min (d_r.Right, 2400);
			d_r.Top 	:= Min (d_r.Top, 2400);
			d_r.Bottom 	:= Min (d_r.Bottom, 2400);
			//
			if (d_r.Right - d_r.Left < 3) then
			begin
				Inc(d_r.Right);
				DrawCanvas.Pen.Color := p.Color;
				DrawCanvas.Rectangle (d_r);
				DrawCanvas.Pen.Color := clBlack;
			end else
			begin
				DrawCanvas.Rectangle (d_r);
			end;
			fPits[Index].FRects[I].DrawRect := d_r;
		end;
	end;

	procedure MyTextRect (Rect: TRect; X, Y: Integer; const Text: string);
	var
		w: Integer;
		s: String;
		I: Integer;
	begin
		DrawCanvas.Font := FontCaption;
		w := DrawCanvas.TextWidth (Text);
		if (Rect.Right - Rect.Left >= w) then
		begin
			DrawCanvas.TextRect (Rect, X, Y, Text);
			Exit;
		end;

		for I := Length(Text) - 3 downto 1 do
		begin
			s := Copy (Text, 1, I) + '...';
			w := DrawCanvas.TextWidth (s);
			if (Rect.Right - Rect.Left >= w) then
			begin
				DrawCanvas.TextRect (Rect, X, Y, s);
				Exit;
			end;
		end;
		DrawCanvas.TextRect (Rect, X, Y, Text)
	end;
	procedure DrawCaption;
	var
		text_height: Integer;
		text_width: Integer;
		text_rect: TRect;
		s, txt: String;
		p: Integer;
		line: Integer;
		x, y: Integer;
		max_text_width: Integer;
	begin
		line := 0;
		txt := Caption;

//		DrawCanvas.Font.Name := 'Arial';
//		DrawCanvas.Font.Size := 8;
		DrawCanvas.Font := FontCaption;

		text_height := DrawCanvas.TextHeight ('Xy');
		while (Length (txt) > 0) do
		begin
			p := Pos (#13, txt);
			if (p <> 0) then
				s := Copy (txt, 1, p-1)
			else
				s := txt;
			txt := Copy (txt, Length (s)+2, Length (txt));
			text_width  := DrawCanvas.TextWidth (s);
			max_text_width := Width - (Legend.DrawRect.Right-Legend.DrawRect.Left);
			x := Max (Left, Left + (max_text_width - text_width) div 2);
			y := text_height*line;
			y := y + text_height div 2;
			text_rect   := Rect (x, y, x+max_text_width, y+text_height);
			DrawCanvas.Brush.Style := bsClear;
			MyTextRect (text_rect, x, y, s);
			Inc (line);
		end;
		if (line > 0) then
			Inc (line);
		Inc (XGraphRect.Top, text_height*line);
		if XGraphRect.Top < Legend.DrawRect.Bottom then
			XGraphRect.Right := Legend.DrawRect.Left
		else
			Dec (XGraphRect.Right, 4);
	end;
	// Легенда рисуется с верхнего-правого угла
	// + <- start corner        } <- border
	//   +-------------------+
	//   |                   |  } <- space
	//   |  [X]  Text1 Text  |
	//   |  [Y]  Text2 Text  |
	//  ...^   ^       ^    ...
	// ^ +-|---|-------|-----+ <- end corner
	// |   space       space
	// border
	procedure DrawLegend;
	var
		I: Integer;
		text_rect: TRect;
		text_height: Integer;
		text_width, w: Integer;
		item: TLegendItem;
		border, space: Integer;
		x, y: Integer;
		need_height, need_width: Integer;
		brick_width, brick_height: Integer;
		brick_rect: TRect;
		r: TRect;
		text_shift: Integer;
		max_text_len: Integer;
	begin
		if Legend.Count = 0 then
		begin
			Legend.DrawRect := Rect (0, 0, 0, 0);
			Legend.ItemsRect := Rect (0, 0, 0, 0);
			Exit;
		end;
		DrawCanvas.Font := FontLegend;

		border := 3; 	// пространство вокруг рамки
		space  := 4; 	// отступ внутри рамки

		// Найдем максимальную ширину текста.
		text_height := DrawCanvas.TextHeight ('Xy');
		text_width := 0;
		for I := 0 to Legend.Count - 1 do
		begin
			item := Legend.Items[i];
			if (Length (item.Text) = 0) then
				continue;
			w := DrawCanvas.TextWidth (item.Text);
			text_width := Max (text_width, w);
		end;

		Legend.TextHeight := text_height;

		// Размеры прямоугольников с обозначением цвета.
		brick_width 	:= text_height;
		brick_height 	:= text_height - 1;

		// Найдем границу нужной области.
		need_height := Legend.Count * text_height + 2*border + 2*space;
		need_width := text_width + 2*border + 3*space + brick_width;

		r := Rect (Max (width-need_width, width-(width div 2)), 0,
			   width, Min (need_height, height)){"div 2" = 50%};
		Legend.DrawRect := r;
		InflateRect (r, -border, -border);
		DrawCanvas.Pen.Color := clBlack;
		DrawCanvas.Brush.Color := clWindow;
		DrawCanvas.FillRect (r);
		DrawCanvas.Rectangle (r);

		InflateRect (r, -space, -space);
		Legend.ItemsRect := r;

		text_shift := r.Left + space + brick_width;
		max_text_len := r.Right - text_shift;
		x := r.Left;
		for I := 0 to Legend.Count - 1 do
		begin
			item := Legend.Items[i];
			y := r.Top + (I * text_height);

			// хватает ли места на очередную строку?
			if (y+text_height > r.Bottom) then
				break;
			// рисуем метку.
			brick_rect := Rect (
				x, y, x + brick_width, y + brick_height );
			DrawCanvas.Brush.Color := item.Color;
			DrawCanvas.Rectangle (brick_rect);

			// рисуем текст.
			text_rect := Rect (text_shift, y,
				text_shift + max_text_len, y + text_height);
			DrawCanvas.Brush.Style := bsClear;
			MyTextRect (text_rect, text_rect.left, text_rect.top, item.Text);
		end;
	end;

	procedure DrawVerticalAxis;
	var
		A:Integer;
		B:Integer;
		Re,Re2,Re3:Extended;
		Two:Boolean;
		TR:TRect;
	begin {DrawCanvas}
		If (FGridStyle = gsNone) and (not FNumbVert) then
			Exit;

		DrawCanvas.Font := FontAxis;

		C:=DrawCanvas.TextHeight ('Xy');
		A:=Round(((XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1)*MaxVisRectLength)/C);
		{'A' now means maximum number of numbers in range 1..MaxVisRectLength}
		{Don't try to understand it :) }
		Re:=MaxVisRectLength;
		B:=1;
		Two:=True;
		while B<A do
		begin
			If Two then
			begin
				B:=B*2;
				If B<A then
					Re:=Re/2;
			end else
			begin
				B:=B*5;
				If B<A then
					Re:=Re/5;
			end;
			Two:=not Two;
		end;
		Re2:=FVisRect.Y1/Re;
		If Re2<=0 then
			Re2:=Trunc (Re2)*Re-Re
		else
			Re2:=Trunc (Re2)*Re+Re;
		Re3:=(XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1);

		DrawCanvas.Pen.Color:=FColorGrid;
		DrawCanvas.Font.Color:=FColorNumb;
		DrawCanvas.Pen.Style := psDot;
		C:=C div 2;
		TR.Left:=R.Left;
		TR.Top:=R.Top;
		TR.Right:=XGraphRect.Left;
		TR.Bottom:=XGraphRect.Bottom;
		DrawCanvas.Brush.Style:=bsClear;
		while Re2<=FVisRect.Y2 do
		{Warning: Should be probably '=' but then it sometimes does stange things}
		begin
			A:=Trunc((Re2-FVisRect.Y1)*Re3);
			If A>=0 then
			begin
				A:=XGraphRect.Bottom-A;
				If (FGridStyle=gsXAxis) OR (FGridStyle=gsAxises) OR
				   (FGridStyle=gsXGrid) OR (FGridStyle=gsFull) then
				begin
					If Abs(Re2)<0.00001 then
					{Warning : This depends on MinVisRectLength}
					{...this should be 0, but computer isn't 100% accurate}
					begin
						DrawCanvas.Pen.Color:=FColorAxis;
						DrawCanvas.MoveTo (XGraphRect.Left,A);
						DrawCanvas.LineTo (XGraphRect.Right+1,A);
						DrawCanvas.Pen.Color:=FColorGrid;
					end else
					begin
						If (FGridStyle=gsXGrid) OR (FGridStyle=gsFull) then
						begin
							DrawCanvas.MoveTo (XGraphRect.Left,A);
							DrawCanvas.LineTo (XGraphRect.Right+1,A);
						end;
					end;
				end;
				If NumbVert then
				begin
					DrawCanvas.Brush.Style:=bsClear;
					S:=FloatToStrF (Re2,ffFixed,16,Abs(Round(Log10(MinVisRectLength)))+1);
					B:=DrawCanvas.TextWidth (S);
					DrawCanvas.TextRect (TR,XGraphRect.Left-B-3,A-C,S);
				end;
			end;
			Re2:=Re2+Re;
		end;
	end;

	procedure DrawHorizontalAxis;
	var
		gr_step: Extended;
		TR:TRect;
		s: String;
		I: Integer;
		lab_count: Integer;
		w_labels: Integer;
		w_XGraphRect: Integer;
		w_FVisRect: qFloat;
		text_w: Integer;
		grid_start: qFloat;
		grid_step: qFloat;
		zoom_koef: qFloat;
		x: qFloat;
		scr_x: Integer;
		b: Boolean;
		t_x, t_y: Integer;
		ris: qFloat;
		ris_scr: Integer;
		ris_step: qFloat;
	begin
		If not NumbHoriz then
			Exit;

		DrawCanvas.Font := FontAxis;

	// Подберем сетку чтобы хорошо отображались подписи времени
		if (Abs (FVisRect.X2 - FVisRect.X1) > 1/72) then
			s := '___88:88___'
		else
			s := '___88:88:88___';
		text_w := DrawCanvas.TextWidth (S);

		w_XGraphRect := XGraphRect.Right-XGraphRect.Left;
		w_FVisRect   := FVisRect.X2 - FVisRect.X1;

		lab_count := (w_XGraphRect) div text_w;
		if (lab_count <> 0) then
			gr_step := Abs(w_FVisRect / lab_count)
		else
			gr_step := Abs(w_FVisRect);

		// Найдем подходящий шаг из имеющихся.
		I := 1;
		while I < High (time_steps) do
		begin
			if gr_step >= time_steps[I] then
				break;
			Inc (I);
		end;

		// Найдем ширину всех меток для подобранного шага
		w_labels := Round (text_w * w_FVisRect / time_steps[I]);
		if (w_labels > (XGraphRect.Right - XGraphRect.Left)) then
		begin	// Нужно ли уменьшить шаг, если они не вмещаются...
			if (I > 1) then
				Dec (I);
		end;
		grid_step := time_steps[I];
		ris_step := grid_step / 4;

		{C:=DrawCanvas.TextWidth (S);}
//		A:=Round(((XGraphRect.Right-XGraphRect.Left)/(FVisRect.X2-FVisRect.X1)*MaxVisRectLength)/text_h);

		// Найдем начальный шаг с которого подписывать сетку
		grid_start := FVisRect.X1 / grid_step;
		If grid_start <= 0 then
			grid_start := Trunc(grid_start) * grid_step - grid_step
		else
			grid_start := Trunc(grid_start) * grid_step + grid_step;

		zoom_koef := w_XGraphRect / w_FVisRect;

		TR.Left   := XGraphRect.Left;
		TR.Top    := XGraphRect.Bottom + 1;
		TR.Right  := XGraphRect.Right;
		TR.Bottom := Height;

		DrawCanvas.Pen.Color   	:= FColorGrid;
		DrawCanvas.Pen.Style 	:= psDot;
		DrawCanvas.Brush.Style 	:= bsClear;
		DrawCanvas.Font.Color	:= FColorNumb;

		b := (FGridStyle = gsYAxis) OR (FGridStyle = gsAxises) OR
			   (FGridStyle = gsYGrid) OR (FGridStyle = gsFull);
		b := b and ((FGridStyle=gsYGrid) OR (FGridStyle=gsFull));

		x := grid_start;
		while (x <= FVisRect.X2) do
		begin
			scr_x := Trunc ((x - FVisRect.X1) * zoom_koef);
			If scr_x < 0 then
			begin
				x := x + grid_step;
				Continue;
			end;

			scr_x := scr_x + XGraphRect.Left;
			If b then
			begin
				DrawCanvas.MoveTo (scr_x, XGraphRect.Top);
				DrawCanvas.LineTo (scr_x, XGraphRect.Bottom+1);
			end;
			If NumbHoriz then
			begin
				if grid_step >= 1 then
					s := DateToStr (x)
				else if grid_step > 1/1441 then
					s := FormatDateTime ('hh:nn', x)
				else
					s := FormatDateTime ('hh:nn:ss', x);

				text_w := DrawCanvas.TextWidth (s);
				if (scr_x + text_w div 2 <= TR.Right) and
				   (scr_x - text_w div 2 >= TR.Left)
				then
				begin
					t_x := scr_x - text_w div 2;
					t_y := XGraphRect.Bottom+4;
					DrawCanvas.TextRect (TR, t_x, t_y, S);
				end;
			end;
			x := x + grid_step;
		end;

		// Нарисуем штрихи.
		if (not b) then
			Exit;

		DrawCanvas.Pen.Style := psSolid;
		DrawCanvas.Pen.Color := FColorGrid;

		x := grid_start - grid_step;
		while (x <= FVisRect.X2) do
		begin
			scr_x := Trunc ((x - FVisRect.X1) * zoom_koef);
			scr_x := scr_x + XGraphRect.Left;
			for I := 0 to 3 do begin
				ris := (ris_step*I);
				ris_scr := Round(ris*zoom_koef);
				ris_scr := ris_scr + scr_x;
				if ris_scr < TR.Left then
					Continue;
				if ris_scr > TR.Right then
					break;
				{
				if (I = 0) then
					DrawCanvas.Pen.Color := clBlack;
				DrawCanvas.MoveTo (ris_scr, XGraphRect.Bottom+1);
				DrawCanvas.LineTo (ris_scr, XGraphRect.Bottom+4);
				if (I = 0) then
					DrawCanvas.Pen.Color := FColorGrid;
				}
				if (I = 0) then
				begin
					DrawCanvas.MoveTo (ris_scr, XGraphRect.Bottom+1);
					DrawCanvas.LineTo (ris_scr, XGraphRect.Bottom+6);
				end else
				begin
					DrawCanvas.MoveTo (ris_scr, XGraphRect.Bottom+1);
					DrawCanvas.LineTo (ris_scr, XGraphRect.Bottom+4);
				end;
			end;
			x := x + grid_step;
		end;
	end;

	function GetPitCaptionsWidth: Integer;
	var
		I: Integer;
		P: TPit;
		w_max: Integer;
		w: Integer;
		s: String;
	begin
		Result := 0;
		If not NumbVert then
			Exit;

		w_max := 0;
		for I := 0 to fPits.Count - 1 do
		begin
			P := fPits[I];
			if P.FDrawStyle = dsValues then
				s := '8,8888'
			else
				s := P.Caption;

			w := DrawCanvas.TextWidth (s);
			w_max := Max (w_max, w);
		end;
		Result := w_max;
	end;

	function DrawPitGrid (index: Integer): TRect;
	var
		P: TPit;
		s: String;
		r: TRect;
		ry, y1: qFloat;
	begin
		P := fPits[index];

		if P.FDrawStyle = dsRectangles then
		begin
			s := P.Caption;
		end;

		RY := (XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1);

		y1 := p.fYShift + p.fYHeight;

		r.Bottom := XGraphRect.Bottom - Trunc ((y1 - FVisRect.Y1)* RY);
		r.top := r.Bottom;
		r.left := XGraphRect.Left;
		r.Right := XGraphRect.Right;

		DrawCanvas.Pen.Color := FColorGrid;
		DrawCanvas.Pen.Style := psDot;
		DrawCanvas.Brush.Style 	:= bsClear;

		if (r.Top > XGraphRect.Top) and
		   (r.Bottom < XGraphRect.Bottom) then
		begin
			DrawCanvas.MoveTo (r.Left, r.Top);
			DrawCanvas.LineTo (r.Right, r.Top);
		end;

		if (index = 0) then
		begin
			r.Bottom := XGraphRect.Bottom - Trunc ((-FVisRect.Y1)* RY);
			if (r.Top > XGraphRect.Top) and
			   (r.Bottom < XGraphRect.Bottom) then
			begin
				DrawCanvas.MoveTo (r.Left, r.bottom);
				DrawCanvas.LineTo (r.Right, r.bottom);
			end;
		end;
		Result := r;
		Result.Bottom := XGraphRect.Bottom - Trunc ((p.fYShift - FVisRect.Y1)* RY);
	end;

	procedure DrawTextCaption (index: Integer);
	var
		s: String;
		P: TPit;
		w, h: Integer;
		ry: qFloat;
		c: Integer;
		y: qFloat;
		middle: Integer;
		y_top,
		y_bottom: Integer;
	begin
		P := Pits[index];

		if P.FDrawStyle = dsRectangles then
		begin
			s := P.Caption;
		end;

		w := DrawCanvas.TextWidth (s);
		h := DrawCanvas.TextHeight (s);
		c := h div 2;

		RY := (XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1);

		y := p.fYShift + p.fYHeight;

		y_top := XGraphRect.Bottom - Trunc ((y - FVisRect.Y1)* RY);
		y_bottom := XGraphRect.Bottom - Trunc ((p.fYShift - FVisRect.Y1)* RY);
		y_top := Max (y_top, XGraphRect.Top);
		y_bottom := Min (y_bottom, XGraphRect.Bottom);
		if (y_top > XGraphRect.Bottom) then
			Exit;
		if (y_bottom < XGraphRect.Top) then
			Exit;

		middle := y_top + (y_bottom - y_top) div 2;
		r.Bottom := middle+c;
		r.top := middle-c;
		r.Left := (XGraphRect.Left-w-3);
		r.Right := XGraphRect.Left;

		DrawCanvas.Brush.Style := bsClear;
		DrawCanvas.Pen.Color := clBlack;// self.FColorAxis;
		DrawCanvas.Pen.Style := psSolid;

		DrawCanvas.TextRect (r, r.Left , r.Top, S);

	end;

	procedure DrawValues (index: Integer);
		function GetFormattedStep (v: qFloat; st: qFloat): String;
		begin
			if      st < 0.0000001 then
				Result := Format ('%-.8f', [v])
			else if st < 0.000001 then
				Result := Format ('%-.7f', [v])
			else if st < 0.00001 then
				Result := Format ('%-.6f', [v])
			else if st < 0.0001 then
				Result := Format ('%-.5f', [v])
			else if st < 0.001 then
				Result := Format ('%-.4f', [v])
			else if st < 0.01 then
				Result := Format ('%-.3f', [v])
			else if st < 0.1 then
				Result := Format ('%-.2f', [v])
			else if st < 1 then
				Result := Format ('%-.1f', [v])
			else
				Result := Format ('%-.0f', [v]);
		end;
	var
		TR:TRect;
		P: TPit;
		text_h, text_w: Integer;
		lab_count: Integer;
		grid_step: qFloat;
		I: Integer;
		h_labels: Integer;
		grid_start: qFloat;
		zoom_koef, zoom_koef2: qFloat;
		b: Boolean;
		y: qFloat;
		scr_y: Integer;
		t_x, t_y: Integer;
	begin
		P := Pits[index];

		text_h := DrawCanvas.TextHeight ('Xy');
		if (text_h >= P.fHeight) then
			Exit;

		DrawCanvas.Font := FontAxis;

	// Подберем сетку чтобы хорошо отображались подписи времени
		lab_count := (p.fHeight) div text_h;
		if (lab_count <> 0) then
			grid_step := Abs(p.fMaxValue / lab_count)
		else
			grid_step := Abs(p.fMaxValue);

		// Найдем подходящий шаг из имеющихся.
		I := 1;
		while I < High (krug_steps) do
		begin
			if grid_step >= krug_steps[I] then
				break;
			Inc (I);
		end;

		// Найдем высоту всех меток для подобранного шага
		h_labels := Round (text_h * p.fMaxValue / krug_steps[I]);
		if (h_labels > (p.fHeight)) then
		begin	// Нужно ли увеличить шаг, если они не вмещаются...
			if (I > 1) then
				Dec (I);
		end;
		grid_step := krug_steps[I];

		// Найдем начальный шаг с которого подписывать сетку
		grid_start := grid_step;

		if (p.fMaxValue <> 0) then
			zoom_koef := p.fHeight / p.fMaxValue
		else
			zoom_koef := p.fHeight;
		zoom_koef2 := (XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1);

		TR.Left   := 1;
		TR.Top    := XGraphRect.Top;
		TR.Right  := XGraphRect.Left;
		//DrawCanvas.TextWidth (GetFormattedStep (grid_step, grid_step));
		TR.Bottom := XGraphRect.Bottom;

		DrawCanvas.Pen.Color   	:= FColorGrid;
		DrawCanvas.Pen.Style 	:= psDot;
		DrawCanvas.Brush.Style 	:= bsClear;
		DrawCanvas.Font.Color	:= FColorNumb;

		b := (FGridStyle = gsXAxis) OR (FGridStyle = gsAxises) OR
			   (FGridStyle = gsXGrid) OR (FGridStyle = gsFull);
		b := b and ((FGridStyle=gsXGrid) OR (FGridStyle=gsFull));

		y := grid_start;
		while (y <= p.fMaxValue) do	// TODO: + delta
		begin
			scr_y := Trunc (y * zoom_koef);
			scr_y := XGraphRect.Bottom
				- Trunc((p.fYShift-FVisRect.Y1)*zoom_koef2)
				- scr_y;
			if (scr_y <= XGraphRect.Top) or
			   (scr_y >= XGraphRect.Bottom) then
			begin
				y := y + grid_step;
				continue;
			end;
			If b then
			begin
				DrawCanvas.MoveTo (XGraphRect.Left, scr_y);
				DrawCanvas.LineTo (XGraphRect.Right+1, scr_y);
			end;
			If NumbHoriz then
			begin
				s := GetFormattedStep (y, grid_step);
				text_w := DrawCanvas.TextWidth (s);
				t_x := XGraphRect.Left - text_w - 4;
				t_y := scr_y - text_h div 2;
				DrawCanvas.TextRect (TR, t_x, t_y, S);
			end;
			y := y + grid_step;
		end;

		// Нарисуем штрихи.
		if (not b) then
			Exit;

		DrawCanvas.Pen.Style := psSolid;
		DrawCanvas.Pen.Color := FColorGrid;

		y := grid_start;
		while (y <= p.fMaxValue) do
		begin
			scr_y := Trunc (y * zoom_koef);
			scr_y := XGraphRect.Bottom
				- Trunc((p.fYShift-FVisRect.Y1)*zoom_koef2)
				- scr_y;
			if (scr_y <= XGraphRect.Top) or
			   (scr_y >= XGraphRect.Bottom) then
			begin
				y := y + grid_step;
				continue;
			end;
			DrawCanvas.MoveTo (XGraphRect.Left-5, scr_y);
			DrawCanvas.LineTo (XGraphRect.Left-1, scr_y);
			y := y + grid_step;
		end;
	end;

	procedure DrawPitsCaption;
	var
		P: TPit;
		I: Integer;
		h_text: Integer;
		need: Integer;
	begin
		h_text := DrawCanvas.TextHeight ('Xy');

		if (XGraphRect.Bottom - XGraphRect.Top < h_text) then
		begin
			Exit;
		end;

		need := 0;
		for I := 0 to fPits.Count - 1 do
		begin
			P := fPits[I];

			if p.FDrawStyle = dsValues then
				DrawValues (I);

			if need > 0 then
			begin
				need := need - p.fHeight;
				continue;
			end;
			{
			s := P.Caption;
			if (Length(s) = 0) then
			begin
				continue;
			end;
			}
			if p.FDrawStyle <> dsValues then
				DrawTextCaption (I);
//			else
//				DrawValues (I);
			need := h_text - p.fHeight;
		end;
	end;

	procedure DrawVerticalAxis2;
	var
		I: Integer;
		r: TRect;
	begin
		If not NumbVert then
			Exit;

		//if w = 0 then
		//	Exit;


		for I := 0 to fPits.Count - 1 do
		begin
			r := DrawPitGrid (I);
			fPits[I].fHeight := r.Bottom - r.Top;
//			DrawPitCaption (I, r);
		end;
		DrawPitsCaption;
	end;

	procedure DrawGridAndNumbers2;
	var
		w: Integer;
	begin
		If NumbVert then
		begin
			w := GetPitCaptionsWidth;
			Inc (XGraphRect.Left, w+4);
		end;
		If NumbHoriz then
			Dec (XGraphRect.Bottom, DrawCanvas.TextHeight ('Xy')+4);

		DrawVerticalAxis2;
		DrawHorizontalAxis;
		//DrawVerticalAxis;

		R:=XGraphRect;
		InflateRect(R,1,1);
		DrawBorder (FGraphBorder,FColorBorder);
	end;
begin
  DC:=GetDC (0);
  A:=GetDeviceCaps (DC,BITSPIXEL);
  ReleaseDC (0,DC);
  If ACanvas=nil then
  begin
    If A<>XLastBPP then
    begin
      XTempBmp.Free;
      XTempBmp:=TBitmap.Create;
      If XBgBmp<>nil then
      begin
	XBgBmp.Free;
        XBgBmp:=TBitmap.Create;
        XBgRedraw:=True;
      end;
      XLastBPP:=A;
    end;
    If Width<>XTempBmp.Width then
    begin
      XTempBmp.Width:=Width;
      If XBgBmp<>nil then
      begin
        XBgBmp.Width:=Width;
        XBgRedraw:=True;
      end;
    end;
    If Height<>XTempBmp.Height then
    begin
      XTempBmp.Height:=Height;
      If XBgBmp<>nil then
      begin
        XBgBmp.Height:=Height;
	XBgRedraw:=True;
      end;
    end;
    DrawCanvas:=XTempBmp.Canvas
  end
  else
    DrawCanvas:=ACanvas;
  If XBgRedraw then
  begin
    XBgRedraw:=False;
    If (XBgBmp=nil) then
    begin
      XBgBmp:=TBitmap.Create;
      XBgBmp.Width:=Width;
      XBgBmp.Height:=Height;
    end;
  end;
  If (ACanvas=nil) then
  begin
    If (FBgStyle=bgsSolid) OR
       (XBgBmp=nil) then
    begin
      with DrawCanvas do
      begin
	Brush.Color:=FColorBg;
        Brush.Style:=bsSolid;
        FillRect (Rect(0,0,Width,Height));
      end;
    end
    else
    begin
      If (FBgStyle=bgsImageStretch) OR
	 (FBgStyle=bgsImageTile) then
      begin
	If FBgImage='' then
        begin
          XBgBmp.Free;
          XBgBmp:=nil;
        end
	else
        begin
	  XBmp:=TBitmap.Create;
          try
            XBmp.LoadFromFile (FBgImage);
          except
            XBgBmp.Free;
	    XBGBmp:=nil;
          end;
          If XBgBmp<>nil then
          begin
	    If FBgStyle=bgsImageStretch then
              DrawCanvas.StretchDraw (Rect(0,0,XBgBmp.Width,XBgBmp.Height),XBmp)
	    else
            begin
              B:=0;
              while B<XTempBmp.Height do
              begin
		C:=0;
		while C<XTempBmp.Width do
                begin
                  DrawCanvas.Draw (C,B,XBmp);
		  Inc (C,XBmp.Width);
		end;
                Inc (B,XBmp.Height);
	      end;
            end;
            XBmp.Free;
          end;
        end;
      end
      else
        XTempBmp.Canvas.Draw (0,0,XBgBmp);
    end;
  end;

{  XBgBmp.LoadFromFile ('C:\!Vit\aplane.bmp');
  XTempBmp.Canvas.Draw (0,0,XBgBmp);}
  If ACanvas=nil then
    XRenderNeed:=False;
  R:=Rect(0,0,Width-1,Height-1);
  with XTempBmp.Canvas do
  begin
    DrawBorder (FBorderStyle,FColorBorder);
    XGraphRect:=R;

    DrawLegend;
    DrawCaption;

    If GraphBorder <> bstNone then
      InflateRect (XGraphRect,-1,-1);
    AdjustZoom (FVisRect);
	UpdateHeights;
    DrawGridAndNumbers2;
    R:=XGraphRect;

    Rgn := 0;
    try
      TempR:=Rect (R.Left,R.Top,R.Right+1,R.Bottom+1);
      If (TempR.Left <= TempR.Right) then
      begin
	Rgn:=CreateRectRgnIndirect (TempR);
	SelectClipRgn (DrawCanvas.Handle,Rgn);

	For A:=0 to FPits.Count-1 do
	begin
	  If FPits[A].Visible then
	  begin
	      Case FPits[A].DrawStyle of
{		dsLines:
		  begin
		    DrawBars (A);
		    If FPits[A].FPointSymbol <> #0 then
		      DrawPoints (A);
		  end;}
		dsValues, dsRectangles:
		  DrawBars2 (A);
	      end;
          end;
        end;
      end;
    finally
      SelectClipRgn (DrawCanvas.Handle,0);
      DeleteObject (Rgn);
    end;
  end; {with XTempBmp.Canvas}
end;


procedure TEasyGraph.SetGridStyle (AValue:TGridStyle);
begin
  If FGridStyle<>AValue then
  begin
    FGridStyle:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.Paint;
var RN:Boolean;
    DC:HDC;
begin
  If not XRenderNeed then
  begin
    If (XTempBmp.Width<>Width) OR (XTempBmp.Height<>Height) then
      XRenderNeed:=True
    else
    begin
      DC:=GetDC(0);
      If GetDeviceCaps (DC,BITSPIXEL)<>XLastBPP then
	XRenderNeed:=True;
      ReleaseDC (0,DC);
    end;
  end;
  RN:=XRenderNeed;
  If XRenderNeed then
  begin
    XTimeToDraw:=GetTickCount;
    Render (nil);
  end;
  Canvas.CopyRect (Canvas.ClipRect,XTempBmp.Canvas,Canvas.ClipRect);
  If RN then
    XTimeToDraw:=Integer(GetTickCount) - XTimeToDraw;
end;

procedure TEasyGraph.SetColorAxis (AValue:TColor);
begin
  If FColorAxis<>AValue then
  begin
    FColorAxis:=AValue;
    XRenderNeed:=True;
    If Assigned(OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetColorBg (AValue:TColor);
begin
  If FColorBg<>AValue then
  begin
    FColorBg:=AValue;
    XRenderNeed:=True;
    XBgRedraw:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetColorBg2 (AValue:TColor);
begin
  If FColorBg2<>AValue then
  begin
    FColorBg2:=AValue;
    XRenderNeed:=True;
    XBgRedraw:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetColorGrid (AValue:TColor);
begin
  If FColorGrid<>AValue then
  begin
    FColorGrid:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetColorBorder (AValue:TColor);
begin
  If FColorBorder<>AValue then
  begin
    FColorBorder:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetColorNumb (AValue:TColor);
begin
  If AValue<>FColorNumb then
  begin
    FColorNumb:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetGraphBorder (AValue:TBorderStyle);
begin
  If FGraphBorder<>AValue then
  begin
    FGraphBorder:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;
                            
procedure TEasyGraph.SetNumbHoriz (AValue:Boolean);
begin
  If FNumbHoriz<>AValue then
  begin
    FNumbHoriz:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetNumbVert (AValue:Boolean);
begin
  If FNumbVert<>AValue then
  begin
    FNumbVert:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.PitsChange (Sender:TObject);
begin
  XRenderNeed:=True;
  If Assigned(OnChange) then
    OnChange (Self);
  If (XUpdateCounter = 0) then
    Invalidate;
end;

function TEasyGraph.GetLegendHint (X, Y: Integer): String;
var
	item: TLegendItem;
	I: Integer;
begin
	Result := '';

	if not PtInRect (fLegend.ItemsRect, Point(X, Y)) then
		Exit;

	Y := Y - Legend.ItemsRect.Top;
	I := Y div Legend.TextHeight;
	if (0 <= I) and (I < Legend.Count) then
	begin
		item := TLegendItem (Legend.Items[I]);
		if Length (item.Hint) = 0 then
			Result := item.Text
		else
			Result := item.Hint;
	end;
end;

procedure TEasyGraph.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
begin
  inherited MouseDown (Button,Shift,X,Y);
  If XMouseAction<>0 then
    Exit;

	if (fLegend <> nil) and PtInRect (fLegend.ItemsRect, Point (X, Y)) then
	begin	// Координаты мыши в легенде.?
		Hint := GetLegendHint (X, Y);
		Exit;
	end;

  XMousePointsMove:=0;
  If (XZoomThread=nil) AND (PtInRect (XGraphRect,Point(X,Y))) AND
     (XMouseAction=0) then
  begin
    If ((Button=mbRight) AND (FMouseFuncHint=maRight)) OR
       ((Button=mbLeft) AND (
	((ssAlt in Shift) AND (FMouseFuncHint=maAlt)) OR
	((ssCtrl in Shift) AND (FMouseFuncHint=maCtrl)) OR
	((ssShift in Shift) AND (FMouseFuncHint=maShift)))) then
      {Activate showing hint?}
    begin
      XMouseAction:=8;
      XMousePos:=Point(X,Y);
//      XHintForm.Show;
      CalculateHint;
      XWnd:=AllocateHWnd (MyWndProc);
      SetCapture (XWnd);
      Exit;
    end;
    If ((Button=mbRight) AND (FMouseZoom=maRight)) OR
       ((Button=mbLeft) AND (
	((ssAlt in Shift) AND (FMouseZoom=maAlt)) OR
	((ssCtrl in Shift) AND (FMouseZoom=maCtrl)) OR
	((ssShift in Shift) AND (FMouseZoom=maShift)))) then
      {Activate zoom out?}
    begin
      XMouseAction:=1;
    end;
    If ((Button=mbRight) AND (FMousePan=maRight)) OR
       ((Button=mbLeft) AND (
        ((ssAlt in Shift) AND (FMousePan=maAlt)) OR
        ((ssCtrl in Shift) AND (FMousePan=maCtrl)) OR
        ((ssShift in Shift) AND (FMousePan=maShift)))) then
      {Activate moving?}
    begin
      XMouseAction:=XMouseAction OR 2;
      XMousePos:=Point (X,Y);
    end;
    If (Button=mbLeft) AND (XMouseAction=0) AND (FMouseZoom<>maNone) then
      {Activate zoom in?}
    begin
      XMouseAction:=4;
      XLastZoomR:=Rect (X,Y,X,Y);
    end;
  end;
end;

procedure TEasyGraph.MouseMove(Shift: TShiftState; X, Y: Integer);
var X2,Y2:Integer;
    R:Extended;
{    P:TPoint;}
begin
  Inc (XMousePointsMove);
  Hint := GetLegendHint (X, Y);
  If (XMouseAction AND 2=2) AND (XMousePointsMove>=MinMousePointsMove) then
    {moving}
  begin
    If (FMousePan=maRight) AND not (ssRight in Shift) then
      XMouseAction:=0
    else
    begin
	// Panning
{      P:=ClientToScreen (Point(XMousePos.X,XMousePos.Y));
      SetCursorPos (P.X,P.Y);}
      XMouseAction:=2;
      R:=(FVisRect.X2-FVisRect.X1)/(XGraphRect.Right-XGraphRect.Left);
      FVisRect.X1:=FVisRect.X1-(X-XMousePos.X)*R;
      FVisRect.X2:=FVisRect.X2-(X-XMousePos.X)*R;
      R:=(FVisRect.Y2-FVisRect.Y1)/(XGraphRect.Bottom-XGraphRect.Top);
      FVisRect.Y1:=FVisRect.Y1+(Y-XMousePos.Y)*R;
      FVisRect.Y2:=FVisRect.Y2+(Y-XMousePos.Y)*R;
      XRenderNeed:=True;
      XMousePos:=Point(X,Y);
      If Assigned(FOnVisChange) then
	FOnVisChange (Self);
      Paint;
    end;
  end;
  If XMouseAction=4 then
    {zooming in}
  begin
    LineRect (XLastZoomR.Left,XLastZoomR.Top,XLastZoomR.Right,XLastZoomR.Bottom);
    X2:=X;
    Y2:=Y;
    If X2<XGraphRect.Left then
      X2:=XGraphRect.Left;
    If X2>XGraphRect.Right then
      X2:=XGraphRect.Right;
    If Y2<XGraphRect.Top then
      Y2:=XGraphRect.Top;
    If Y2>XGraphRect.Bottom then
      Y2:=XGraphRect.Bottom;
    XLastZoomR.Right:=X2;
    XLastZoomR.Bottom:=Y2;
    LineRect (XLastZoomR.Left,XLastZoomR.Top,X2,Y2);
  end;
  if (ssLeft in Shift) and (ssShift in Shift) then
	CalculateHint
  else
  begin
	if (Hint <> tipOfTheUsing) then
		Hint := tipOfTheUsing;
  end;
  inherited MouseMove (Shift,X,Y);
end;

procedure TEasyGraph.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
var R:Extended;
    ToRect:TRect2D;
begin
  If (XMouseAction=4) then
    {zooming in}
  begin
    LineRect (XLastZoomR.Left,XLastZoomR.Top,XLastZoomR.Right,XLastZoomR.Bottom);
{    If (XLastZoomR.Left<>XLastZoomR.Right) AND (XLastZoomR.Top<>XLastZoomR.Bottom) then}
    If (Button=mbLeft) then
      GraphZoom;
  end;
  If (XMouseAction and 1 = 1) AND (XMousePointsMove<MinMousePointsMove) then
    {zooming out}
  begin
    R:=(FVisRect.X2-FVisRect.X1)/2;
    ToRect.X1:=FVisRect.X1-R;
    ToRect.X2:=FVisRect.X2+R;
    R:=(FVisRect.Y2-FVisRect.Y1)/2;
    ToRect.Y1:=FVisRect.Y1-R;
    ToRect.Y2:=FVisRect.Y2+R;
    If FZoomTime<=0 then
    begin
      FVisRect:=ToRect;
      XRenderNeed:=True;
      If Assigned (FOnVisChange) then
        FOnVisChange (Self);      
      Paint;
    end
    else
      XZoomThread:=TZoomThread.Create (Self,FVisRect,ToRect,FZoomTime,XTimeToDraw);
  end;
  XMouseAction:=0;
  inherited MouseUp (Button,Shift,X,Y);
end;

procedure TEasyGraph.LineRect (X1,Y1,X2,Y2:Integer);
var A:Integer;
begin
  Canvas.Pen.Style:=psSolid;
  Canvas.Pen.Mode:=pmXor;
  Canvas.Pen.Color:=clWhite;
  Canvas.Brush.Style:=bsClear;
  If X1>X2 then
  begin
    A:=X1;
    X1:=X2;
    X2:=A;
  end;
  If Y1>Y2 then
  begin
    A:=Y1;
    Y1:=Y2;
    Y2:=A;
  end;
  Canvas.Rectangle (X1,Y1,X2+1,Y2+1);
end;

procedure TEasyGraph.FitToWindow;
var
        ToRect: TRect2D;
        RX, RY: Extended;
begin
	if (fPits.Count = 0) then
	begin	// для правильного отображения масштаба при отсутствии данных
		fMaxRect.X1 := 0;
		fMaxRect.Y1 := 0;
		fMaxRect.X2 := 0.9;
		fMaxRect.Y2 := 1;
	end;

        RX := (fMaxRect.X2-fMaxRect.X1) / 100 * 5; // 5% для удобства
	ToRect.X1 := fMaxRect.X1 - RX;
        ToRect.X2 := fMaxRect.X2 + RX;
        RY := (fMaxRect.Y2-fMaxRect.Y1) / 100 * 5; 	// 5% для удобства
        ToRect.Y1 := fMaxRect.Y1 - RY;
        ToRect.Y2 := fMaxRect.Y2 + RY;

	AdjustZoom (ToRect);
	fVisRect := ToRect;
	XRenderNeed := True;
	Paint;
end;

procedure TEasyGraph.GraphZoom;
var ToRect:TRect2D;
    R:Extended;
    X:Integer;
    back: Boolean;
begin
	back := false;
  If (XLastZoomR.Right=XLastZoomR.Left) OR (XLastZoomR.Top=XLastZoomR.Bottom) then
  begin
    R:=(FVisRect.X2-FVisRect.X1)/4;
    ToRect.X1:=FVisRect.X1+R;
    ToRect.X2:=FVisRect.X2-R;
    R:=(FVisRect.Y2-FVisRect.Y1)/4;
    ToRect.Y1:=FVisRect.Y1+R;
    ToRect.Y2:=FVisRect.Y2-R;
  end
  else
  begin
    If XLastZoomR.Right<XLastZoomR.Left then
    begin
      X:=XLastZoomR.Left;
      XLastZoomR.Left:=XLastZoomR.Right;
      XLastZoomR.Right:=X;
      back := True;
    end;
    If XLastZoomR.Bottom<XLastZoomR.Top then
    begin
      X:=XLastZoomR.Top;
      XLastZoomR.Top:=XLastZoomR.Bottom;
      XLastZoomR.Bottom:=X;
      back := True;
    end;
    if back then begin
      R := (fMaxRect.X2-fMaxRect.X1) / 100 * 5; // 5% для удобства
      ToRect.X1 := fMaxRect.X1 - R;
      ToRect.X2 := fMaxRect.X2 + R;
      R := (fMaxRect.Y2-fMaxRect.Y1) / 100 * 5; 	// 5% для удобства
      ToRect.Y1 := fMaxRect.Y1 - R;
      ToRect.Y2 := fMaxRect.Y2 + R;


      if ((Abs(fMaxRect.X2) = MaxInt) or (Abs(fMaxRect.X1) = MaxInt)) or
	 ((Abs(fMaxRect.Y2) = MaxInt) or (Abs(fMaxRect.Y1) = MaxInt))
	then
		ToRect := Rect2D (0, 0, MaxVisRectLength/2, MaxVisRectLength/2);
    end else
    begin
      R:=(FVisRect.X2-FVisRect.X1)/(XGraphRect.Right-XGraphRect.Left);
      ToRect.X1:=(XLastZoomR.Left-XGraphRect.Left)*R+FVisRect.X1;
      ToRect.X2:=(XLastZoomR.Right-XGraphRect.Left)*R+FVisRect.X1;
      R:=(FVisRect.Y2-FVisRect.Y1)/(XGraphRect.Bottom-XGraphRect.Top);
      ToRect.Y1:=(XGraphRect.Bottom-XLastZoomR.Bottom)*R+FVisRect.Y1;
      ToRect.Y2:=(XGraphRect.Bottom-XLastZoomR.Top)*R+FVisRect.Y1;
    end;
  end;
  AdjustZoom (ToRect);
//  If ((ToRect.X2-ToRect.X1)<(FVisRect.X2-FVisRect.X1)) OR
//     ((ToRect.Y2-ToRect.Y1)<(FVisRect.Y2-FVisRect.Y1)) then
//  begin
    If FZoomTime<=0 then
    begin
      FVisRect:=ToRect;
      XRenderNeed:=True;
      If Assigned(FOnVisChange) then
	FOnVisChange (Self);
      Paint;
    end
    else
      XZoomThread:=TZoomThread.Create (Self,FVisRect,ToRect,FZoomTime,XTimeToDraw);
//  end;
end;

procedure TEasyGraph.AdjustZoom (var R:TRect2D);
var Rl,Rl2:Extended;
begin
  If R.X2-R.X1<MinVisRectLength then
  begin
    Rl:=(MinVisRectLength-(R.X2-R.X1))/2;
    R.X1:=R.X1-Rl;
    R.X2:=R.X2+Rl;
  end
  else
  begin
    If R.X2-R.X1>MaxVisRectLength then
    begin
      Rl:=((R.X2-R.X1)-MaxVisRectLength)/2;
      R.X1:=R.X1+Rl;
      R.X2:=R.X2-Rl;
    end
  end;
  If R.Y2-R.Y1<MinVisRectLength then
  begin
    Rl:=(MinVisRectLength-(R.Y2-R.Y1))/2;
    R.Y1:=R.Y1-Rl;
    R.Y2:=R.Y2+Rl;
  end
  else
  begin
    If R.Y2-R.Y1>MaxVisRectLength then
    begin
      Rl:=((R.Y2-R.Y1)-MaxVisRectLength)/2;
      R.Y1:=R.Y1+Rl;
      R.Y2:=R.Y2-Rl;
    end;
  end;

  If FMaintainRatio then
  begin
    Rl:=(R.X2-R.X1)/(R.Y2-R.Y1);
    Rl2:=((XGraphRect.Right-XGraphRect.Left)/(XGraphRect.Bottom-XGraphRect.Top))*FAspectRatio;
    If Rl2<Rl then
    begin
      Rl:=((R.X2-R.X1)/Rl2-(R.Y2-R.Y1))/2;
      R.Y1:=R.Y1-Rl;
      R.Y2:=R.Y2+Rl;
    end
    else
      If Rl2>Rl then
      begin
	Rl:=((R.Y2-R.Y1)*Rl2-(R.X2-R.X1))/2;
	R.X1:=R.X1-Rl;
	R.X2:=R.X2+Rl;
      end;
  end;
//  fCurrentZoom := ((R.X2 - R.X1) / (R.Y2 - R.Y1));
	if (fMaxRect.X1 = MaxInt) and (fMaxRect.X2 = -MaxInt) then
		fCurrentZoom := 100/((R.X2 - R.X1) / (1/2))
	else
		fCurrentZoom := 100/((R.X2 - R.X1) / (fMaxRect.X2 - fMaxRect.X1));
end;



procedure TEasyGraph.CalculateHint;
{
var P:TPoint;
var A,B,C,D:Integer;
    SecondPass:Bool;
    X,YExt:Extended;
 }
(*
  function GetFXAtPoint (S,X:Integer):Integer;
  var E,RX:Extended;
      A,G,H:Integer;
  begin
    If Series[S].Func='' then
    begin
      E:=FVisRect.X1+(FVisRect.X2-FVisRect.X1)/(XGraphRect.Right-XGraphRect.Left)*(X-XGraphRect.Left);
      If Series[S].Count=0 then
	Result:=-1000000
      else
      begin
        If Series[S].Count<2 then
        begin
          Result:=-1000000;
          Exit;
	end;
        A:=0;
	while A<Series[S].Count do
	begin
          If not (Series[S].Points[A].X<E) then
            break;
          Inc (A);
	end;
        If A=0 then
	  A:=1;
        If A=Series[S].Count then
	  Dec (A);
        with Series[S] do
	begin
          RX:=(XGraphRect.Right-XGraphRect.Left)/(FVisRect.X2-FVisRect.X1);
          G:=XGraphRect.Left+Round((Points[A-1].X-FVisRect.X1)*RX);
          H:=XGraphRect.Left+Round((Points[A].X-FVisRect.X1)*RX);
          If (G+1>=X) AND (H-1<=X) AND
             ( ((Points[A-1].Y>=YExt) AND (Points[A].Y<=YExt)) OR
               ((Points[A-1].Y<=YExt) AND (Points[A].Y>=YExt))) then
	  begin
             SecondPass:=True;
	     Result:=0;
          end
          else
          begin
            E:=Points[A-1].Y+
		 (Points[A].Y-Points[A-1].Y)/(Points[A].X-Points[A-1].X)*(E-Points[A-1].X);
	    Result:=Round(XGraphRect.Bottom-(XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1)*(E-FVisRect.Y1));
	  end;
        end;
      end;
    end
    else
    begin
      XParser.X:=FVisRect.X1+(FVisRect.X2-FVisRect.X1)/(XGraphRect.Right-XGraphRect.Left)*(X-XGraphRect.Left);
      try
	XParser.Expression:=Series[S].XParseFunc;
        E:=XParser.Value;
        If XParser.CalcError then
          Result:=-1000000
        else
          Result:=Round(XGraphRect.Bottom-(XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1)*(E-FVisRect.Y1));
      except
        Result:=-1000000;
      end;
    end;
  end;

  function PtBetween (Z,C,D:Integer):Boolean;
  begin
    If SecondPass then
      Result:=True
    else
      If C<D then
	Result:=(Z+3>C) AND (Z-3<D)
      else
        Result:=(Z+3>D) AND (Z-3<C);
  end;

  // This function is from Delphi 3\Source\VCL\Forms.pas
  function GetCursorHeightMargin: Integer;

  begin
    Result := GetSystemMetrics(SM_CYCURSOR);
  end;

*)
var
	I, J: Integer;
	gannt: TGannt;
	m_x, m_y: Integer;
begin
	Hint := '';

	m_x := XMousePos.X;
	m_y := XMousePos.Y;

	if (fLegend <> nil) and PtInRect (fLegend.ItemsRect, XMousePos) then
	begin	// Координаты мыши в легенде.?
		Hint := GetLegendHint (XMousePos.X, XMousePos.Y);
		Exit;
	end;

// Координаты мыши в сетке с данными
	if (m_x < XGraphRect.Left) or (m_x > XGraphRect.Right)
	or (m_y < XGraphRect.Top) or (m_y > XGraphRect.Bottom) then
	begin
		Hint := '';
		Exit;
	end;

	// Найдем нужный пит в котором ищем координаты нужного блока.
	for I := 0 to Pits.Count - 1 do
	begin
		for J := fPits[I].Count-1 downto 0 do
		begin
			gannt := fPits[I].FRects[J];
//			if (gannt.DrawRect.Right < m_x) then
//				break;
//			if (gannt.DrawRect.Left > m_x) then
//				continue;
			if (gannt.DrawRect.Top <= m_y)
			and (m_y <= gannt.DrawRect.Bottom)
			and (gannt.DrawRect.Left <= m_x)
			and (m_x <= gannt.DrawRect.Right) then
			begin
				//TODO:
//				Hint := gannt.Hint;
				if Assigned (fOnMouseHint) then
					fOnMouseHint (self, gannt.Tag);
				Exit;
			end;
		end;
	end;
{
	shift_y := 0;
	pit_index := -1;
	for I := 0 to Pits.Count - 1 do
	begin
		pit_index := I;
		Inc (shift_y, fPits[I].fHeight);
		if (shift_y > m_y) then
			break;
	end;
	if (pit_index = -1) then
		Exit;

	for I := 0 to fPits[pit_index].Count-1 do
	begin
		gannt := fPits[pit_index].FRects[I];
		if (gannt.DrawRect.Right > m_y) then
			break;
		if (gannt.DrawRect.Right < m_y) then
			continue;
		if (gannt.DrawRect.Left <= m_y) and
		   (m_y <= gannt.DrawRect.Right) then
		begin
			if (gannt.DrawRect.Bottom <= m_x) and
			   (m_x <= gannt.DrawRect.Top) then
			begin
				Hint := gannt.Hint;
			end;
		end;
	end;
}
{
	if (Length (Hint) = 0) then
	begin
	If (GetGraphCoords (XMousePos.X, XMousePos.Y, @X, @YExt) = False) then
		Exit;
	Hint := TimeToStr (X) + ', ' + FloatToSTr (YExt);
	Randomize;
	end;
}
(*
  P:=Self.ClientToScreen(Point(0,0));
  with XHintForm do
  begin
    If (GetGraphCoords (XMousePos.X, XMousePos.Y, @X, @YExt) = False) then
      Exit;

    If (Assigned (FOnXLabeling)) then
    begin
      XX := '';
      FOnXLabeling (self, X, XX);
    end
    else
      XX := FloatToStrF (X,ffFixed,15,4);

    YExt:=FVisRect.Y1+(FVisRect.Y2-FVisRect.Y1)/(XGraphRect.Bottom-XGraphRect.Top)*(XGraphRect.Bottom-XMousePos.Y);

    If (Assigned (FOnYLabeling)) then
    begin
      XY := '';
      FOnYLabeling (self, YExt, XY);
    end
    else
      XY:=FloatToStrF (YExt,ffFixed,15,4);

    XDisplaySeries:=False;
    For A:=0 to Series.Count-1 do
    begin
      If Series[A].Visible then
      begin
        C:=GetFXAtPoint (A,XMousePos.X-2);
        For B:=XMousePos.X-1 to XMousePos.X+2 do
        begin
          SecondPass:=False;
	  D:=GetFXAtPoint (A,B);
          If (D<>-1000000) AND (C<>-1000000) then
          begin
            If PtBetween (XMousePos.Y,C,D) then
            begin
              XColor:=Series[A].Color;
              If (Series[A].Func <> '') then
                XFunction := Series[A].Func
              else
		XFunction := Series[A].Caption;
              XDisplaySeries:=True;
              Break;
	    end;
	  end;
          C:=D;
        end;
        If XDisplaySeries then
          break;
      end;
    end;
    Render;
    Paint;
    SetBounds (P.X+XMousePos.X,P.Y+XMousePos.Y+GetCursorHeightMargin+5,Width,Height);
  end;
*)
end;

procedure TEasyGraph.SaveAsBmp (FileName:String);
var Pic:TPicture;
begin
  If XRenderNeed then
    Render (nil);
  Pic:=TPicture.Create;
  try
    Pic.Bitmap.Assign (XTempBmp);
    Pic.SaveToFile (FileName);
  finally
    Pic.Free;
  end;
end;

procedure TEasyGraph.ToBMP (var bmp:TBitmap);
begin
	if (bmp = nil) then
		Exit;

	if (bmp <> nil) then
		Render (bmp.Canvas);
end;

//TODO: чтоб печаталась
procedure TEasyGraph.Print;
var
	MetaFile, MFile: 		TMetaFile;
	MFCanvas: 	TMetaFileCanvas;
//	AData: 		THandle;
//	APalette:	HPALETTE;
//	AFormat:	Word;
	Bitmap: TBitmap;
begin
(*
    with Printer do
    begin
      BeginDoc;
      Printer.Width := Width;
      Printer.Canvas. Height := Height;
      Render (Printer.Canvas);
      EndDoc;
    end;
*)
(*
//	MFile := TMetaFile.Create;
//	MFile.Width  := Width;
	MFile.Height := Height;
	try
		MFCanvas := TMetaFileCanvas.Create (MFile,0);
		try
			Render (MFCanvas);
		finally
			MFCanvas.Free;
		end;
		MFile.  PrintTo Printer
		MFile.SaveToClipboardFormat (AFormat, AData, APalette);
		ClipBoard.SetAsHandle (AFormat, AData);
	finally
		MFile.Free;
	end;
*)
	MetaFile := TMetaFile.Create;
	Bitmap := TBitmap.Create;
	try
		Bitmap.Width := Screen.Width;
		Bitmap.Height := Screen.Height;
		Render (Bitmap.Canvas);
		with MetaFile do
		begin
			Height := Bitmap.Height;
			Width := Bitmap.Width;
			Canvas.Draw(0, 0, Bitmap);
			//SaveToFile(WMFFileName);
			Printer.BeginDoc;
//			Printer.Canvas.Draw (0, 0, MetaFile);
			Printer.Canvas.StretchDraw (Rect (0, 0, Printer.PageWidth*100, Printer.PageHeight*100), MetaFile);
			Printer.EndDoc;
		end;
	finally
		Bitmap.Free;
		MetaFile.Free;
	end;

	Exit;
	MFile := TMetaFile.Create;
//	MFile.Width  := Printer.PageWidth;//Width;
//	MFile.Height := Printer.PageHeight;//Height;
//	MFile.MMHeight := 1;
//	MFile.MMWidth := 1;
	try
		MFCanvas := TMetaFileCanvas.Create (MFile, Printer.Handle);
		try
			Render (MFCanvas);
		finally
			MFCanvas.Free;
		end;
		Printer.BeginDoc;
//		Printer.Canvas.Draw (0, 0, MFile);
		Printer.Canvas.StretchDraw (Rect (0, 0, Printer.PageWidth*100, Printer.PageHeight*100), MFile);
		Printer.EndDoc;

//		Printer.PageHeight
//		MFile.SaveToClipboardFormat (AFormat, AData, APalette);
//		ClipBoard.SetAsHandle (AFormat, AData);
	finally
		MFile.Free;
	end;
end;

procedure TEasyGraph.CopyToClipboard;
var MFile:TMetaFile;
    MFCanvas:TMetaFileCanvas;
    AData:THandle;
    APalette:HPALETTE;
    AFormat:Word;
begin
  MFile:=TMetaFile.Create;
  MFile.Width:=Width;
  MFile.Height:=Height;
  try
    MFCanvas:=TMetaFileCanvas.Create (MFile,0);
    try
      Render (MFCanvas);
    finally
      MFCanvas.Free;
    end;
    MFile.SaveToClipboardFormat (AFormat, AData, APalette);
    ClipBoard.SetAsHandle (AFormat, AData);
  finally
    MFile.Free;
  end;
end;

{$IFDEF Allow_SavetoJPEG_Func}
procedure TEasyGraph.SaveAsJpeg (FileName:String);
var Pic:TJPEGImage;
begin
  If XRenderNeed then
    Render (nil);
  Pic:=TJPEGImage.Create;
  try
    Pic.Assign (XTempBmp);
    Pic.SaveToFile (FileName);
  finally
    Pic.Free;
  end;
end;
{$ENDIF}


function TEasyGraph.GetGraphCoords (X, Y:Integer; GX, GY:PExtended):Boolean;
var P:TPoint;
begin
  P.X := X;
  P.Y := Y;
  If not PtInRect (XGraphRect, P) then
  begin
    Result := False;
    Exit;
  end;

  GX^ := FVisRect.X1+(FVisRect.X2-FVisRect.X1)/(XGraphRect.Right-XGraphRect.Left)*(X-XGraphRect.Left);
  GY^ := FVisRect.Y1+(FVisRect.Y2-FVisRect.Y1)/(XGraphRect.Bottom-XGraphRect.Top)*(XGraphRect.Bottom-Y);
  Result := True;
end;


procedure TEasyGraph.BeginUpdate;
begin
  Inc (XUpdateCounter);
end;


procedure TEasyGraph.EndUpdate;
begin
  If (XUpdateCounter <= 1) then
  begin
    XUpdateCounter := 0;
    Paint;
    Exit;
  end;
  Dec (XUpdateCounter);
end;

procedure TEasyGraph.Add (pit: Integer; time1, time2: TDateTime; height: qFloat;
	align: TGanntAlign; color: TColor; tag: Integer);
begin
	while (pit >= Pits.Count) do
		Pits.Add;
	Pits[pit].Add (time1, time2, height, align, color, tag);
	fMaxRect.X1 := Min (fMaxRect.X1, time1);
	fMaxRect.X2 := Max (fMaxRect.X2, time2);
	fMaxRect.Y1 := 0;
	fMaxRect.Y2 := 1;
end;

procedure TEasyGraph.Clear;
begin
	if (fPits <> nil) then
		fPits.Clear;
	fMaxRect.X1 := MaxInt;
	fMaxRect.X2 := -MaxInt;
	fMaxRect.Y1 := MaxInt;
	fMaxRect.Y2 := -MaxInt;
end;

{*****************************************}
{*****************************************}
{*             TZoomThread               *}
{*****************************************}
{*****************************************}

constructor TZoomThread.Create (AGraph:TEasyGraph;ANowRect,AToRect:TRect2D;AZoomTime,ATimeToDraw:Integer);
begin
  inherited Create (False);
  FreeOnTerminate:=True;
  Graph:=AGraph;
  NowRect:=ANowRect;
  ToRect:=AToRect;
  ZoomTime:=AZoomTime;
  TimeToDraw:=ATimeToDraw;
end;

procedure TZoomThread.Execute;
var RX1,RX2,RY1,RY2:Extended;
    NowTime,T:Integer;
    ZoomEnd:Boolean;
    FirstRect:TRect2D;
begin
  ZoomEnd:=False;
  RX1:=(ToRect.X1-NowRect.X1)/ZoomTime;
  RX2:=(ToRect.X2-NowRect.X2)/ZoomTime;
  RY1:=(ToRect.Y1-NowRect.Y1)/ZoomTime;
  RY2:=(ToRect.Y2-NowRect.Y2)/ZoomTime;
  NowTime:=TimeToDraw;
  FirstRect:=NowRect;
  while (not ZoomEnd) AND (not Terminated) do
  begin
    If Terminated then
      break;
    T:=GetTickCount;
    If NowTime>=ZoomTime then
    begin
      ZoomEnd:=True;
      NowTime:=ZoomTime;
    end;
    NowRect.X1:=FirstRect.X1+NowTime*RX1;
    NowRect.X2:=FirstRect.X2+NowTime*RX2;
    NowRect.Y1:=FirstRect.Y1+NowTime*RY1;
    NowRect.Y2:=FirstRect.Y2+NowTime*RY2;
    Synchronize (DrawGraph);
    Inc (NowTime,Integer(GetTickCount) - T);
  end;
  If not Terminated then
    Graph.XZoomThread:=nil
  else
    FreeOnTerminate:=False;
end;

procedure TZoomThread.DrawGraph;
begin
  If not Terminated then
  begin
    Graph.FVisRect:=NowRect;
    Graph.XRenderNeed:=True;
    If Assigned(Graph.FOnVisChange) then
      Graph.FOnVisChange (Graph);
    Graph.Paint;
  end;
end;

procedure TEasyGraph.Zoom (ZoomFactor: qFloat);
var
	R: TRect2D;
	W, H: qFloat;
	CX, CY: qFloat;
	NX, NY: qFloat;
	X, Y, X1, X2, Y1, Y2: qFloat;
begin
	if (fPits.Count = 0) then
	begin	// для правильного отображения масштаба при отсутствии данных
		fMaxRect.X1 := 0;
		fMaxRect.Y1 := 0;
		fMaxRect.X2 := 0.5/ZoomFactor;
		fMaxRect.Y2 := 1;
	end;
	// середина картинки
	CX := fVisRect.X1 + (fVisRect.X2-fVisRect.X1)/2;
	CY := fVisRect.Y1 + (fVisRect.Y2-fVisRect.Y1)/2;

	W := (fMaxRect.X2 - fMaxRect.X1) / 2;
	H := (fMaxRect.Y2 - fMaxRect.Y1) / 2;

	R.X1 := CX - W / ZoomFactor;
	R.X2 := CX + W / ZoomFactor;
	R.Y1 := CY - H * 1; 	// + 5% чтобы картинка не "прилипала"
	R.Y2 := CY + H * 1;	// к краям области
				// 1 - потому подстраиваем высоту под
				// плотное заполнение экрана

// Делаем так чтобы в новой области был хотя бы кусочек с данными

	// Центр новой области просмотра
	NX := R.X1 + (R.X2 - R.X1) / 2;
	NY := R.Y1 + (R.Y2 - R.Y1) / 2;

	if (NX < fMaxRect.X1) or (fMaxRect.X2 < NX) then
	begin
		X1 := NX - fMaxRect.X1;
		X2 := NX - fMaxRect.X2;
		if (Abs(X1) <= Abs(X2)) then
			X := X1
		else
			X := X2;
		R.X1 := R.X1 - X;
		R.X2 := R.X2 - X;
	end;
	if (NY < fMaxRect.Y1) or (fMaxRect.Y2 < NY) then
	begin
		Y1 := NY - fMaxRect.Y1;
		Y2 := NY - fMaxRect.Y2;
		if (Abs(Y1) <= Abs(Y2)) then
			Y := Y1
		else
			Y := Y2;
		R.Y1 := R.Y1 - Y;
		R.Y2 := R.Y2 - Y;
	end;

	AdjustZoom (R);
	fVisRect := R;
//	XLastZoomR := R;
//	GraphZoom;
	XRenderNeed := True;
//	Invalidate;
	Paint;
//	Invalidate;
//	If Assigned (OnChange) then
//		OnChange (Self);
end;

// Обновляет в соответствии c видимым окном размеры полос.
// Все полосы умещаются в координатах области в ограничения 0..1 и по X и по Y
procedure TEasyGraph.UpdateHeights;
var
	I, J: Integer;
	AreaH: Integer;
	H: Integer;
	cntFree: Integer;
	fix_percent: Integer;
	free_percent: Integer;
	percent: Integer;
	min_height: Integer;
	free_height: Integer;
	shift_sum: qFloat;
begin
	if fPits.Count <= 0 then
		Exit;

	cntFree := 0;
	fix_percent := 0;
	for I := 0 to fPits.Count - 1 do
	begin
		percent := fPits[I].fMinHeight;
		if (percent = 0) then
			Inc (cntFree)
		else
			Inc (fix_percent, fPits[I].fMinHeight);
	end;
	if (cntFree <> 0) then
		free_percent := (100 - fix_percent) div cntFree
	else
		free_percent := 0;
	free_percent := Max (0, free_percent);

	AreaH := 100; //XGraphRect.Bottom - XGraphRect.Top;
	free_height := AreaH * free_percent div 100;

	for I := 0 to fPits.Count - 1 do
	begin
//		percent := fPits[I].fMinHeight;
		min_height := fPits[I].fMinHeight;
//		if (percent = 0) then
//			H := free_height
//		else
//			H := AreaH * percent div 100;
		H := Max (free_height, min_height);

		fPits[I].fYHeight := H / 100;
		shift_sum := 0;
		for J := 0 to I - 1 do
			shift_sum := shift_sum + fPits[J].fYHeight;
		fPits[I].fYShift := shift_sum;
	end;
end;

function TEasyGraph.GetCurrentZoom: qFloat;
begin
	Result := fCurrentZoom;
end;

// ----------------------------------------------------------------------------
//
// 	TLegend
//
// ----------------------------------------------------------------------------

constructor TLegend.Create;
begin
	inherited Create;
	fList := TList.Create;
	fTextHeight := 10;
end;

destructor TLegend.Destroy;
begin
	if fList <> nil then
	begin
		Clear;
		fList.Free;
	end;

	inherited Destroy;
end;

function TLegend.GetItems (AIndex: Integer): TLegendItem;
begin
	if (AIndex < 0) or (AIndex > Count) then
		raise Exception.Create ('Out of fRects bounds.')
	else
		Result := PLegendItem (fList.Items[AIndex])^;
end;

function TLegend.Add (Color: TColor; Text, Hint: String): Boolean;
var
	p: PLegendItem;
begin
	Result := False;

	if fList = nil then
		Exit;

	New (p);
	if (p = nil) then
		Exit;

	p.Color := Color;
	p.Text := StrNew (PChar (Text));
	p.Hint := StrNew (PChar (Hint));

	fList.Add (p);
	Result := True;
end;

procedure TLegend.Delete (AIndex: Integer);
var
	item: PLegendItem;
begin
	if (fList = nil) then
		Exit;

	if (AIndex < 0) or (AIndex > Count) then
		raise Exception.Create ('Out of fRects bounds.')
	else
	begin
		item := PLegendItem (fList.Items[AIndex]);
		if item = nil then
			Exit;

		StrDispose (item.Text);
		StrDispose (item.Hint);
		Dispose (item);
		fList.Delete (AIndex);
	end;
end;

procedure TLegend.Clear;
var
	I: Integer;
	item: PLegendItem;
begin
	if (fLIst = nil) then
		Exit;

	for I := 0 to fList.Count - 1 do
	begin
		item := PLegendItem (fList.Items[I]);
		if item = nil then
			Continue;

		StrDispose (item.Text);
		StrDispose (item.Hint);
		Dispose (item);
	end;
	fList.Clear;
end;

function TLegend.GetCount: Integer;
begin
	Result := 0;
	if fList <> nil then
		Result := fList.Count;
end;

// ----------------------------------------------------------------------------
//
// 	Регистрация класса
//
// ----------------------------------------------------------------------------

procedure Register;
begin
	RegisterComponents('Samples', [TEasyGraph]);
end;

end.
