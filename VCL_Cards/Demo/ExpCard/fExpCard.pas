unit fExpCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, EXPCARD, FileCtrl, Spin,
  FncVCGm, ImgList;

type
  TExpCrdForm = class(TForm)
    RadioGroup1: TRadioGroup;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    ComboBox2: TComboBox;
    Label3: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ExpandedCard2: TExpandedCard;
    ImageList1: TImageList;
    ImageList2: TImageList;
    procedure RadioGroup1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ExpandedCard2Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExpCrdForm: TExpCrdForm;

implementation

{$R *.dfm}

procedure TExpCrdForm.RadioGroup1Click(Sender: TObject);
begin
  case TRadioGroup(Sender).ItemIndex of
   0 : ExpandedCard2.CardStyle := scFront;
   1 : ExpandedCard2.CardStyle := scBack;
   2 : ExpandedCard2.CardStyle := scZero;
   3 : ExpandedCard2.CardStyle := scX;
   4 : ExpandedCard2.CardStyle := scBlank;
   5 : ExpandedCard2.CardStyle := scNone;
  end;

end;

procedure TExpCrdForm.SpinEdit1Change(Sender: TObject);
begin
  ExpandedCard2.CardValue := TSpinEdit(Sender).Value;
end;

procedure TExpCrdForm.ComboBox1Change(Sender: TObject);
begin
  ExpandedCard2.Suit := TSuit(TComboBox(Sender).ItemIndex);
end;

procedure TExpCrdForm.CheckBox1Click(Sender: TObject);
begin
  ExpandedCard2.Pile := TCheckBox(Sender).Checked;
end;
{ -Горизонтальное/вертикальное положение карт. }
{ -На угловые положения не хватило знаний математики, я с ней не в ладах :) }
procedure TExpCrdForm.ComboBox2Change(Sender: TObject);
begin
  case TComboBox(Sender).ItemIndex of
   0 : ExpandedCard2.Rotation := orVertical;
   1 : ExpandedCard2.Rotation := orHorizontal;
  end;
end;
{ -Каталог, где лежат bmp c картинками карт }
procedure TExpCrdForm.ExpandedCard2Click(Sender: TObject);
begin
  if TExpandedCard(Sender).CardValue + 1 <= 13 then
  begin
    TExpandedCard(Sender).CardValue := TExpandedCard(Sender).CardValue + 1;
    SpinEdit1.Value := TExpandedCard(Sender).CardValue;
  end;
end;
{ -Выделение инвертированием }
procedure TExpCrdForm.CheckBox2Click(Sender: TObject);
begin
  ExpandedCard2.Invert := TCheckBox(Sender).Checked;
end;
{ -Черно-белое изображение карт. Для "рубашки", "X", "0", "подложка" ч/б картинок нет}
{В одной игрушке так выделялись места
для определенных карт и я решил, что это пригодится :)}
procedure TExpCrdForm.CheckBox3Click(Sender: TObject);
begin
  ExpandedCard2.Mask := TCheckBox(Sender).Checked;
end;

end.
