program MainForm;

uses
  Forms,
  uMainForm in 'uMainForm.pas' {Form1},
  uConst in 'uConst.pas',
  uEnvironmentMgr in 'uEnvironmentMgr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
