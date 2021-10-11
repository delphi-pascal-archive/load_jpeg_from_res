{
  Elle permet le chargement d'images JPEG depuis un fichier de ressources

  Ajout de la Procedure Priv�e TestForError41
  afin de permettre l'interception de 100%
  des erreurs JPEG et surtout, plus particuli�rement, l'erreur #41
  qui � �t�e la "terreur" des programmeurs jusque l�.

  Il suffit de surcharger la Procedure LoadFromStream
  comme toutes les autres Procedure de chargement font
  appel � elle ... Voir la D�mo pour l'exemple.

 
 Vous pouvez utiliser crJPEG dans vos applications commerciales o� gratuites sans limites
 � la seul condition de le mentionner dans une AboutBox par exemple.
   
 Toutes fois un mail avec un petit descriptif de l'application serait appr�ci� .
}

unit crJPEG;

interface

Uses Windows, Classes, Graphics, JPEG;

{D�claration d'un type de ressource pour les JPEG}
Const
  RT_JPEG = 'RCJPEG';

Type
  TJPEGImage = Class(JPEG.TJPEGImage)
  private
    procedure TestForError41;
  Public
    procedure LoadFromStream(Stream : TStream); Override;
    procedure LoadFromResourceName(Instance: THandle; const ResName: String);
    procedure LoadFromResourceID(Instance: THandle; ResID: Integer);
  End;

implementation
Const  {Description pour TOpenPictureDialog}
  sJPEGImageFile = '[Cirec] JPEG';

{ TJPEGImage }
{Ajout� le 26/10/2006}
{C'est ici que se trouve l'astuce qui permet la capture
 de l'erreur JPEG #41 et des autres bien s�r}
Procedure TJPEGImage.TestForError41;
Var Can : TCanvas;
Begin
 {On cr�e un Canvas}
  Can := TCanvas.Create;
  Try
  {Pour �viter le message d'erreur : "Les canvas ne permettent pas de dessiner"
   on lui affecte un DC (celui du Desktop)}
   Can.Handle := GetDC(0);
    Try
      {Ici on force le dessin sur le Canvas avec une taille
       diff�rente de l'original ce qui d�clanchera et interceptera
       l'erreur JPEG #41}
      Draw(Can, Rect(0,0,1,1));
    Except
      Raise; {On retransmet l'erreur � un autre niveau}
    End;
  Finally
   {On lib�re le DC}
   ReleaseDC(0, Can.Handle);
   {et le Canvas}
   Can.Free;
  End;
End;

{Charge un JPEG depuis un ID de ressource}
procedure TJPEGImage.LoadFromResourceID(Instance: THandle; ResID: Integer);
var
  Stream: TCustomMemoryStream;
begin
  Stream := TResourceStream.CreateFromID(Instance, ResID, RT_JPEG);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

{Charge un JPEG depuis un Nom de ressource}
procedure TJPEGImage.LoadFromResourceName(Instance: THandle;
  const ResName: String);
var
  Stream: TCustomMemoryStream;
begin
  Stream := TResourceStream.Create(Instance, ResName, RT_JPEG);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

{En surchargant cette unique procedure toutes les m�thodes
 de chargement d'images sont couverte}
procedure TJPEGImage.LoadFromStream(Stream: TStream);
begin
  Try
   {Appel de la m�thode h�rit�e de LoadFromStream}
    Inherited LoadFromStream(Stream);
    {Teste l'erreur JPEG #41}
    TestForError41;
  Except
    {Retransmet l'erreur � un autre niveau}
    Raise;
  End;
end;



Initialization
 {Et gr�ce � cette petite ligne l'effet se propage dans
  TPicture et dans tout le projet :
    Ex. Une application avec deux Forms
      Unit1 la principale avec crJPEG dans les Uses
      Unit2 la secondaire avec ni crJPEG ni Unit1 dans les Uses

      Et depuis Unit2 sans contacte ni liaison directe avec Unit1 o� crJPEG
      vous aurez quand m�me acc�s au contr�le d'erreur de cette unit�
      C'est pas Cool �a franchement}
  TPicture.RegisterFileFormat('JPG', sJPEGImageFile, TJPEGImage);
Finalization
  TPicture.UnregisterGraphicClass(TJPEGImage);
end.
