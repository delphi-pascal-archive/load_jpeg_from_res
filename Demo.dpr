program Demo;

uses
  Forms,
  UMain in 'UMain.pas' {frm_Main},
  crJPEG in 'crJPEG.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Load JPEG From Resource by Cirec';
  Application.CreateForm(Tfrm_Main, frm_Main);
  Application.Run;
end.
