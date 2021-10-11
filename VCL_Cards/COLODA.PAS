(****************************************************************************}
{Unit: Coloda                                                                }
{Date: 30.10.2002                                                            }
{Version: 1.0                                                                }
{Notes: Невизуальный компонент "колода карт". Формирует колоду в 52,
104(двойная) и 32 листа. Хранит данные о масти и достоинстве каждой карты.
****************************************************************************)
unit Coloda;

interface
uses Classes, FncVCGm;
type

//  TSuit = (cChervi, cBubny, cCresti, cPiki, cJoker);    // Тип "масть"

{  TCrd = record //Данные о карте
    S: TSuit;
    V: Integer;
  end;
  PCrd = ^TCrd;
 }
  TTypeColod = (tcFull, tcDoubleFull, tcPicket);        //колода: полная, двойная, пикетная

  TColoda = class(TComponent)
  private
    FCrd: PCrd;
    FColoda: TList;
    FTypeColod: TTypeColod;
    FUseJoker: Boolean;
//    FCount: Integer;
    procedure SetTypeColod(NewValue: TTypeColod);
    procedure SetUseJoker(NewValue: Boolean);
  public
//    property Cards[Indx: Integer]: Pointer write SetCard read GetCard;
    function Count: Integer;
//    property Count: Integer write SetCount;
    constructor Create(AOwner: TComponent); override;
  published
    property ColodType: TTypeColod read FTypeColod write SetTypeColod;
    property UseJoker: Boolean read FUseJoker write SetUseJoker default False;
    procedure ToFormColod;  //Создать
    function GetCard(Indx: Integer): PCrd;     //Получить карту
    function FindCard(V: Integer; S: TSuit): Integer; //Найти карту
    function DelCard(Indx: Integer): Boolean;  //Удалить указатель на карту
    function AddCard(P: PCrd): Boolean;        // Добавить карту в конец списка
    procedure ColodTas;         //Тасовать
    procedure ClearColod;       //Уничтожить
end;
  procedure Register;

implementation
{$R *.res}
procedure TColoda.SetTypeColod(NewValue: TTypeColod);
begin
  FTypeColod := NewValue;
end;

procedure TColoda.SetUseJoker(NewValue: Boolean);
begin
  FUseJoker := NewValue;
end;

{- Кол-во карт в колоде}
function TColoda.Count: Integer;
begin
  Result := FColoda.Count;
end;

constructor TColoda.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTypeColod := tcFull;
end;

  {- Сформировать колоду N - кол-во полных колод}
procedure TColoda.ToFormColod;
Var
  k,s,v, V1, N: Integer;
begin
  if FColoda <> Nil then Exit;
  FColoda := TList.Create;
  V1 := 1;
  N := 0;
  if FUseJoker then //Добавление джокеров
  begin
    if FTypeColod = tcFull then //Определение кол-ва джокеров
      N := 2
    else if FTypeColod = tcDoubleFull then
      N := 4;
    for k := 1 to N do
    begin
      New(FCrd);
      FCrd^.S := cJoker;
      FCrd^.V := 0;
      FColoda.Add(FCrd);
    end;
  end;
  case FTypeColod of
    tcDoubleFull:  N := 2;
    tcFull: N := 1;
    tcPicket: begin
                N := 1;
                V1 := 6;
              end;
  end;
  for k := 1 to N do        //кол-во колод
    for s := 0 to 3 do      //мастей
      for v := V1 to 13 do  //карт каждой масти
        begin
          New(FCrd);
          FCrd^.S := TSuit(s);
          FCrd^.V := v;
          FColoda.Add(FCrd);
        end; //for
end;
{-Получить значение карты}
function TColoda.GetCard(Indx: Integer): PCrd;
begin
  Result := FColoda[Indx];
end;
{ -Возвращает индекс заданной карты }
function TColoda.FindCard(V: Integer; S: TSuit): Integer;
Var
  k: Integer;
begin
  Result := -1;
  for k := 0 to FColoda.Count-1  do
  begin
    FCrd := FColoda[k];
    if (FCrd^.V = V) and (FCrd^.S = S) then begin
      Result := k;
      Exit;
    end;
  end;
end;

{-Удалить карту}
function TColoda.DelCard(Indx: Integer): Boolean;
begin
  Result := True;
  try
  //Удаляет из списка только указатель, не трогая содержимое ячейки
  //    FCrd := FColoda[Indx];
  //    Dispose(FCrd);
    FColoda.Delete(Indx);
  except
    Result := False;
  end;

//  Result := ^FCrd;
end;
{ Добавить карту в конец списка }
function TColoda.AddCard(P: PCrd): Boolean;      // Добавить карту в конец списка
begin
  Result := True;
  try
{    New(FCrd);
    FCrd^.S := S;
    FCrd^.V := V;}
    FColoda.Add(P);
//    P := FCrd;
  except
    Result := False;
  end;
end;
{-Тасовать колоду}
procedure TColoda.ColodTas;
Var
  i, r: Integer;
begin
  if FColoda = Nil then Exit;
  Randomize;
  for i := 0 to FColoda.Count-1 do
  begin
    repeat
      r := Random(32);
    until ((r > i) or (r < i)) and (r > 0);
    FColoda.Exchange(i, r);
  end; //for
end;
{-Очистить колоду}
procedure TColoda.ClearColod;
Var
  k: Integer;
begin
  if FColoda = Nil then Exit;
  for k := 0 to FColoda.Count-1 do
  begin
    FCrd := FColoda[k];
    Dispose(FCrd);
  end;
  FColoda.Free;
  FColoda := Nil;
end;

procedure Register;
begin
  RegisterComponents('VCLCards', [TColoda]);
end;

end.