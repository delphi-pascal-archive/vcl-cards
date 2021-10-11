{***********************************************************}
{Unit: Card                                             }
{Date: 27.06.2005                                            }
{Version: 2.0                                               }
{Notes: Игральная карта (стандартная)                       }
{***********************************************************}
unit CARD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, CommCtrl,
  FncVCGm;

type
  TCard = class(TGraphicControl)
  private
  //  Len: Integer;       //Величина отступа для имитации стопки
    FSuit: TSuit;        //Масть
    FCardValue: Integer; //Достоинство
    FInvert: Boolean;    //Негативное изображение (метка)
    FMask: Boolean;      //Маска карты (окрашивание в выбранный тон)
    FCardStyle: TCardStyle; //Стиль ("лицо", "рубашка", пустое место и др.)
    FPile: Boolean;      //Имитация стопки карт
    FMaskColor: TColor;  //Цвет тона картинки для Mask
    FRotation: TCardRotation;  //положение карты
    procedure SetValSuit(NewValue: TSuit);
    procedure SetValCardValue(NewValue: Integer);
    procedure SetValInvert(NewValue: Boolean);
    procedure SetCardStyle(NewValue: TCardStyle);
    procedure SetMask(NewValue: Boolean);
    procedure SetPile(NewValue: Boolean);
    procedure SetRotation(NewValue: TCardRotation);
    procedure SetMaskColor(NewValue: TColor);
//    procedure BitInvert(var Bit: TBitmap);
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    property Suit: TSuit read FSuit write SetValSuit;                   // "масть"
    property CardValue: Integer read FCardValue write SetValCardValue;  // "достоинство"
    property Invert: Boolean read FInvert write SetValInvert;           // выделение "негатив"
    property Mask: Boolean read FMask write SetMask;                    // выделение ч/б "маска"
    property Enabled;
    property Visible;
    property Hint;
    property ShowHint;
    property DragCursor;
    property DragKind;
    property DragMode;
    property CardStyle: TCardStyle read FCardStyle write SetCardStyle;
    property Pile: Boolean read FPile write SetPile;
    property Rotation: TCardRotation read FRotation write SetRotation;
    property MaskColor: TColor read FMaskColor write SetMaskColor;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;
procedure Register;

implementation

{$R *.res}

procedure TCard.SetValSuit(NewValue: TSuit);
begin
  if FSuit = NewValue then Exit;
  FSuit := NewValue;
  Invalidate;
end;

procedure TCard.SetValCardValue(NewValue: Integer);
begin
  if FCardValue = NewValue then Exit;
  if (NewValue < 1) and (NewValue > 13) then Exit;
  FCardValue := NewValue;
  Invalidate;
end;

procedure TCard.SetValInvert(NewValue: Boolean);
begin
  if FInvert = NewValue then Exit;
  FInvert := NewValue;
  Invalidate;
end;

procedure TCard.SetCardStyle(NewValue: TCardStyle);
begin
  if FCardStyle = NewValue then Exit;
  FCardStyle := NewValue;
  Invalidate;
end;

procedure TCard.SetMask(NewValue: Boolean);
begin
  if FMask = NewValue then Exit;
  FMask := NewValue;
  Invalidate;
end;
procedure TCard.SetPile(NewValue: Boolean);
begin
  if FPile = NewValue then Exit;
  FPile := NewValue;
  Invalidate;
end;

procedure TCard.SetRotation(NewValue: TCardRotation);
begin
  if FRotation = NewValue then Exit;
  FRotation := NewValue;
  if FRotation = orVertical then
  begin
    Width := 71;
    Height := 96;
  end else
  begin
    Width := 96;
    Height := 71;
  end;
  Invalidate;
end;

procedure TCard.SetMaskColor(NewValue: TColor);
begin
  if FMaskColor = NewValue then Exit;
  FMaskColor := NewValue;
  Invalidate;
end;
(*
procedure TCard.BitInvert(var Bit: TBitmap);
var
  ARect: TRect;
begin
  with Bit.Canvas do
  begin
    CopyMode := cmNotSrcErase;
    ARect := Rect(0, 0, Bit.Width, Bit.Height);
    CopyRect(ARect, Bit.Canvas, ARect);
    CopyMode := cmSrcCopy; { restore the copy mode }
  end;
end;
*)
{-Отрисовка}
procedure TCard.Paint;
Var
  TmpBitmap: TBitmap;
  s: String;
  i : Integer;
begin
  inherited Paint;
  if FCardStyle = scNone then
  begin //вывод простого контура
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsDiagCross;
    with inherited Canvas do
      if FRotation = orHorizontal then
        FrameRect(Rect(0,0,96,71)) else
        FrameRect(Rect(0,0,71,96));
    Exit;
  end;
  s := '';
  TmpBitmap := TBitMap.Create;
  if FCardStyle = scFront then
  begin //Если лецевая сторона - загружаем одну из мастей
    case FSuit of
     cChervi: s := s + 'Chervi_';
     cBubny: s := s + 'Bubny_';
     cCresti: s := s + 'Cresti_';
     cPiki: s := s + 'Piki_';
     cJoker: s := s + 'JOKER';
    end;
    if FSuit <> cJoker then
      s := s+IntToStr(FCardValue);
  end else begin //Если нет - рубашку или специальное обозначение
    case FCardStyle of
     scZero: s := 'ZERO';
     scBack: s := 'BACK';
     scBlank: s := 'BLANK';
     scX: s := 'X';
    end;
  end;
  TmpBitmap.LoadFromResourceName(HInstance,s);
  if FMask then       //Если маска карты
    ModColors(TmpBitmap,FMaskColor);
  if FInvert then
    InvertBitmap(TmpBitmap);
  if FRotation = orHorizontal then
    RotateBitmap(TmpBitmap, 90, clWhite);
  with inherited Canvas do begin
    if FPile then begin //Имитация стопки
      Width := TmpBitmap.Width+6;
      Height := TmpBitmap.Height+6;
      for i := 0 to 3 do
        StretchDraw(RECT(i*2,i*2,(i*2)+TmpBitmap.Width, (i*2)+TmpBitmap.Height), TmpBitmap);
    end else            //Одна карта
    begin
      Width := TmpBitmap.Width;
      Height := TmpBitmap.Height;
      StretchDraw(RECT(0,0,TmpBitmap.Width, TmpBitmap.Height), TmpBitmap);
    end;
  end;
  TmpBitmap.Free;
end;

constructor TCard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSuit := cChervi;
  FCardValue := 1;
  FCardStyle := scFront;
  FMask := False;
  FMaskColor := clGray;
  FRotation := orVertical;
  Width := 71;
  Height := 96;
end;

procedure Register;
begin
  RegisterComponents('VCLCards', [TCard]);
end;

end.
