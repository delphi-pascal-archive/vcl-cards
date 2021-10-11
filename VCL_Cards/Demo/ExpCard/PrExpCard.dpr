program PrExpCard;

uses
  Forms,
  fExpCard in 'fExpCard.pas' {ExpCrdForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TExpCrdForm, ExpCrdForm);
  Application.Run;
end.
