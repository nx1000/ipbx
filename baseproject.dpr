program baseproject;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  collection in 'collection.pas',
  dbfunc in 'dbfunc.pas',
  fofunc in 'fofunc.pas',
  genfunc in 'genfunc.pas',
  Unit2 in 'Unit2.pas' {dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmPhoneCharge, fmPhoneCharge);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
