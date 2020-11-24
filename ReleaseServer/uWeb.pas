unit uWeb;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  TWebModule1 = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1waGetLastReleaseAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

uses
  uTools, System.IOUtils;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := '<html>' +
    '<head><title>Application Serveur Web</title></head>' +
    '<body>Application Serveur Web</body>' + '</html>';
end;

procedure TWebModule1.WebModule1waGetLastReleaseAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  Programme, Plateforme, VersionNumber: string;
  chemin: string;
begin // http://localhost:8080/GetLastRelease?pr=&pl=&vn=
  // TODO : vérifier le code de contrôle de l'URL, 2FA ou autre moyen de sécurité ajouté à l'API
  try
    Programme := Request.QueryFields.Values['pr'].trim;
  except
    Programme := '';
  end;
  try
    Plateforme := Request.QueryFields.Values['pl'].trim;
  except
    Plateforme := '';
  end;
  try
    VersionNumber := Request.QueryFields.Values['vn'].trim;
  except
    VersionNumber := '';
  end;
  chemin := TTools.getLastReleasePath(Programme, Plateforme);
  if (not chemin.isempty) and (chemin > TTools.getReleasePath(Programme,
    Plateforme, VersionNumber)) and tfile.Exists(chemin) then
  begin
    Response.ContentType := 'text/plain';
    Response.Content := tfile.readalltext(chemin, tencoding.UTF8);
  end
  else
    Response.StatusCode := 404;
end;

end.
