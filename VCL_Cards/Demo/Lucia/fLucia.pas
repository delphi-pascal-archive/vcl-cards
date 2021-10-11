{***********************************************************}
{Prioject: Lucia                                            }
{Form: fLucia                                               }
{Date: 01.05.2003                                           }
{Version: 1.0                                               }
{Notes: Пасьянс "Прекрасная Люция"                          }
{Copyright (c) 2002 by Aleksey Savin                        }
{***********************************************************}
unit fLucia;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus,
  Coloda, CARD, FncVCGm;

type
  TarrRasklad = array[1..18,1..3] of TCard;
  TFormLucia = class(TForm)
    Coloda1: TColoda;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    NewGame1: TMenuItem;
    Setting1: TMenuItem;
    Exit1: TMenuItem;
    Card1: TCard;
    Card2: TCard;
    Card3: TCard;
    Card4: TCard;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BazaClick(Sender: TObject);
    procedure CardClick(Sender: TObject);
    procedure NewGame1Click(Sender: TObject);
    procedure Setting1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
     function Cnt(n: Integer): Integer; //подсчет кол-ва карт в кучке
     procedure CleareDesktop;   //Очистка рабочего стола
  public
    { Public declarations }
  end;

const
  {Left, Top Координаты карт в раскладе}
  arrLT : array[1..18,1..2] of Integer = (
          (8,8), (144,8), (280,8), (416,8), (552,8),
          (8,112), (144,112), (280,112), (416,112), (552,112),
          (8,216), (144,216), (280,216), (416,216), (552,216),
          (112,320), (328,320), (472,320));
  NRskld = 3;   //Допаустимо раскладов
var
  FormLucia: TFormLucia;
  SelCard,
  SelCard1: TCard;      //Выбранные карты
//  List: TList;
  arrRasklad: TarrRasklad;
  Rasklad: Integer;    //Кол-во произведенных раскладов

implementation

{$R *.DFM}
{- Подсчет кол-ва карт в кучке}
function TFormLucia.Cnt(n: Integer): Integer;
Var
  a: Integer;
begin
  Result := 0;
  for a := 1 to 3 do
    if arrRasklad[n,a] <> Nil then Inc(Result);
end;

{- Убрать карты с рабочего стола}
procedure TFormLucia.CleareDesktop;
var
  i,r: Integer;
begin
  for r := 1 to 18 do begin
    for i := 1 to 3 do
     begin
       SelCard := arrRasklad[r,i];
       SelCard.Free;
       arrRasklad[r,i] := Nil;
     end;
  end;
  SelCard := nil;
end;
{ -Обработчик карты из кучки }
procedure TFormLucia.CardClick(Sender: TObject);
Var
  ind,ind1,     //кол-во карт в старом и новом столбце
  oldCol: Integer;       //номер старой кучки
begin
  if (SelCard <> Nil) then
  begin
    ind := Cnt((Sender as TCard).Tag); //кол-во карт в новом столбце
    if ((ind < 3) and ((Sender as TCard).Invert = False)) and
     (SelCard.CardValue = (Sender as TCard).CardValue-1)  then //выкладывать только в нисходящем порядке
      begin       //Положить карту в другой столбец
        oldCol := SelCard.Tag;          //старый столбец
        ind1 := Cnt(OldCol);           //кол-во карт в старом столбце
        SelCard.Left := (Sender as TCard).Left+24;
        SelCard.Top := (Sender as TCard).Top;
        SelCard.Invert := False;
        SelCard.Tag := (Sender as TCard).Tag;  //№ кучки использовать Tag!!
        SelCard.BringToFront;
        //Убираем карту из исходного столбца
        arrRasklad[OldCol,ind1] := Nil;
        Dec(ind1);
        //Добавляем карту в новый столбец
        arrRasklad[SelCard.Tag, ind+1] := SelCard;
        Inc(ind);
        //Делаем предпоследнюю карту в старом столбце активной, если он не пустой
        if ind1 > 0 then
        begin
          SelCard1 := arrRasklad[oldCol,ind1];
          SelCard1.Enabled := True;
          arrRasklad[oldCol,ind1] := SelCard1;
          SelCard := Nil;
        end;
        //Последнюю карту в новом столбце делаем неактивной, т.к. она уже предпоследняя
        (Sender as TCard).Enabled := False;
        SelCard := Nil;
      end else
      begin     //Отменяем выделение
        SelCard.Invert := False;
        SelCard := Nil;
      end; //if
    end else if ((Sender as TCard).Invert = False) then
    begin
    //Взять карту
      SelCard := (Sender as TCard);
      SelCard.Invert := True;
    end;
end;
{ -Закрытие формы }
procedure TFormLucia.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if MessageDlg('Закончить игру?', mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    CleareDesktop;
    Coloda1.ClearColod;
//    Action := caFree;
    Application.Terminate;
  end;
end;
{ -Создание формы }
procedure TFormLucia.FormCreate(Sender: TObject);
begin
  {- cоздание колоды}
  Coloda1.ToFormColod;
  Coloda1.ColodTas;
end;
{ -Обработчик карты "дома" }
procedure TFormLucia.BazaClick(Sender: TObject);
Var
  oldCol, ind: Integer;
begin
  if (SelCard <> Nil) then
  begin
    if (((Sender as TCard).CardStyle = scNone) and (SelCard.CardValue = 1)) or
       ((SelCard.CardValue = (Sender as TCard).CardValue+1) and
        (SelCard.Suit = (Sender as TCard).Suit)) then
    begin
      oldCol := SelCard.Tag;
      if ((Sender as TCard).CardStyle = scNone) then
        (Sender as TCard).CardStyle := scFront;
      (Sender as TCard).Suit := SelCard.Suit;
      (Sender as TCard).CardValue := SelCard.CardValue;
      //Убираем карту из исходного столбца
      ind := Cnt(SelCard.Tag);
      arrRasklad[oldcol,ind] := Nil;
      //Делаем предпоследнюю карту в старом столбце активной, если он не пустой
      ind := Cnt(SelCard.Tag);
      if ind > 0 then
      begin
        SelCard1 := arrRasklad[oldCol, ind];
        SelCard1.Enabled := True;
        arrRasklad[oldCol, ind] := SelCard1;
        SelCard1 := Nil;
      end;
      SelCard.Free;     //Удалить карту
      SelCard := Nil;
    end;
  end;
end;
{ -Начать игру }
procedure TFormLucia.NewGame1Click(Sender: TObject);
Var
  r,c,Ind: Integer;
  SelCard: TCard;
  Crd: PCrd;
begin
  Setting1.Enabled := True;
  CleareDesktop;
  Rasklad := 1;
  Coloda1.ColodTas;
  Ind := 0;     //№ карты в колоде
  c := 0;       //№ карты в кучке
  r := 1;       //№ кучки
  //расклад
  repeat
    SelCard := TCard.Create(Self);
    if c < 3 then
       Inc(c) else
       c := 1;
    case c of
      1 : SelCard.Left := arrLT[r,1];
      2 : SelCard.Left := arrLT[r,1]+24;
      3 : SelCard.Left := arrLT[r,1]+48
    end;
    SelCard.Top := arrLT[r,2];
    SelCard.Tag := r;
    SelCard.Show;
    SelCard.Parent := Self;
    Crd := Coloda1.GetCard(Ind);
    SelCard.CardValue := Crd^.V;
    SelCard.Suit := Crd^.S;
    if (c = 3) or (Ind = Coloda1.Count-1) then
      SelCard.Enabled := True else
      SelCard.Enabled := False;
    SelCard.Tag := r; //столбец в котором находится карта
    SelCard.OnClick := CardClick;
    SelCard.BringToFront;
    arrRasklad[r,c] := SelCard;
    Inc(Ind);
    if c = 3 then
      Inc(r);
  until Ind = Coloda1.Count;
  Card1.CardStyle := scNone;
  Card2.CardStyle := scNone;
  Card3.CardStyle := scNone;
  Card4.CardStyle := scNone;
end;
{ -Переложить расклад }
procedure TFormLucia.Setting1Click(Sender: TObject);
Var
  i, r, col, col1, index: Integer;
  List1: TList;
begin
    //Собираем карты в колоду
    List1 := TList.Create;
    for i := 1 to 18 do       //Собираем карты с конца, с верхней карты в кучке
      for col := 1 to 3 do
      begin
        if arrRasklad[i,col] <> nil then
          begin
            SelCard := arrRasklad[i,col];
            List1.Add(SelCard);
            arrRasklad[i,col] := Nil;
          end
      end;
    //Тасовка колоды
    Randomize;
    for i := 0 to List1.Count-1 do
    begin
      repeat
        r := Random(32);
      until ((r > i) or (r < i)) and ((r > 0) and (r<List1.Count-1));
      List1.Exchange(i, r);
    end; //for
    col1 := 0;
    Index := 1;
    i := 0;
    repeat
      SelCard := List1.Items[i];
      if col1 < 3 then
       Inc(Col1) else
       Col1 := 1;
    case col1 of
        1 : SelCard.Left := arrLT[Index,1];
        2 : SelCard.Left := arrLT[Index,1]+24;
        3 : SelCard.Left := arrLT[Index,1]+48
    end;
    SelCard.Top := arrLT[Index,2];
    if (col1 = 3) or (i = List1.Count-1) then
      SelCard.Enabled := True else
      SelCard.Enabled := False;
    SelCard.Invert := False;
    SelCard.Tag := Index;
    SelCard.BringToFront;
    arrRasklad[Index,col1] := SelCard;
    SelCard := Nil;
    if col1 = 3 then
      Inc(Index);
    Inc(i);
  until i = List1.Count;
  List1.Clear;
  List1.Free;
  SelCard := Nil;
  Inc(Rasklad);
  if Rasklad = 3 then
  begin
    Setting1.Enabled := False;
  end;
end;

procedure TFormLucia.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.
