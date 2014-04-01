program PRPN;

uses
  Forms,
  UFMain in 'UFMain.pas' {FMain},
  OPN in 'OPN.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
