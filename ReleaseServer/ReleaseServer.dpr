program ReleaseServer;
{$APPTYPE GUI}

uses
  FMX.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  fMain in 'fMain.pas' {frmMain},
  uWeb in 'uWeb.pas' {WebModule1: TWebModule},
  uTools in 'uTools.pas',
  uReleaseClientLib in 'uReleaseClientLib.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
