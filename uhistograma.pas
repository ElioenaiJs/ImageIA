unit Uhistograma;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Uvarios, math;

type

  { TFrmHistograma }

  TFrmHistograma = class(TForm)
    Button1: TButton;
    Button2: TButton;
    chkRojo: TCheckBox;
    chkVerde: TCheckBox;
    chkAzul: TCheckBox;
    chkGris: TCheckBox;
    GroupBox1: TGroupBox;
    ImgHisto: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ScrollBar1: TScrollBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PintaHisto();
    procedure UpdateHistogram(Bitmap: TBitmap);
  private

  public
    Han,Hal,nc,nr:Integer;
    BH: TBitmap;
    MH: Mat3D;
    HH: ArrInt;
  end;

var
  FrmHistograma: TFrmHistograma;

implementation

{$R *.lfm}

{ TFrmHistograma }

procedure TFrmHistograma.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TFrmHistograma.Button2Click(Sender: TObject);
begin
    Han:=ImgHisto.Width;
    Hal:=ImgHisto.Height;
    ImgHisto.Canvas.Brush.Color:=clBlack;
    ImgHisto.Canvas.Rectangle(0,0,Han,Hal);
    BH:= TBitmap.Create;
    BH.Assign(BA);
    nc:=BH.Width;
    nr:=BH.Height;
    BM_MAT(BH,MH);
    PintaHisto();
end;

procedure TFrmHistograma.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  ImgHisto.Canvas.Pen.Color:=clBlack;
  ImgHisto.Canvas.Rectangle(0,0,Han,Hal);
  chkGris.Checked:=false;
end;

procedure TFrmHistograma.FormCreate(Sender: TObject);
begin
  Han:=ImgHisto.Width;
  Hal:=ImgHisto.Height;
  ImgHisto.Canvas.Brush.Color:=clBlack;
  ImgHisto.Canvas.Rectangle(0,0,Han,Hal);
  BH:= TBitmap.Create;
  chkRojo.Checked:=true;
  chkVerde.Checked:=true;
  chkAzul.Checked:=true;

end;
 procedure TfrmHistograma.UpdateHistogram(Bitmap: TBitmap);
begin
  if (Bitmap = nil) or (Bitmap.Empty) then
  begin
    ShowMessage('No se recibió una región válida para el histograma.');
    Exit;
  end;

  // Asigna la nueva región seleccionada al bitmap del histograma
  BH.Assign(Bitmap);

  Button2Click(Self);
  // Dibuja el histograma
  PintaHisto();
end;
procedure TFrmHistograma.FormShow(Sender: TObject);
begin
  BH.Assign(BA);
  nc:=BH.Width;
  nr:=BH.Height;
  BM_MAT(BH,MH);
  PintaHisto();
end;
procedure TFrmHistograma.PintaHisto();
var
  i,j,ind:Integer;
  maxi : array[0..3] of Integer;
  fac : Real;
  begin
    for i:=0 to 255 do
    begin
      HH[0,i]:=0;
      HH[1,i]:=0;
      HH[2,i]:=0;
      HH[3,i]:=0;
    end;
   for i:=0 to nc-1 do
    for j:=0 to nr-1 do
    begin
      ind:=MH[i][j][0];//rojo
      Inc(HH[0,ind]);
    ind:=MH[i][j][1];//verde
      Inc(HH[1,ind]);
        ind:=MH[i][j][2];//azul
      Inc(HH[2,ind]);
        ind:=(MH[i][j][0]+MH[i][j][1]+MH[i][j][2]) div 3;//gris
      Inc(HH[3,ind]);
    end;
    maxi[0]:=0;
    maxi[1]:=0;
    maxi[2]:=0;
    maxi[3]:=0;
    If chkRojo.Checked Then
    begin
      ImgHisto.Canvas.Pen.Color:=clRed;
      for i:=0 to 255 do
      maxi[0]:= max(HH[0,i],maxi[0]);
      fac:=Hal/(maxi[0]+1);
      ImgHisto.Canvas.MoveTo(0,Hal-Round(fac*HH[0,0]));
      for i:=1 to 255 do
      ImgHisto.Canvas.LineTo(Round(i*Han/255),Hal-Round(fac*HH[0,i]));
    end;
      If chkVerde.Checked Then
    begin
      ImgHisto.Canvas.Pen.Color:=clGreen;
      for i:=0 to 255 do
      maxi[1]:= max(HH[1,i],maxi[1]);
      fac:=Hal/(maxi[1]+1);
      ImgHisto.Canvas.MoveTo(0,Hal-Round(fac*HH[1,0]));
      for i:=1 to 255 do
      ImgHisto.Canvas.LineTo(Round(i*Han/255),Hal-Round(fac*HH[1,i]));
    end;
        If chkAzul.Checked Then
    begin
      ImgHisto.Canvas.Pen.Color:=clBlue;
      for i:=0 to 255 do
      maxi[2]:= max(HH[2,i],maxi[2]);
      fac:=Hal/(maxi[2]+1);
      ImgHisto.Canvas.MoveTo(0,Hal-Round(fac*HH[2,0]));
      for i:=1 to 255 do
      ImgHisto.Canvas.LineTo(Round(i*Han/255),Hal-Round(fac*HH[2,i]));
    end;
      If chkGris.Checked Then
    begin
      ImgHisto.Canvas.Pen.Color:=clGray;
      for i:=0 to 255 do
      maxi[3]:= max(HH[3,i],maxi[3]);
      fac:=Hal/(maxi[3]+1);
      ImgHisto.Canvas.MoveTo(0,Hal-Round(fac*HH[3,0]));
      for i:=1 to 255 do
      ImgHisto.Canvas.LineTo(Round(i*Han/255),Hal-Round(fac*HH[3,i]));
    end;
  end;

end.

