(*  Функции для компонентов VCLGame *)
unit FncVCGm;

interface
uses
   Windows, Graphics, Types;

type     //Типы необходимые для всех элементов
  TSuit = (cChervi, cBubny, cCresti, cPiki, cJoker);    // Тип "масть"
  TCardStyle = (scFront, scBack, scZero, scX, scBlank, scNone);
  TCardRotation = (orVertical, orHorizontal);

  TCrd = record //Данные о карте
    S: TSuit;
    V: Integer;
  end;
  PCrd = ^TCrd;

 {Функции взяты с сайта http://delphiworld.narod.ru}
  procedure RotateBitmap(Bitmap: TBitmap; Angle: Double; BackColor: TColor);
  procedure ModColors(var Bitmap: TBitmap; Color: TColor);
  procedure InvertBitmap(Bitmap: TBitmap);

implementation

{ -Поворот изображения Bitmap на угол Angle c заливкой полей цветом BackColor}
procedure RotateBitmap(Bitmap: TBitmap; Angle: Double; BackColor: TColor);
type TRGB = record
       B, G, R: Byte;
     end;
     pRGB = ^TRGB;
     pByteArray = ^TByteArray;
     TByteArray = array[0..32767] of Byte;
     TRectList = array [1..4] of TPoint;

var x, y, W, H, v1, v2: Integer;
    Dest, Src: pRGB;
    VertArray: array of pByteArray;
    Bmp: TBitmap;

  procedure SinCos(AngleRad: Double; var ASin, ACos: Double);
  begin
    ASin := Sin(AngleRad);
    ACos := Cos(AngleRad);
  end;

  function RotateRect(const Rect: TRect; const Center: TPoint; Angle: Double): TRectList;
  var DX, DY: Integer;
      SinAng, CosAng: Double;
    function RotPoint(PX, PY: Integer): TPoint;
    begin
      DX := PX - Center.x;
      DY := PY - Center.y;
      Result.x := Center.x + Round(DX * CosAng - DY * SinAng);
      Result.y := Center.y + Round(DX * SinAng + DY * CosAng);
    end;
  begin
    SinCos(Angle * (Pi / 180), SinAng, CosAng);
    Result[1] := RotPoint(Rect.Left, Rect.Top);
    Result[2] := RotPoint(Rect.Right, Rect.Top);
    Result[3] := RotPoint(Rect.Right, Rect.Bottom);
    Result[4] := RotPoint(Rect.Left, Rect.Bottom);
  end;

  function Min(A, B: Integer): Integer;
  begin
    if A < B then Result := A
             else Result := B;
  end;

  function Max(A, B: Integer): Integer;
  begin
    if A > B then Result := A
             else Result := B;
  end;

  function GetRLLimit(const RL: TRectList): TRect;
  begin
    Result.Left := Min(Min(RL[1].x, RL[2].x), Min(RL[3].x, RL[4].x));
    Result.Top := Min(Min(RL[1].y, RL[2].y), Min(RL[3].y, RL[4].y));
    Result.Right := Max(Max(RL[1].x, RL[2].x), Max(RL[3].x, RL[4].x));
    Result.Bottom := Max(Max(RL[1].y, RL[2].y), Max(RL[3].y, RL[4].y));
  end;

  procedure Rotate;
  var x, y, xr, yr, yp: Integer;
      ACos, ASin: Double;
      Lim: TRect;
  begin
    W := Bmp.Width;
    H := Bmp.Height;
    SinCos(-Angle * Pi/180, ASin, ACos);
    Lim := GetRLLimit(RotateRect(Rect(0, 0, Bmp.Width, Bmp.Height), Point(0, 0), Angle));
    Bitmap.Width := Lim.Right - Lim.Left;
    Bitmap.Height := Lim.Bottom - Lim.Top;
    Bitmap.Canvas.Brush.Color := BackColor;
    Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));
    for y := 0 to Bitmap.Height - 1 do begin
      Dest := Bitmap.ScanLine[y];
      yp := y + Lim.Top;
      for x := 0 to Bitmap.Width - 1 do begin
        xr := Round(((x + Lim.Left) * ACos) - (yp * ASin));
        yr := Round(((x + Lim.Left) * ASin) + (yp * ACos));
        if (xr > -1) and (xr < W) and (yr > -1) and (yr < H) then begin
          Src := Bmp.ScanLine[yr];
          Inc(Src, xr);
          Dest^ := Src^;
        end;
        Inc(Dest);
      end;
    end;
  end;

begin
  Bitmap.PixelFormat := pf24Bit;
  Bmp := TBitmap.Create;
  try
    Bmp.Assign(Bitmap);
    W := Bitmap.Width - 1;
    H := Bitmap.Height - 1;
    if Frac(Angle) <> 0.0
      then Rotate
      else
    case Trunc(Angle) of
      -360, 0, 360, 720: Exit;
      90, 270: begin
        Bitmap.Width := H + 1;
        Bitmap.Height := W + 1;
        SetLength(VertArray, H + 1);
        v1 := 0;
        v2 := 0;
        if Angle = 90.0 then v1 := H
                        else v2 := W;
        for y := 0 to H do VertArray[y] := Bmp.ScanLine[Abs(v1 - y)];
        for x := 0 to W do begin
          Dest := Bitmap.ScanLine[x];
          for y := 0 to H do begin
            v1 := Abs(v2 - x)*3;
            with Dest^ do begin
              B := VertArray[y, v1];
              G := VertArray[y, v1+1];
              R := VertArray[y, v1+2];
            end;
            Inc(Dest);
          end;
        end
      end;
      180: begin
        for y := 0 to H do begin
          Dest := Bitmap.ScanLine[y];
          Src := Bmp.ScanLine[H - y];
          Inc(Src, W);
          for x := 0 to W do begin
            Dest^ := Src^;
            Dec(Src);
            Inc(Dest);
          end;
        end;
      end;
      else Rotate;
    end;
  finally
    Bmp.Free;
  end;
end;
{ -Окраска изображения в цвет Color }
procedure ModColors(var Bitmap: TBitmap; Color: TColor);
  function GetR(const Color: TColor): Byte;
    //извлечение красного
  begin
    Result := Lo(Color);
  end;
  function GetG(const Color: TColor): Byte;
    //извлечение зелёного
  begin
    Result := Lo(Color shr 8);
  end;
  function GetB(const Color: TColor): Byte;
    //извлечение синего
  begin
    Result := Lo((Color shr 8) shr 8);
  end;

  function BLimit(B: Integer): Byte;
  begin
    if B < 0 then
      Result := 0
    else if B > 255 then
      Result := 255
    else
      Result := B;
  end;

type
  TRGB = record
    B, G, R: Byte;
  end;
  pRGB = ^TRGB;
var
  r1, g1, b1: Byte;
  x, y: Integer;
  Dest: pRGB;
  A: Double;
begin
  Bitmap.PixelFormat := pf24Bit;
  r1 := Round(255 / 100 * GetR(Color));
  g1 := Round(255 / 100 * GetG(Color));
  b1 := Round(255 / 100 * GetB(Color));
  for y := 0 to Bitmap.Height - 1 do
  begin
    Dest := Bitmap.ScanLine[y];
    for x := 0 to Bitmap.Width - 1 do
    begin
      with Dest^ do
      begin
        A := (r + b + g) / 300;
        with Dest^ do
        begin
          R := BLimit(Round(r1 * A));
          G := BLimit(Round(g1 * A));
          B := BLimit(Round(b1 * A));
        end;
      end;
      Inc(Dest);
    end;
  end;
end;
{ -Инвертирование изображения }
procedure InvertBitmap(Bitmap: TBitmap);
type
  TRGB = record
    B, G, R: Byte;
  end;
  pRGB = ^TRGB;
var
  x, y: Integer;
  Dest: pRGB;
begin
  Bitmap.PixelFormat := pf24Bit;
  for y := 0 to Bitmap.Height - 1 do
  begin
    Dest := Bitmap.ScanLine[y];
    for x := 0 to Bitmap.Width - 1 do
    begin
      with Dest^ do
      begin
        R := 255 - R;
        G := 255 - G;
        B := 255 - B;
      end;
      Inc(Dest);
    end;
  end;
end;

end.