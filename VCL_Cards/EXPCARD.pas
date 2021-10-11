{***********************************************************}
{Unit: ExpCard                                              }
{Date: 10.03.2007                                           }
{Version: 2.2                                               }
{Notes: Визуальный компонент "Игральная карта" (расширеный) }
{***********************************************************}
{Порядок картинок в ImageList:                          }
{4 масти от туза до короля (черви, бубны, крести, пики);}
{джокер, 0 (карт нет), Х(перекладывать нельзя), подложка}

unit EXPCARD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, CommCtrl,
  ImgList, FncVCGm;
type
  TExpandedCard = class(TGraphicControl)
  private
//    FrontBmp: TBitmap;   //Картинки карт
    FSuit: TSuit;               //Масть
//    FImageFile: String;        //Файл карт
    FMaskColor: TColor;         //Цвет тона картинки для Mask
    FCardValue: Integer;        //Достоинство карты
    FInvert: Boolean;           //Негативное изображение (метка)
    FMask: Boolean;             //Тонирование карты (напр. для обозначения недоступности карты)
    FCardStyle: TCardStyle;     //Рубашка карты или отсутствие карты
    FPile: Boolean;             //Имитация стопки карт
    FRotation: TCardRotation;   //Положение карты (вертикально/горизонтально)
    FCardWidth: Integer;        //Ширина и высота карты
    FCardHeight: Integer;
    FImageChangeLink: TChangeLink;
    FBackImageIndex: Integer;   //Номер картинки рубашки
    FCardImages: TCustomImageList;  //ImageList - источник картинок карт
    FBackImages: TCustomImageList;  //ImageList - источник картинок рубашек
    procedure ImageListChange(Sender: TObject);
    procedure SetValSuit(NewValue: TSuit);
    procedure SetValCardValue(NewValue: Integer);
    procedure SetValInvert(NewValue: Boolean);
    procedure SetValCardBack(NewValue: TCardStyle);
    procedure SetValMask(NewValue: Boolean);
//    procedure SetValFrontGlyph(NewValue: String);
    procedure SetMaskColor(NewValue: TColor);
//    procedure ExtractGlyph(IndCol, IndRow: Integer; Source, Bitmap: TBitmap);
    function LoadGlyph(Ind: Integer; Images: TCustomImageList; var Bitmap: TBitmap): Boolean;
//    procedure LoadGlyphs(NmFile: String; Bmp: TBitmap);
    procedure SetPile(NewValue: Boolean);
    procedure SetRotation(NewValue: TCardRotation);
    procedure SetCardWidth(NewValue: Integer);
    procedure SetCardHeight(NewValue: Integer);
    procedure SetBackImageIndex(NewValue: Integer);
    procedure SetCardImages(NewValue: TCustomImageList);
    procedure SetBackImages(NewValue: TCustomImageList);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Suit: TSuit read FSuit write SetValSuit;                   // "масть"
    property CardValue: Integer read FCardValue write SetValCardValue;  // "достоинство"
    property Invert: Boolean read FInvert write SetValInvert;           // выделение "негатив"
    property Mask: Boolean read FMask write SetValMask;                 // "маска"
    property Enabled;
    property Visible;
    property Hint;
    property ShowHint;
    property DragCursor;
    property DragKind;
    property DragMode;
    property CardStyle: TCardStyle read FCardStyle write SetValCardBack;
//    property ImageFile: String read FImageFile write SetValFrontGlyph;
    property MaskColor: TColor read FMaskColor write SetMaskColor;
    property Pile: Boolean read FPile write SetPile;
    property Rotation: TCardRotation read FRotation write SetRotation;
    property CardWidth: Integer read FCardWidth write SetCardWidth;
    property CardHeight: Integer read FCardHeight write SetCardHeight;
    property BackImageIndex: Integer read FBackImageIndex write SetBackImageIndex;
    property CardImages: TCustomImageList read FCardImages write SetCardImages;
    property BackImages: TCustomImageList read FBackImages write SetBackImages;
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
procedure TExpandedCard.ImageListChange(Sender: TObject);
begin
  Perform(TCM_SETIMAGELIST, 0, TCustomImageList(Sender).Handle);
end;

procedure TExpandedCard.SetValSuit(NewValue: TSuit);
begin
  if FSuit = NewValue then Exit;
  FSuit := NewValue;
  if FSuit = cJoker then
    FCardValue := 1;
  Invalidate;
end;

procedure TExpandedCard.SetValCardValue(NewValue: Integer);
begin
  if FCardValue = NewValue then Exit;
  if (NewValue < 1) and (NewValue > 13) then
  FCardValue := 1 else
  FCardValue := NewValue;
  Invalidate;
end;

procedure TExpandedCard.SetValInvert(NewValue: Boolean);
begin
  if FInvert = NewValue then Exit;
  FInvert := NewValue;
  Invalidate;
end;

procedure TExpandedCard.SetValCardBack(NewValue: TCardStyle);
begin
  if FCardStyle = NewValue then Exit;
  FCardStyle := NewValue;
  Invalidate;
end;

procedure TExpandedCard.SetValMask(NewValue: Boolean);
begin
  if FMask = NewValue then Exit;
  FMask := NewValue;
  Invalidate;
end;
{-Устанавливает каталог}
{
procedure TExpandedCard.SetValFrontGlyph(NewValue: String);
begin
  if FImageFile = NewValue then Exit;
  FImageFile := NewValue;
  if FImageFile <> '' then
    LoadGlyphs(FImageFile, FrontBmp);
  Invalidate;
end;
}
Procedure TExpandedCard.SetMaskColor(NewValue: TColor);
begin
  if FMaskColor = NewValue then Exit;
  FMaskColor := NewValue;
  Invalidate;
end;
{-Извлекает нужную из ряда картинок}
{
procedure TExpandedCard.ExtractGlyph(IndCol, IndRow: Integer; Source, Bitmap: TBitmap);
var
  DestRct: TRect;
begin
  Dec(IndCol);  //Уменьшить, чтобы можно было задавать 1
  Dec(IndRow);
  DestRct := Rect(0,0,FCardWidth,FCardHeight);
  Bitmap.Width := FCardWidth;
  Bitmap.Height := FCardHeight;
  Bitmap.Canvas.CopyRect(DestRct, Source.Canvas, Rect(IndCol*FCardWidth,IndRow*FCardHeight,
                                                    (IndCol+1)*FCardWidth,(IndRow+1)*FCardHeight));
end;
}
{ -"Вытаскиваем" картинку из ImageList }
function TExpandedCard.LoadGlyph(Ind: Integer; Images: TCustomImageList;
  var Bitmap: TBitmap): Boolean;
begin
  Result := True;
  if Ind > Images.Count then
  begin
    Result := False;
    Exit;
  end;
  Bitmap.Width := FCardWidth;
  Bitmap.Height := FCardHeight;
  Images.GetBitmap(Ind, Bitmap);
end;
{-Загрузка файла картинок }
(*procedure TExpandedCard.LoadGlyphs(NmFile: String; Bmp: TBitmap);
var
  jpg: TJpegImage;
  ext: String;
begin
  if not FileExists(NmFile) then begin //файл отсутствует  - выход
    Application.MessageBox(PChar('Файл ' + NmFile + ' не найден!'),PChar('Ошибка'),MB_OK);
    Exit;
  end;
  ext := ExtractFileExt(NmFile);
  if ext = '.jpg' then
  try
    jpg:=TJpegImage.Create;
    jpg.LoadFromFile(NmFile);
    Bmp.Assign(jpg);
  finally
    jpg.Free;
  end else
  Bmp.LoadFromFile(NmFile);
end;
*)
{ Установка признака имитации стопки}
procedure TExpandedCard.SetPile(NewValue: Boolean);
begin
  if FPile = NewValue then Exit;
  FPile := NewValue;
  Invalidate;
end;
procedure TExpandedCard.SetRotation(NewValue: TCardRotation);
begin
  if FRotation = NewValue then Exit;
  FRotation := NewValue;
  if FRotation = orVertical then
  begin
    Width := FCardWidth;
    Height := FCardHeight;
  end else
  begin
    Width := FCardHeight;
    Height := FCardWidth;
  end;
  Invalidate;
end;

procedure TExpandedCard.SetCardWidth(NewValue: Integer);
begin
  if FCardWidth = NewValue then Exit;
  FCardWidth := NewValue;
  if CardImages <> nil then
    CardImages.Width := FCardWidth;
  if BackImages <> nil then
    BackImages.Width := FCardWidth;
  Invalidate;
end;

procedure TExpandedCard.SetCardHeight(NewValue: Integer);
begin
  if FCardHeight = NewValue then Exit;
  FCardHeight := NewValue;
  if CardImages <> nil then
    CardImages.Height := FCardHeight;
  if BackImages <> nil then
    BackImages.Height := FCardHeight;
  Invalidate;
end;

procedure TExpandedCard.SetBackImageIndex(NewValue: Integer);
begin
  if FBackImageIndex = NewValue then Exit;
  FBackImageIndex := NewValue;
  Invalidate;
end;

procedure TExpandedCard.SetCardImages(NewValue: TCustomImageList);
begin
  if CardImages <> nil then
    CardImages.UnRegisterChanges(FImageChangeLink);
  FCardImages := NewValue;
  if CardImages <> nil then
  begin
    CardImages.RegisterChanges(FImageChangeLink);
    CardImages.FreeNotification(Self);
    Perform(TCM_SETIMAGELIST, 0, CardImages.Handle);
  end else
    Perform(TCM_SETIMAGELIST, 0, 0);
  Invalidate;
end;

procedure TExpandedCard.SetBackImages(NewValue: TCustomImageList);
begin
  if BackImages <> nil then
    BackImages.UnRegisterChanges(FImageChangeLink);
  FBackImages := NewValue;
  if BackImages <> nil then
  begin
    BackImages.RegisterChanges(FImageChangeLink);
    BackImages.FreeNotification(Self);
    Perform(TCM_SETIMAGELIST, 0, BackImages.Handle);
  end else
    Perform(TCM_SETIMAGELIST, 0, 0);
  Invalidate;
end;

procedure TExpandedCard.Paint;
Var
  i: Integer;
  TmpBitmap,TmpBitmap1: TBitmap;
begin
  inherited Paint;
  if FCardStyle = scNone then //Карты нет
  begin //вывод простого контура
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsDiagCross;
    with inherited Canvas do
      if FRotation = orHorizontal then
        FrameRect(Rect(0,0,FCardHeight,FCardWidth)) else
        FrameRect(Rect(0,0,FCardWidth,FCardHeight));
    Exit;
  end;// else
//  begin
  if not Assigned(CardImages) then Exit;
  TmpBitmap := TBitMap.Create;
  TmpBitmap1 := TBitMap.Create;
//  if (FImageFile = '') then Exit;
  if FCardStyle = scFront then //Если лецевая сторона - загружаем одну из мастей
  begin
    if FSuit = cJoker then begin  //Джокер
      if not LoadGlyph(13*Ord(FSuit), CardImages, TmpBitmap) then
        Exit;
    end else begin                //Масть
      if not LoadGlyph(((13*Ord(FSuit))+FCardValue)-1, CardImages, TmpBitmap) then
        Exit;
    end;
  end else if FCardStyle = scBack then
  begin                           //Рубашка
    if not LoadGlyph(FBackImageIndex, BackImages, TmpBitmap) then
      Exit;
  end else
  begin                           //Другое
    if not LoadGlyph(52+(Ord(FCardStyle)-1), CardImages, TmpBitmap) then
      Exit;
  end;
{
    ExtractGlyph(FCardValue, Ord(FSuit)+1, FrontBmp, TmpBitmap) else
    ExtractGlyph(Ord(FCardStyle)+1, 5, FrontBmp, TmpBitmap);
}
    TmpBitmap1.Assign(TmpBitmap);
    if FMask then       //маска карты
      ModColors(TmpBitmap1,FMaskColor);

    if FRotation = orHorizontal then //Поворот
      RotateBitmap(TmpBitmap1, 90, clWhite);

    if FInvert then
      InvertBitmap(TmpBitmap1);

    with inherited Canvas do begin
      if FPile then begin //Имитация стопки
        Width := TmpBitmap.Width+6;
        Height := TmpBitmap.Height+6;
        for i := 0 to 2 do
          StretchDraw(RECT(i*2,i*2,(i*2)+TmpBitmap.Width, (i*2)+TmpBitmap.Height), TmpBitmap);
        StretchDraw(RECT(6,6,TmpBitmap1.Width+6, TmpBitmap1.Height+6), TmpBitmap1);
      end else            //Одна карта
      begin
        Width := TmpBitmap1.Width;
        Height := TmpBitmap1.Height;
        StretchDraw(RECT(0,0,TmpBitmap1.Width, TmpBitmap1.Height), TmpBitmap1);
      end;
    end;
    TmpBitmap.Free;
    TmpBitmap1.Free;
end;

constructor TExpandedCard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSuit := cChervi;
  FCardValue := 1;
  FCardStyle := scNone;
  FMask := False;
  FPile := False;
  FMaskColor := clGray;
  FCardWidth := 71;
  Width := FCardWidth;
  FCardHeight := 96;
  Height := FCardHeight;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  //  FrontBmp := TBitmap.Create;
end;

destructor TExpandedCard.Destroy;
begin
  FreeAndNil(FImageChangeLink);
//  FrontBmp.Free;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('VCLCards', [TExpandedCard]);
end;

end.