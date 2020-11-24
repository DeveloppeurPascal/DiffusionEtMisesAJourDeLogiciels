unit uTools;

interface

type
  TTools = class
    class function getPath(Programme, Plateforme: string): string;
    class function getReleasePath(Programme, Plateforme, VersionNumber
      : string): string;
    class function getNextReleasePath(Programme, Plateforme,
      VersionNumber: string): string;
    class function getLastReleasePath(Programme, Plateforme: string): string;
    class procedure addRelease(Programme, Plateforme, VersionNumber,
      DownloadURL: string);
  end;

implementation

uses
  System.IOUtils, System.Classes, System.Types, System.SysUtils;

{ TTools }

class procedure TTools.addRelease(Programme, Plateforme, VersionNumber,
  DownloadURL: string);
var
  Fichier: string;
begin
  Fichier := getReleasePath(Programme, Plateforme, VersionNumber);
  if not Fichier.isempty then
    tfile.WriteAllText(Fichier, DownloadURL, TEncoding.UTF8);
end;

class function TTools.getLastReleasePath(Programme, Plateforme: string): string;
var
  Dossier: string;
  Fichiers: TStringDynArray;
  i: integer;
begin
  result := '';
  Dossier := getPath(Programme, Plateforme);
  if (not Dossier.isempty) and tdirectory.Exists(Dossier) then
  begin
    Fichiers := tdirectory.GetFiles(Dossier);
    for i := 0 to length(Fichiers) - 1 do
    begin
      if (result < Fichiers[i]) or (result.isempty) then
        result := Fichiers[i];
    end;
  end;
end;

class function TTools.getNextReleasePath(Programme, Plateforme,
  VersionNumber: string): string;
var
  Dossier: string;
  VersionActuelle: string;
  Fichiers: TStringDynArray;
  i: integer;
begin
  result := '';
  Dossier := getPath(Programme, Plateforme);
  VersionActuelle := getReleasePath(Programme, Plateforme, VersionNumber);
  if (not Dossier.isempty) and tdirectory.Exists(Dossier) then
  begin
    Fichiers := tdirectory.GetFiles(Dossier);
    for i := 0 to length(Fichiers) - 1 do
    begin
      if ((Fichiers[i] > VersionActuelle) and ((result > Fichiers[i]) or
        result.isempty)) then
        result := Fichiers[i];
    end;
  end;
end;

class function TTools.getPath(Programme, Plateforme: string): string;
begin
  // TODO : paramétrer le chemin de base, à priori pas "Mes documents" et encore moins "Webinaire20201123.dat"
  result := tpath.Combine(tpath.GetDocumentsPath, 'Webinaire20201123.dat');
  // TODO : valider le contenu de 'Programme' et s'assurer qu'il ne contient que des lettres, chiffres, tirets, points et soulignés
  result := tpath.Combine(result, Programme.trim);
  // TODO : valider le contenu de 'Plateforme' qui doit appartenir à la liste utilisée dans cbPlateforme de fMain
  result := tpath.Combine(result, Plateforme.trim);
  if not tdirectory.Exists(result) then
    tdirectory.CreateDirectory(result);
end;

class function TTools.getReleasePath(Programme, Plateforme,
  VersionNumber: string): string;
begin
  // TODO : s'assurer que VersionNumber ne contient que des lettres, chiffres, tirets, points et soulignés
  result := tpath.Combine(getPath(Programme, Plateforme),
    VersionNumber + '.dat');
end;

end.
