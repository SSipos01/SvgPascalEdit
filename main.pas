unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Exit1: TMenuItem;
    EditMenu: TMenuItem;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    PaintBox1: TPaintBox;
    TreeView1: TTreeView;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Save1Click(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin

end;

procedure TMainForm.PaintBox1Paint(Sender: TObject);
begin
  with PaintBox1.Canvas do
  begin
    Brush.Color := clBlue;
    FillRect(10, 10, 100, 100);
  end;
end;

procedure TMainForm.Save1Click(Sender: TObject);
var
  SVGContent: TStringList;
begin
  SaveDialog1.Filter := 'SVG files (*.svg)|*.svg';
  if SaveDialog1.Execute then
  begin
    SVGContent := TStringList.Create;
    try
      SVGContent.Add('<svg width="640" height="480" xmlns="http://www.w3.org/2000/svg">');
      SVGContent.Add('  <rect x="10" y="10" width="90" height="90" fill="blue" />');
      SVGContent.Add('</svg>');
      SVGContent.SaveToFile(SaveDialog1.FileName);
    finally
      SVGContent.Free;
    end;
  end;
end;

end.
