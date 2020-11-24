unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }

  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses uReleaseClientLib;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TReleaseClientLib.checkNewReleaseURL(TReleaseClientLib.getProgramName,
    TReleaseClientLib.getProgramDate,
    procedure(DownloadURL: string)
    begin
      Memo1.Lines.Add('Nouvelle version dispo. Télécharger sur ' + DownloadURL);
    end,
    procedure
    begin
      Memo1.Lines.Add('Pas de nouvelle version.');
    end,
    procedure(statuscode: integer; statustext: string)
    begin
      Memo1.Lines.Add('Problème réseau : ' + statuscode.ToString);
      Memo1.Lines.Add('=> ' + statustext);
    end);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Button1.setfocus;
  Memo1.Lines.clear;
  Memo1.Lines.Add('Programme: ' + TReleaseClientLib.getProgramName);
  Memo1.Lines.Add('Plateforme: ' + TReleaseClientLib.getPlateformeName);
  Memo1.Lines.Add('Version: ' + TReleaseClientLib.getProgramDate);
end;

initialization

TReleaseClientLib.setServeurURL('http://127.0.0.7:8080');

end.
