program Lucia;

uses
  Forms,
  fLucia in 'fLucia.pas' {FormLucia};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '���������� �����';
  Application.CreateForm(TFormLucia, FormLucia);
  Application.Run;
end.
