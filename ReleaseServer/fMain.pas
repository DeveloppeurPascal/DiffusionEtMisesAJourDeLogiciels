unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, IdHTTPWebBrokerBridge, IdGlobal, Web.HTTPApp,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox;

type
  TfrmMain = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ButtonOpenBrowser: TButton;
    Layout1: TLayout;
    Layout2: TLayout;
    lblProgramme: TLabel;
    edtProgramme: TEdit;
    lblVersion: TLabel;
    edtVersion: TEdit;
    lblPlateforme: TLabel;
    cbPlateforme: TComboBox;
    GridPanelLayout1: TGridPanelLayout;
    btnOk: TButton;
    btnCancel: TButton;
    lblDownloadURL: TLabel;
    edtDownloadURL: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    { Déclarations privées }
    procedure initZoneAjoutRelease;
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  WinApi.Windows, WinApi.ShellApi, uTools;

procedure TfrmMain.ApplicationIdle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  initZoneAjoutRelease;
end;

procedure TfrmMain.btnOkClick(Sender: TObject);
begin
  if (edtProgramme.Text.IsEmpty) then
  begin
    edtProgramme.SetFocus;
    showmessage('programme obligatoire');
    exit;
  end;
  if (cbPlateforme.ItemIndex < 0) then
  begin
    cbPlateforme.SetFocus;
    showmessage('plateforme obligatoire');
    exit;
  end;
  if (edtVersion.Text.IsEmpty) then
  begin
    edtVersion.SetFocus;
    showmessage('version obligatoire');
    exit;
  end;
  if (edtDownloadURL.Text.IsEmpty) then
  begin
    edtDownloadURL.SetFocus;
    showmessage('URL obligatoire');
    exit;
  end;
  TTools.addRelease(edtProgramme.Text,
    cbPlateforme.Items[cbPlateforme.ItemIndex], edtVersion.Text,
    edtDownloadURL.Text);
  showmessage('Version ajoutée');
  // TODO : réinitialiser les champs de saisie
  edtProgramme.SetFocus;
  // initZoneAjoutRelease;
end;

procedure TfrmMain.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0, nil, PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TfrmMain.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TfrmMain.ButtonStopClick(Sender: TObject);
begin
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  Application.OnIdle := ApplicationIdle;
  ButtonStart.SetFocus;
end;

procedure TfrmMain.initZoneAjoutRelease;
begin
  edtProgramme.Text := '';
  cbPlateforme.ItemIndex := -1;
  edtVersion.Text := '';
  edtDownloadURL.Text := '';
  edtProgramme.SetFocus;
end;

procedure TfrmMain.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

end.
