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
procedure TFrmImagen.TrackBar1Change(Sender: TObject);
var
  x, y, i, j, ind: Integer;
  maxi: array[0..2] of Integer;
  fac: Real;
  HistogramR, HistogramG, HistogramB: array[0..255] of Integer;
  bmp1, bmp2: TBitmap;
begin
  bmp1 := Image1.Picture.Bitmap;
  bmp2 := TBitmap.Create;
  try
    bmp2.SetSize(256, 300); // Incrementa el tamaño de bmp2

    // Inicializar los arrays del histograma
    for i := 0 to 255 do
    begin
      HistogramR[i] := 0;
      HistogramG[i] := 0;
      HistogramB[i] := 0;
    end;

    // Obtener los valores del histograma de cada color
    for x := 0 to bmp1.Width - 1 do
      for y := 0 to bmp1.Height - 1 do
      begin
        ind := bmp1.Canvas.Pixels[x, y] and $FF; // rojo
        Inc(HistogramR[ind]);
        ind := (bmp1.Canvas.Pixels[x, y] shr 8) and $FF; // verde
        Inc(HistogramG[ind]);
        ind := (bmp1.Canvas.Pixels[x, y] shr 16) and $FF; // azul
        Inc(HistogramB[ind]);
      end;

    // Encontrar el valor máximo para escalar los histogramas
    maxi[0] := 0;
    maxi[1] := 0;
    maxi[2] := 0;
    for i := 0 to 255 do
    begin
      if HistogramR[i] > maxi[0] then maxi[0] := HistogramR[i];
      if HistogramG[i] > maxi[1] then maxi[1] := HistogramG[i];
      if HistogramB[i] > maxi[2] then maxi[2] := HistogramB[i];
    end;

    // Dibujar el histograma
    bmp2.Canvas.Brush.Color := clWhite;
    bmp2.Canvas.FillRect(Rect(0, 0, bmp2.Width, bmp2.Height));

    // Dibujar el histograma rojo
    bmp2.Canvas.Pen.Color := clRed;
    fac := bmp2.Height / (maxi[0] + 1);
    bmp2.Canvas.MoveTo(0, bmp2.Height - Round(fac * HistogramR[0]));
    for i := 1 to 255 do
      bmp2.Canvas.LineTo(Round(i * bmp2.Width / 255), bmp2.Height - Round(fac * HistogramR[i]));

    // Dibujar el histograma verde
    bmp2.Canvas.Pen.Color := clGreen;
    fac := bmp2.Height / (maxi[1] + 1);
    bmp2.Canvas.MoveTo(0, bmp2.Height - Round(fac * HistogramG[0]));
    for i := 1 to 255 do
      bmp2.Canvas.LineTo(Round(i * bmp2.Width / 255), bmp2.Height - Round(fac * HistogramG[i]));

    // Dibujar el histograma azul
    bmp2.Canvas.Pen.Color := clBlue;
    fac := bmp2.Height / (maxi[2] + 1);
    bmp2.Canvas.MoveTo(0, bmp2.Height - Round(fac * HistogramB[0]));
    for i := 1 to 255 do
      bmp2.Canvas.LineTo(Round(i * bmp2.Width / 255), bmp2.Height - Round(fac * HistogramB[i]));

    Image2.Picture.Bitmap.Assign(bmp2);
  finally
    bmp2.Free;
  end;
end;


end.

