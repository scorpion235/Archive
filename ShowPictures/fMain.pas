{-------------------------------------------------------------------------------
��������� ��������� ����������� ������
�����: ������� ������ ����������
e-mail: scorpion235@mail.ru
����� ����������: CodeGear� Delphi� 2009
                  Build 7601: Service Pack 1
����: 2012-04-05

� ��������� ������������ �������� ������ ���������
�� ������ TTreeView (����������� ������ TShellTreeView)
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
{$R FileCtrl} //��� ������� � �������

//�������� �����
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

  //�������� ������� ������
  TreeView.Items.AddChild(nil, 'My computer');

  //TODO: ����� ���������� ������ ����� �������� ��� ������ GetLogicaldrives
  for c := 'A' to 'Z' do
  begin
    s := c + ':';
    DriveType := GetDriveType(PChar(s)); //��� ����������� ����

    if DriveType = 1 then
      continue;

    //��������� �������� (���������� ����) � ��������� �������� ������
    node := TreeView.Items.AddChild(TreeView.Items[0], s);

    case DriveType of
      DRIVE_REMOVABLE: node.ImageIndex := 2;
      DRIVE_FIXED:     node.ImageIndex := 3;
      DRIVE_REMOTE:    node.ImageIndex := 4;
      DRIVE_CDROM:     node.ImageIndex := 5;
    else
      node.ImageIndex := 6; //�� �������
    end;

    node.SelectedIndex := node.ImageIndex;
    node.HasChildren   := true;
  end;

  TreeView.Items.EndUpdate;
end;

//���������� ��������� ��������� ������ �� ��������� ����������
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

  //��������� ������� ���� � �����
  repeat
    if (node.Text <> 'My computer') then
      path := node.Text + '\' + path;
    node := node.Parent;
  until (node = nil);

  //������������� ������ ����������
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

//��������� ������ � TreeView
procedure TfrmMain.TreeViewChange(Sender: TObject; Node: TTreeNode);
var
  path, ext4, ext5: string;
  sr: TSearchRec;
  ScrollBox: TScrollBox;
  img: TImage;
  img_count, left, top: longint;
begin
  //�������� ���������� ScrollBox
  FindComponent('ScrollBox').Free;
  StatusBar.SimpleText := '';

  if (node.Text = 'My computer') then
    exit;

  Screen.Cursor    := crHourGlass;
  //������������� TreeView �� ����� ������������ ��������
  TreeView.Enabled := false;
  path             := '';
  img_count        := 0;

  //��������� �������� ���� � �����
  repeat
    if (node.Text <> 'My computer') then
      path := node.Text + '\' + path;
    node := node.Parent;
  until (node = nil);

  path := path + '\';
  left := 10;
  top  := 10;

  //������������� ��� ����� ��������� ����������,
  //����� � ����� ������� ����������� ������� �����������
  if (FindFirst(path + '*.*', faAnyFile, sr) = 0) then
  begin
    //������������ �������� �������� TScrollBox �� ���������� pnlImages
    ScrollBox := TScrollBox.Create(frmMain.pnlImages);
    ScrollBox.Align := alClient;
    pnlImages.InsertControl(ScrollBox);

    repeat
      //��������� ��������� 4 ������� � ����� �����
      ext4 := copy(sr.Name, length(sr.Name) - 3, 4);

      //��������� ��������� 5 �������� � ����� �����
      ext5 := copy(sr.Name, length(sr.Name) - 4, 5);

      //��������� ������ jpeg � bmp ������
      if ((LowerCase(ext4) <> '.jpg')
      and (LowerCase(ext4) <> '.bmp')
      and (LowerCase(ext5) <> '.jpeg')) then
        continue;

      //������������ �������� �������� TImage �� ���������� ScrollBox
      img := TImage.Create(ScrollBox);
      img.Center       := true;
      img.Proportional := true;
      img.Width        := 100;
      img.Height       := 100;
      img.Left         := left;
      img.Top          := top;
      ScrollBox.InsertControl(img);

      //�������� ����������� �� �����
      try
        img.Picture.LoadFromFile(path + sr.Name);
      except
        on EInvalidGraphic do
          img.Picture.Graphic := nil;
      end;

      //���������� �������������� ��������� ���������
      if (left + TreeView.Width + 250 < Width) then
        left := left + 120
      else
      begin
        left := 10;
        top  := top + 120;
      end;

      inc(img_count);
    until (FindNext(sr) <> 0); //���� ���� ����� � ������� ����������

    FindClose(sr);
  end;

  //����������� ���������� ������������ �������� �����������
  StatusBar.SimpleText := format('%d �����������', [img_count]);
    
  TreeView.Enabled := true;
  Screen.Cursor    := crDefault;
end;

//��������� �������� ������ � ������������ ��������
procedure TfrmMain.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var MyImage: array of TImage;
begin
  //�������� ������� ������
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
