program Lucia;

uses
  Forms,
  fLucia in 'fLucia.pas' {FormLucia};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Прекрасная Люция';
  Application.CreateForm(TFormLucia, FormLucia);
  Application.Run;
end.
