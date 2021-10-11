unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  Tfrm_Main = class(TForm)
    btn_LoadFromResID: TButton;
    btn_LoadFromResName: TButton;
    Image1: TImage;
    procedure btn_LoadFromResIDClick(Sender: TObject);
    procedure btn_LoadFromResNameClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation
{$R JPEGRes.res}

{$R *.DFM}
Uses crJPEG;

procedure Tfrm_Main.btn_LoadFromResIDClick(Sender: TObject);
Var JPG : TJPEGImage;
begin
  JPG := TJPEGImage.Create;
  Try
    JPG.LoadFromResourceID(hInstance, 45678);
    Image1.Picture.Assign(JPG);
  Finally
    JPG.Free;
  End;
end;

procedure Tfrm_Main.btn_LoadFromResNameClick(Sender: TObject);
Var JPG : TJPEGImage;
begin
  JPG := TJPEGImage.Create;
  Try
    JPG.LoadFromResourceName(hInstance, 'Clouds');
    Image1.Picture.Assign(JPG);
  Finally
    JPG.Free;
  End;
end;

end.
