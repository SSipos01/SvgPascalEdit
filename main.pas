unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls, Contnrs, drawing;

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
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FDrawingObjects: TObjectList;
    FIsDrawing: Boolean;
    FDownPoint: TPoint;
  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FDrawingObjects := TObjectList.Create(True);
  FDrawingObjects.Add(TRectangleObject.Create(Rect(20, 20, 120, 120), clRed));
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FDrawingObjects.Free;
end;

procedure TMainForm.PaintBox1Paint(Sender: TObject);
var
  i: Integer;
  Obj: TDrawingObject;
begin
  for i := 0 to FDrawingObjects.Count - 1 do
  begin
    Obj := FDrawingObjects[i] as TDrawingObject;
    Obj.Draw(PaintBox1.Canvas);
  end;
end;

procedure TMainForm.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FIsDrawing := True;
    FDownPoint := Point(X, Y);
  end;
end;

procedure TMainForm.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if FIsDrawing then
  begin
    PaintBox1.Canvas.Refresh;
    PaintBox1.Canvas.DrawFocusRect(Rect(FDownPoint.X, FDownPoint.Y, X, Y));
  end;
end;

procedure TMainForm.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  NewRect: TRect;
begin
  if FIsDrawing and (Button = mbLeft) then
  begin
    FIsDrawing := False;
    NewRect := Rect(FDownPoint.X, FDownPoint.Y, X, Y);
    FDrawingObjects.Add(TRectangleObject.Create(NewRect, clGreen));
    PaintBox1.Invalidate;
  end;
end;

procedure TMainForm.Save1Click(Sender: TObject);
var
  SVGContent: TStringList;
  i: Integer;
  Obj: TDrawingObject;
begin
  SaveDialog1.Filter := 'SVG files (*.svg)|*.svg';
  if SaveDialog1.Execute then
  begin
    SVGContent := TStringList.Create;
    try
      SVGContent.Add('<svg width="640" height="480" xmlns="http://www.w3.org/2000/svg">');
      for i := 0 to FDrawingObjects.Count - 1 do
      begin
        Obj := FDrawingObjects[i] as TDrawingObject;
        SVGContent.Add(Obj.ToSVG);
      end;
      SVGContent.Add('</svg>');
      SVGContent.SaveToFile(SaveDialog1.FileName);
    finally
      SVGContent.Free;
    end;
  end;
end;

end.
