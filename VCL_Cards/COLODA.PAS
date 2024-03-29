(****************************************************************************}
{Unit: Coloda                                                                }
{Date: 30.10.2002                                                            }
{Version: 1.0                                                                }
{Notes: ������������ ��������� "������ ����". ��������� ������ � 52,
104(�������) � 32 �����. ������ ������ � ����� � ����������� ������ �����.
****************************************************************************)
unit Coloda;

interface
uses Classes, FncVCGm;
type

//  TSuit = (cChervi, cBubny, cCresti, cPiki, cJoker);    // ��� "�����"

{  TCrd = record //������ � �����
    S: TSuit;
    V: Integer;
  end;
  PCrd = ^TCrd;
 }
  TTypeColod = (tcFull, tcDoubleFull, tcPicket);        //������: ������, �������, ��������

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
    procedure ToFormColod;  //�������
    function GetCard(Indx: Integer): PCrd;     //�������� �����
    function FindCard(V: Integer; S: TSuit): Integer; //����� �����
    function DelCard(Indx: Integer): Boolean;  //������� ��������� �� �����
    function AddCard(P: PCrd): Boolean;        // �������� ����� � ����� ������
    procedure ColodTas;         //��������
    procedure ClearColod;       //����������
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

{- ���-�� ���� � ������}
function TColoda.Count: Integer;
begin
  Result := FColoda.Count;
end;

constructor TColoda.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTypeColod := tcFull;
end;

  {- ������������ ������ N - ���-�� ������ �����}
procedure TColoda.ToFormColod;
Var
  k,s,v, V1, N: Integer;
begin
  if FColoda <> Nil then Exit;
  FColoda := TList.Create;
  V1 := 1;
  N := 0;
  if FUseJoker then //���������� ��������
  begin
    if FTypeColod = tcFull then //����������� ���-�� ��������
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
  for k := 1 to N do        //���-�� �����
    for s := 0 to 3 do      //������
      for v := V1 to 13 do  //���� ������ �����
        begin
          New(FCrd);
          FCrd^.S := TSuit(s);
          FCrd^.V := v;
          FColoda.Add(FCrd);
        end; //for
end;
{-�������� �������� �����}
function TColoda.GetCard(Indx: Integer): PCrd;
begin
  Result := FColoda[Indx];
end;
{ -���������� ������ �������� ����� }
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

{-������� �����}
function TColoda.DelCard(Indx: Integer): Boolean;
begin
  Result := True;
  try
  //������� �� ������ ������ ���������, �� ������ ���������� ������
  //    FCrd := FColoda[Indx];
  //    Dispose(FCrd);
    FColoda.Delete(Indx);
  except
    Result := False;
  end;

//  Result := ^FCrd;
end;
{ �������� ����� � ����� ������ }
function TColoda.AddCard(P: PCrd): Boolean;      // �������� ����� � ����� ������
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
{-�������� ������}
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
{-�������� ������}
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