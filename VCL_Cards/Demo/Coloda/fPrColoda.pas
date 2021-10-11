unit fPrColoda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Coloda, CARD, FncVCGm, Spin;

type
  TForm1 = class(TForm)
    Card1: TCard;
    Coloda1: TColoda;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    EdSuit: TComboBox;
    EdValue: TSpinEdit;
    Button5: TButton;
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ID : Integer; //������� ����� � ������
  Crd : PCrd;   //����� � ������ (�����,�����������)
implementation

{$R *.dfm}

procedure TForm1.Button4Click(Sender: TObject);
begin
  //������������� ��� ������
  case RadioGroup1.ItemIndex of
    0 : Coloda1.ColodType := tcFull;
    1 : Coloda1.ColodType := tcDoubleFull;
    2 : Coloda1.ColodType := tcPicket;
  end;
  //������� ������
  Coloda1.ClearColod;
  //��������� ����� ������
  Coloda1.ToFormColod;
  //������� ������ �����
  ID := 0;
  Crd := Coloda1.GetCard(ID);
  Card1.Suit := Crd^.S;
  Card1.CardValue := Crd^.V;
  Card1.Pile := True;
  Card1.CardStyle := scFront;

  Label1.Caption := '���� � ������: '+ IntToStr(Coloda1.Count);
  Label2.Caption := IntToStr(ID);
  Button1.Enabled := True;
  Button2.Enabled := True;
  Button3.Enabled := True;
  Button5.Enabled := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  //������ ������
  Coloda1.ColodTas;
  //������� ������ �����
  ID := 0;
  Crd := Coloda1.GetCard(ID);
  Card1.Suit := Crd^.S;
  Card1.CardValue := Crd^.V;
  Label2.Caption := IntToStr(ID);
end;

{ -���������� ����� � ������ }
procedure TForm1.Button1Click(Sender: TObject);
begin
  Dec(ID);
  if ID >= 0 then
  begin
    Crd := Coloda1.GetCard(ID);
    Card1.Suit := Crd^.S;
    Card1.CardValue := Crd^.V;
  end else ID := 0;
  Label2.Caption := IntToStr(ID);
end;
{ -��������� ����� � ������ }
procedure TForm1.Button2Click(Sender: TObject);
begin
  Inc(ID);
  if ID <= Coloda1.Count-1 then
  begin
    Crd := Coloda1.GetCard(ID);
    Card1.Suit := Crd^.S;
    Card1.CardValue := Crd^.V;
  end else ID := Coloda1.Count-1;
  Label2.Caption := IntToStr(ID);
end;

procedure TForm1.Button5Click(Sender: TObject);
Var
  i: Integer;
begin
  i := Coloda1.FindCard(EdValue.Value,TSuit(EdSuit.ItemIndex));
  if i <> -1 then
  begin
    Crd := Coloda1.GetCard(i);
    Card1.Suit := Crd^.S;
    Card1.CardValue := Crd^.V;
  end;
end;

end.
