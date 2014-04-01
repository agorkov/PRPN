unit UFMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFMain = class(TForm)
    LESource: TLabeledEdit;
    LEResult: TLabeledEdit;
    BStep: TButton;
    LEStack: TLabeledEdit;
    BDoIt: TButton;
    procedure LESourceExit(Sender: TObject);
    procedure BStepClick(Sender: TObject);
    procedure BDoItClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}
uses
  OPN;

///
///  Когда формула введена, надо
///  добавить признаки начала
///  и конца.
///
procedure TFMain.LESourceExit(Sender: TObject);
begin
  LESource.Text:='"'+LESource.Text+'"';

  OPN.gSOURCE:=LESource.Text;
end;

///
///  Показ промежуточных результатов
///
procedure ShowResult;
begin
  FMain.LEStack.Text:=OPN.gSTACK;
  FMain.LEResult.Text:=OPN.gRESULT;
end;

///
///  Один шаг преобразования
///
procedure TFMain.BDoItClick(Sender: TObject);
begin
  repeat
  until OPN.Step>=4;
  ShowResult;
end;

///
///  Немедленное преобразование
///
procedure TFMain.BStepClick(Sender: TObject);
begin
  OPN.Step;
  ShowResult;
end;

end.
