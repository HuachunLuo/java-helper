unit uEnvironmentMgr;

interface

uses
  Registry, Windows, SysUtils, Classes;

type
  TEnvironmentMgr = class(TObject)
  private
    Reg: TRegistry;
  public
    function GetJDKCurrentVersion: string;
    function getJDKCurrentDir: string;
    function SetJdkEnvironment(const _JDKPath: string): Boolean;
    function SetTomcatEnvironment(const _TomcatPath: string): Boolean;
    function SetMavenEnvironment(const _MavenPath: string): Boolean;
    constructor create;
    destructor destroy; override;
  end;

implementation

uses
  uConst, Dialogs;

constructor TEnvironmentMgr.create;
begin
  Reg := TRegistry.Create;
end;

destructor TEnvironmentMgr.destroy;
begin
  inherited destroy;
  FreeAndNil(Reg);
end;

function TEnvironmentMgr.getJDKCurrentDir: string;
{-------------------------------------------------------------------------------
  过程名:    TEnvironmentMgr.getJDKCurrentDir
  作者:      robert
  日期:      2017.09.13
  参数:      无
  返回值:    String
  说明:      取得当前JDK的安装目录。	
-------------------------------------------------------------------------------}
var
  sVersion: string;
begin
  Result := '';
  sVersion := GetJDKCurrentVersion;
  if sVersion = '' then
  begin
    ShowMessage('无法取得版本号');
    exit;
  end;

  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if reg.OpenKey(Format('\SOFTWARE\JavaSoft\Java Development Kit\%s', [sVersion]), False) then
  begin
    if reg.ValueExists('JavaHome') then
    begin
      Result := Reg.ReadString('JavaHome');
    end
    else begin
      ShowMessage('无法取得javahome');
      exit;
    end;
  end
  else  begin
    ShowMessage('无法打开节点');
    exit;
  end;
end;

function TEnvironmentMgr.GetJDKCurrentVersion: string;
{-------------------------------------------------------------------------------
  过程名:    TEnvironmentMgr.GetJDKCurrentVersion
  作者:      robert
  日期:      2017.09.13
  参数:      无
  返回值:    String
  说明:      取得当前jdk版本号。如果无版本号。则返回为空。
	
-------------------------------------------------------------------------------}
begin
  Result := '';
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if reg.OpenKey('\SOFTWARE\JavaSoft\ABD', False) then
  begin
    if Reg.ValueExists('CurrentVersion') then
    begin
      Result := reg.ReadString('CurrentVersion');
    end
    else begin
      ShowMessage('无法打开 CurrentVersion');
     // exit;
    end;
    Reg.CloseKey;
  end
  else
  begin
//    HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit
    ShowMessage('无法打开 \SOFTWARE\JavaSoft\Java Development Kit');
    //exit;
  end;
end;

function TEnvironmentMgr.SetJdkEnvironment(const _JDKPath: string): Boolean;
var
  PathList: TStrings;
  idx: Integer;
begin
  try
    result := False;
    try
      PathList := TStringlist.Create;
      PathList.Delimiter := ';';
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if reg.OpenKey('\SYSTEM\CurrentControlSet\Control\Session Manager\Environment', False) then
      begin
    //%JAVA_HOME%\BIN;%JAVA_HOME%\jre\bin
    
    //JAVA_HOME
        if reg.ValueExists(REGST_JAVA_HOME) then
          Reg.DeleteKey(REGST_JAVA_HOME);
        Reg.WriteString(REGST_JAVA_HOME, _JDKPath);

    //JAVA_CLASS
        if reg.ValueExists(REGST_CLASS_PATH) then
          reg.DeleteKey(REGST_CLASS_PATH);
        Reg.WriteString(REGST_CLASS_PATH, '.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar');

        if reg.ValueExists('PATH') then
        begin
          PathList.DelimitedText := reg.ReadString('PATH');

          idx := PathList.IndexOf('%JAVA_HOME%\BIN');
          if idx = -1 then
          begin
            PathList.Add('%JAVA_HOME%\BIN');
          end;

          idx := PathList.IndexOf('%%JAVA_HOME%\jre\bin');
          if idx = -1 then
          begin
            PathList.Add('%JAVA_HOME%\jre\bin');
          end;
          reg.WriteString('PATH', PathList.DelimitedText);
        end;
        reg.CloseKey;
      end;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create(e.Message);
    end;
  finally
    FreeAndNil(PathList);
  end;
end;

function TEnvironmentMgr.SetMavenEnvironment(const _MavenPath: string): Boolean;
{-------------------------------------------------------------------------------
  过程名:    TEnvironmentMgr.SetMavenEnvironment
  作者:      robert
  日期:      2017.09.12
  参数:      const _MavenPath: string
  返回值:    无
  说明:      设置 Maven环境变量	
-------------------------------------------------------------------------------}
var
  PathList: TStrings;
  idx: Integer;
begin
  Result := False;
  try
    try
      PathList := TStringlist.Create;
      PathList.Delimiter := ';';
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if reg.OpenKey('\SYSTEM\CurrentControlSet\Control\Session Manager\Environment', False) then
      begin
        if reg.ValueExists(MAVEN_HOME) then
          Reg.DeleteKey(MAVEN_HOME);

        Reg.WriteString(MAVEN_HOME, _MavenPath);

        if Reg.ValueExists('PATH') then
        begin
          PathList.DelimitedText := Reg.ReadString('PATH');

          idx := PathList.IndexOf('%MAVEN_HOME%\bin');
          if idx = -1 then
          begin
            PathList.Add('%MAVEN_HOME%\bin');
          end;
          reg.WriteString('PATH', PathList.DelimitedText);
        end;

        Reg.CloseKey;

      end;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create(e.Message);
    end;
  finally
    FreeAndNil(PathList);
  end;
end;

function TEnvironmentMgr.SetTomcatEnvironment(const _TomcatPath: string): Boolean;
{-------------------------------------------------------------------------------
  过程名:    TEnvironmentMgr.SetTomcatEnvironment
  作者:      robert
  日期:      2017.09.12
  参数:      const _TomcatPath: string
  返回值:    无
  说明:      设置Tomcat环境变量	
-------------------------------------------------------------------------------}
var
  PathList: TStrings;
  idx: Integer;
begin
  Result := False;
  try
    try
      PathList := TStringlist.Create;
      PathList.Delimiter := ';';
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if reg.OpenKey('\SYSTEM\CurrentControlSet\Control\Session Manager\Environment', False) then
      begin
    //：%CATALINA_HOME%\lib;%CATALINA_HOME%\bin
    //CATALINA_BASE
        if reg.ValueExists(CATALINA_BASE) then
          Reg.DeleteKey(CATALINA_BASE);
        Reg.WriteString(CATALINA_BASE, _TomcatPath);

    //CATALINA_HOME
        if reg.ValueExists(CATALINA_HOME) then
          reg.DeleteKey(CATALINA_HOME);
        Reg.WriteString(CATALINA_HOME, _TomcatPath);

        if reg.ValueExists('PATH') then
        begin
          PathList.DelimitedText := reg.ReadString('PATH');

          idx := PathList.IndexOf('%CATALINA_HOME%\lib');
          if idx = -1 then
          begin
            PathList.Add('%CATALINA_HOME%\lib');
          end;

          idx := PathList.IndexOf('%CATALINA_HOME%\bin');
          if idx = -1 then
          begin
            PathList.Add('%CATALINA_HOME%\bin');
          end;
          reg.WriteString('PATH', PathList.DelimitedText);
        end;
        reg.CloseKey;
      end;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create(e.Message);
    end;
  finally
    FreeAndNil(PathList);
  end;
end;

end.

