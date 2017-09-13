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
    Lst1.Items.Add(Format('jdk 设置成功! %s', [jdkPath]))
    else
      Lst1.Items.Add(Format('jdk 设置失败! %s', [jdkPath]))
  else
    Lst1.Items.Add(Format('目录选择不正确! %s', [jdkPath]));

  tomcatPath := edtTomcat.Text;
  if (Length(Trim(tomcatPath)) > 0) then
    if envMgr.SetTomcatEnvironment(tomcatPath) then
      Lst1.Items.Add(Format('Tomcat 设置成功! %s', [tomcatPath]))
    else
      Lst1.Items.Add(Format('Tomcat 设置失败! %s', [tomcatPath]));

  mavenPath := edtMaven.Text;
  if (Length(Trim(mavenPath)) > 0) then
    if envMgr.SetMavenEnvironment(mavenPath) then
    begin
      Lst1.Items.Add(Format('Maven 设置成功!! %s', [mavenPath]));
    end
    else
      Lst1.Items.Add(Format('Maven 设置失败!! %s', [mavenPath]));
end;

procedure TForm1.btnMavenClick(Sender: TObject);
begin
  edtMaven.Text := GetDirectory('请选择 Maven 安装目录');
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
  edtJDK.Text := GetDirectory('请选择 JDK 安装目录');
end;

procedure TForm1.btnTomcatClick(Sender: TObject);
var
  tmpPath: string;
begin
  edtTomcat.Text := GetDirectory('请选择 Tomcat 安装目录');

  tmpPath := edtTomcat.Text;
  if Length(Trim(tmpPath)) = 0 then
    exit;

  if not VerifityTomcatDir(tmpPath) then
  begin
    Lst1.Items.Add(Format('目录选择不正确! %s', [edtTomcat]));
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
  过程名:    TForm1.VerifityJDKDir
  作者:      robert
  日期:      2017.09.12
  参数:      _Path: String
  返回值:    String
  说明:      验证JDK目录是否正确	
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

