unit uMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, uEnvironmentMgr;

type
  TForm1 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    edtJDK: TEdit;
    lbl1: TLabel;
    btnSelectDirectory: TSpeedButton;
    btn1: TBitBtn;
    lst1: TListBox;
    edtTomcat: TEdit;
    lbl2: TLabel;
    btnTomcat: TSpeedButton;
    lbl3: TLabel;
    edtMaven: TEdit;
    btnMaven: TSpeedButton;
    procedure btn1Click(Sender: TObject);
    procedure btnMavenClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelectDirectoryClick(Sender: TObject);
    procedure btnTomcatClick(Sender: TObject);
  private
    envMgr: TEnvironmentMgr;
    function VerifityJDKDir(_Path: string): Boolean;
    function VerifityTomcatDir(_Path: string): Boolean;
    function GetDirectory(ACaption: string): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  FileCtrl;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
  jdkPath, tomcatPath, mavenPath: string;
begin

  jdkPath := edtJDK.Text;
  if (Length(Trim(jdkPath)) > 0) and (VerifityJDKDir(jdkPath)) then
    if envMgr.SetJdkEnvironment(edtJDK.Text) then
    Lst1.Items.Add(Format('jdk ���óɹ�! %s', [jdkPath]))
    else
      Lst1.Items.Add(Format('jdk ����ʧ��! %s', [jdkPath]))
  else
    Lst1.Items.Add(Format('Ŀ¼ѡ����ȷ! %s', [jdkPath]));

  tomcatPath := edtTomcat.Text;
  if (Length(Trim(tomcatPath)) > 0) then
    if envMgr.SetTomcatEnvironment(tomcatPath) then
      Lst1.Items.Add(Format('Tomcat ���óɹ�! %s', [tomcatPath]))
    else
      Lst1.Items.Add(Format('Tomcat ����ʧ��! %s', [tomcatPath]));

  mavenPath := edtMaven.Text;
  if (Length(Trim(mavenPath)) > 0) then
    if envMgr.SetMavenEnvironment(mavenPath) then
    begin
      Lst1.Items.Add(Format('Maven ���óɹ�!! %s', [mavenPath]));
    end
    else
      Lst1.Items.Add(Format('Maven ����ʧ��!! %s', [mavenPath]));
end;

procedure TForm1.btnMavenClick(Sender: TObject);
begin
  edtMaven.Text := GetDirectory('��ѡ�� Maven ��װĿ¼');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(EnvMgr);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  envMgr := TEnvironmentMgr.create;

  edtJDK.Text := envMgr.getJDKCurrentDir;
end;

procedure TForm1.btnSelectDirectoryClick(Sender: TObject);
begin
  edtJDK.Text := GetDirectory('��ѡ�� JDK ��װĿ¼');
end;

procedure TForm1.btnTomcatClick(Sender: TObject);
var
  tmpPath: string;
begin
  edtTomcat.Text := GetDirectory('��ѡ�� Tomcat ��װĿ¼');

  tmpPath := edtTomcat.Text;
  if Length(Trim(tmpPath)) = 0 then
    exit;

  if not VerifityTomcatDir(tmpPath) then
  begin
    Lst1.Items.Add(Format('Ŀ¼ѡ����ȷ! %s', [edtTomcat]));
    exit;
  end;

  envMgr.SetTomcatEnvironment(tmpPath);
end;

function TForm1.GetDirectory(ACaption: string): string;
var
  aPath: string;
begin
  aPath := 'c;';
  if SelectDirectory(ACaption, '', aPath) then
    Result := aPath;
end;

function TForm1.VerifityJDKDir(_Path: string): Boolean;
{-------------------------------------------------------------------------------
  ������:    TForm1.VerifityJDKDir
  ����:      robert
  ����:      2017.09.12
  ����:      _Path: String
  ����ֵ:    String
  ˵��:      ��֤JDKĿ¼�Ƿ���ȷ	
-------------------------------------------------------------------------------}
var
  tmpPath: string;
begin
  tmpPath := _Path + '\Bin\java.exe';

  Result := FileExists(tmpPath);
end;

function TForm1.VerifityTomcatDir(_Path: string): Boolean;
begin

end;

end.

