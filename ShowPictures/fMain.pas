{-------------------------------------------------------------------------------
Программа просмотра графических файлов
Автор: Дюгуров Сергей Михайлович
e-mail: scorpion235@mail.ru
Среда разработки: CodeGear™ Delphi® 2009
                  Build 7601: Service Pack 1
Дата: 2012-04-05

В программе использовано создание дерева каталогов
на основе TTreeView (самодельный аналог TShellTreeView)
--------------------------------------------------------------------------------}

unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, ComCtrls, Jpeg;

type
  TfrmMain = class(TForm)
    TreeView: TTreeView;
    Splitter: TSplitter;
    pnlImages: TPanel;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}
{$R FileCtrl} //для доступа к иконкам

//создание формы
procedure TfrmMain.FormCreate(Sender: TObject);
const
  IconNames: array [0..6] of string = ('CLOSEDFOLDER', 'OPENFOLDER',
    'FLOPPY', 'HARD', 'NETWORK', 'CDROM', 'RAM');
var
  c: char;
  s: string;
  node: TTreeNode;
  i,DriveType: integer;
  bm, mask: TBitmap;
begin
  TreeView.Items.BeginUpdate;

  TreeView.Images := TImageList.CreateSize(16, 16);
  bm              := TBitmap.Create;
  mask            := TBitmap.Create;

  for i := low(IconNames) to high(IconNames) do
  begin
    bm.Handle := LoadBitmap(HInstance, PChar(IconNames[i]));
    bm.Width  := 16;
    bm.Height := 16;
    mask.Assign(bm);
    mask.Mask(clBlue);
    TreeView.Images.Add(bm, mask);
  end;

  //корневой элемент дерева
  TreeView.Items.AddChild(nil, 'My computer');

  //TODO: имена логических дисков можно получить при помощи GetLogicaldrives
  for c := 'A' to 'Z' do
  begin
    s := c + ':';
    DriveType := GetDriveType(PChar(s)); //тип логического тома

    if DriveType = 1 then
      continue;

    //добавляем потомков (логические тома) к корневому элементу дерева
    node := TreeView.Items.AddChild(TreeView.Items[0], s);

    case DriveType of
      DRIVE_REMOVABLE: node.ImageIndex := 2;
      DRIVE_FIXED:     node.ImageIndex := 3;
      DRIVE_REMOTE:    node.ImageIndex := 4;
      DRIVE_CDROM:     node.ImageIndex := 5;
    else
      node.ImageIndex := 6; //не опознан
    end;

    node.SelectedIndex := node.ImageIndex;
    node.HasChildren   := true;
  end;

  TreeView.Items.EndUpdate;
end;

//добавление элементов структуры дерева на следующий подуровень
procedure NextLevel(ParentNode: TTreeNode);
  function DirectoryName(name: string): boolean;
  begin
    result := (name <> '.') and (name <> '..');
  end;
var
  sr, srChild: TSearchRec;
  node: TTreeNode;
  path: string;
begin
  node := ParentNode;
  path := '';

  //получение полного пути к файлу
  repeat
    if (node.Text <> 'My computer') then
      path := node.Text + '\' + path;
    node := node.Parent;
  until (node = nil);

  //просматриваем только директории
  if FindFirst(path + '*.*', faDirectory, sr) = 0 then
  begin
    repeat
      if (sr.Attr and faDirectory <> 0) and (DirectoryName(sr.Name)) then
      begin
        node := frmMain.TreeView.Items.AddChild(ParentNode, sr.Name);
        node.ImageIndex    := 0;
        node.SelectedIndex := 1;
        node.HasChildren   := false;

        if FindFirst(path + sr.Name + '\*.*', faDirectory, srChild) = 0 then
        begin
          repeat
            if (srChild.Attr and faDirectory <> 0) and (DirectoryName(srChild.Name))
              then node.HasChildren := true;
          until (FindNext(srChild) <> 0) or (node.HasChildren);
        end;

        FindClose(srChild);
      end;
    until FindNext(sr) <> 0;
  end
  else
    ParentNode.HasChildren := false;

  FindClose(sr);
end;

//изменение фокуса в TreeView
procedure TfrmMain.TreeViewChange(Sender: TObject; Node: TTreeNode);
var
  path, ext4, ext5: string;
  sr: TSearchRec;
  ScrollBox: TScrollBox;
  img: TImage;
  img_count, left, top: longint;
begin
  //удаление компонента ScrollBox
  FindComponent('ScrollBox').Free;
  StatusBar.SimpleText := '';

  if (node.Text = 'My computer') then
    exit;

  Screen.Cursor    := crHourGlass;
  //недоступность TreeView на время формирование миниатюр
  TreeView.Enabled := false;
  path             := '';
  img_count        := 0;

  //получение польного пути к файлу
  repeat
    if (node.Text <> 'My computer') then
      path := node.Text + '\' + path;
    node := node.Parent;
  until (node = nil);

  path := path + '\';
  left := 10;
  top  := 10;

  //просматриваем все файлы выбранное директории,
  //далее в цикле отберем необходимые форматы изображений
  if (FindFirst(path + '*.*', faAnyFile, sr) = 0) then
  begin
    //динамическое создание элемента TScrollBox на компоненте pnlImages
    ScrollBox := TScrollBox.Create(frmMain.pnlImages);
    ScrollBox.Align := alClient;
    pnlImages.InsertControl(ScrollBox);

    repeat
      //считываем последине 4 символа в имени файла
      ext4 := copy(sr.Name, length(sr.Name) - 3, 4);

      //считываем последине 5 символов в имени файла
      ext5 := copy(sr.Name, length(sr.Name) - 4, 5);

      //поддержка только jpeg и bmp файлов
      if ((LowerCase(ext4) <> '.jpg')
      and (LowerCase(ext4) <> '.bmp')
      and (LowerCase(ext5) <> '.jpeg')) then
        continue;

      //динамическое создание элемента TImage на компоненте ScrollBox
      img := TImage.Create(ScrollBox);
      img.Center       := true;
      img.Proportional := true;
      img.Width        := 100;
      img.Height       := 100;
      img.Left         := left;
      img.Top          := top;
      ScrollBox.InsertControl(img);

      //загрузка изображения из файла
      try
        img.Picture.LoadFromFile(path + sr.Name);
      except
        on EInvalidGraphic do
          img.Picture.Graphic := nil;
      end;

      //рассчитаем местоположение следующей миниатюры
      if (left + TreeView.Width + 250 < Width) then
        left := left + 120
      else
      begin
        left := 10;
        top  := top + 120;
      end;

      inc(img_count);
    until (FindNext(sr) <> 0); //пока есть файлы в текущей директории

    FindClose(sr);
  end;

  //отображение количества обработанных миниатюр изображений
  StatusBar.SimpleText := format('%d изображений', [img_count]);
    
  TreeView.Enabled := true;
  Screen.Cursor    := crDefault;
end;

//раскрытие элемента дерева и формирование потомков
procedure TfrmMain.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var MyImage: array of TImage;
begin
  //корневой элемент дерева
  if (Node.Text = 'My computer') then
    exit;

  Screen.Cursor := crHourGlass;
  TreeView.Items.BeginUpdate;

  node.DeleteChildren;
  NextLevel(node);

  TreeView.Items.EndUpdate;
  Screen.Cursor := crDefault;
end;

end.
