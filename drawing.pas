unit drawing;

{$mode objfpc}{$H+}

interface

uses
  Classes, Graphics;

type

  { TDrawingObject }

  TDrawingObject = class(TObject)
  private
    FBounds: TRect;
  public
    constructor Create(const ABounds: TRect);
    procedure Draw(ACanvas: TCanvas); virtual; abstract;
    function ToSVG: string; virtual; abstract;
    property Bounds: TRect read FBounds write FBounds;
  end;

  { TRectangleObject }

  TRectangleObject = class(TDrawingObject)
  private
    FFillColor: TColor;
  public
    constructor Create(const ABounds: TRect; AFillColor: TColor);
    procedure Draw(ACanvas: TCanvas); override;
    function ToSVG: string; override;
    property FillColor: TColor read FFillColor write FFillColor;
  end;

implementation

{ TDrawingObject }

constructor TDrawingObject.Create(const ABounds: TRect);
begin
  inherited Create;
  FBounds := ABounds;
end;

{ TRectangleObject }

constructor TRectangleObject.Create(const ABounds: TRect; AFillColor: TColor);
begin
  inherited Create(ABounds);
  FFillColor := AFillColor;
end;

procedure TRectangleObject.Draw(ACanvas: TCanvas);
begin
  ACanvas.Brush.Color := FFillColor;
  ACanvas.FillRect(FBounds);
end;

function TRectangleObject.ToSVG: string;
begin
  Result := Format('  <rect x="%d" y="%d" width="%d" height="%d" fill="%s" />',
    [FBounds.Left, FBounds.Top, FBounds.Right - FBounds.Left, FBounds.Bottom - FBounds.Top, ColorToHTML(FFillColor)]);
end;

end.
