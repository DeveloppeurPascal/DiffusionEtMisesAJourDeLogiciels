unit uReleaseClientLib;

interface

type
  TReleaseClientNewReleaseProc = reference to procedure(DownloadURL: string);
  TReleaseClientNoNewReleaseProc = reference to procedure;
  TReleaseClientHTTPErrorProc = reference to procedure(StatusCode: Integer;
    StatusText: string);

  TReleaseClientLib = class
    class function getProgramName: string;
    class function getProgramDate: string;
    class procedure setServeurURL(URL: string);
    class procedure checkNewReleaseURL(Programme, VersionNumber: string;
      NewReleaseExistsProc: TReleaseClientNewReleaseProc = nil;
      NoNewReleaseProc: TReleaseClientNoNewReleaseProc = nil;
      ReleaseClientHTTPErrorProc: TReleaseClientHTTPErrorProc = nil);
    class function getPlateformeName: string;
  end;

implementation

uses
  System.Net.HttpClient, System.Threading, System.SysUtils, System.Classes,
  System.StrUtils, System.IOUtils;

var
  ServeurURL: string;
  { TReleaseClientLib }

class procedure TReleaseClientLib.checkNewReleaseURL(Programme,
  VersionNumber: string; NewReleaseExistsProc: TReleaseClientNewReleaseProc;
  NoNewReleaseProc: TReleaseClientNoNewReleaseProc;
  ReleaseClientHTTPErrorProc: TReleaseClientHTTPErrorProc);
begin
  if ServeurURL.isempty then
    raise exception.create('Call setServeurURL to init API.');

  // TODO : vérifier la validité des paramètres, quitter en cas d'erreur

  ttask.Run(
    procedure
    var
      Plateforme: string;
      Serveur: THTTPClient;
      Reponse: IHTTPResponse;
      URL: string;
      DownloadURL: string;
    begin
      Plateforme := getPlateformeName;
      Serveur := THTTPClient.create;
      try
        // TODO : ajouter un code de validation à recalculer côté serveur pour s'assurer que la demande vient bien d'un programme correct avec éventuellement un générateur de nombres uniques comme par exemple LogNPass
        // TODO : encoder les paramètres dans le format d'URL
        URL := ifthen(ServeurURL.endswith('/'), ServeurURL, ServeurURL + '/') +
          'GetLastRelease?pr=' + Programme + '&pl=' + Plateforme + '&vn=' +
          VersionNumber;
        Reponse := Serveur.get(URL);
        DownloadURL := Reponse.ContentAsString(tencoding.UTF8);
        if (Reponse.StatusCode = 200) and (not DownloadURL.isempty) and
          assigned(NewReleaseExistsProc) then
          tthread.queue(nil,
            procedure
            begin
              NewReleaseExistsProc(DownloadURL);
            end)
        else if (Reponse.StatusCode = 404) and assigned(NoNewReleaseProc) then
          tthread.queue(nil,
            procedure
            begin
              NoNewReleaseProc;
            end)
        else if assigned(ReleaseClientHTTPErrorProc) then
          tthread.queue(nil,
            procedure
            begin
              ReleaseClientHTTPErrorProc(Reponse.StatusCode,
                Reponse.StatusText);
            end);
      finally
        Serveur.free;
      end;
    end);
end;

class function TReleaseClientLib.getPlateformeName: string;
begin
{$IF Defined(ANDROID32)}
  result := 'Android32';
{$ELSEIF Defined(ANDROID64)}
  result := 'Android64';
{$ELSEIF Defined(IOS32)}
  result := 'iOS32';
{$ELSEIF Defined(IOS64)}
  result := 'iOS64';
{$ELSEIF Defined(LINUX64)}
  result := 'Linux64';
{$ELSEIF Defined(MACOS32)}
  result := 'macOS32';
{$ELSEIF Defined(MACOS64)}
  result := 'macOS64';
{$ELSEIF Defined(WIN32)}
  result := 'Win32';
{$ELSEIF Defined(WIN64)}
  result := 'Win64';
{$ELSE}
{$MESSAGE FATAL 'Plateforme non gérée'}
{$ENDIF}
end;

class function TReleaseClientLib.getProgramDate: string;
begin
  result := FormatDateTime('yyyymmddhhnnss',
    tfile.GetLastWriteTime(paramstr(0)))
end;

class function TReleaseClientLib.getProgramName: string;
begin
  result := tpath.GetFileNameWithoutExtension(paramstr(0));
end;

class procedure TReleaseClientLib.setServeurURL(URL: string);
begin
  ServeurURL := URL;
end;

initialization

ServeurURL := '';

end.
