unit Uperfin;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils,FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Uvarios, math, uImagen;

type

  { TFrmPerfin }

  TFrmPerfin = class(TForm)
    ImgHisto: TImage;
    chkRojo: TCheckBox;
    chkVerde: TCheckBox;
    chkAzul: TCheckBox;
    chkGris: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure PintaPerfil();
  private
    function GetLineaX: Integer; // Obtener la posición del TrackBar desde Uimagen
  public
    nc, nr: Integer; // Dimensiones de la imagen
    BH: TBitmap;     // Imagen
    MH: Mat3D;       // Matriz de la imagen
  end;

var
  FrmPerfin: TFrmPerfin;

implementation



{$R *.lfm}

{ TFrmPerfin }

procedure TFrmPerfin.FormShow(Sender: TObject);
begin
  BH.Assign(BA); // Asignar la imagen
  nc := BH.Width;  // Ancho de la imagen
  nr := BH.Height; // Alto de la imagen
  BM_MAT(BH, MH);  // Convertir a matriz
  PintaPerfil();   // Dibujar el perfil inicial
end;

// Método para obtener el valor del TrackBar desde Uimagen
function TFrmPerfin.GetLineaX: Integer;
begin
 Result := Uimagen.FrmImagen.TrackBarLinea.Position; // Correcto
 // Acceder a la posición del TrackBar
end;

procedure TFrmPerfin.PintaPerfil();
var
  i, j: Integer;
  lineaX: Integer;
  R, G, B, Gris: Integer;
  fac: Real;
begin
  // Obtener la posición del TrackBar desde Uimagen
  lineaX := GetLineaX;

  // Inicializar el lienzo
  ImgHisto.Canvas.Brush.Color := clBlack;
  ImgHisto.Canvas.FillRect(0, 0, ImgHisto.Width, ImgHisto.Height);

  // Configurar escala vertical para ajustar los valores al área de dibujo
  fac := ImgHisto.Height / 255.0;

  // Dibujar perfiles para los canales seleccionados
  if chkRojo.Checked then
  begin
    ImgHisto.Canvas.Pen.Color := clRed;
    ImgHisto.Canvas.MoveTo(0, ImgHisto.Height - Round(fac * MH[lineaX][0][0]));
    for j := 1 to nr - 1 do
    begin
      R := MH[lineaX][j][0]; // Canal rojo
      ImgHisto.Canvas.LineTo(Round(j * ImgHisto.Width / nr), ImgHisto.Height - Round(fac * R));
    end;
  end;

  if chkVerde.Checked then
  begin
    ImgHisto.Canvas.Pen.Color := clGreen;
    ImgHisto.Canvas.MoveTo(0, ImgHisto.Height - Round(fac * MH[lineaX][0][1]));
    for j := 1 to nr - 1 do
    begin
      G := MH[lineaX][j][1]; // Canal verde
      ImgHisto.Canvas.LineTo(Round(j * ImgHisto.Width / nr), ImgHisto.Height - Round(fac * G));
    end;
  end;

  if chkAzul.Checked then
  begin
    ImgHisto.Canvas.Pen.Color := clBlue;
    ImgHisto.Canvas.MoveTo(0, ImgHisto.Height - Round(fac * MH[lineaX][0][2]));
    for j := 1 to nr - 1 do
    begin
      B := MH[lineaX][j][2]; // Canal azul
      ImgHisto.Canvas.LineTo(Round(j * ImgHisto.Width / nr), ImgHisto.Height - Round(fac * B));
    end;
  end;

  if chkGris.Checked then
  begin
    ImgHisto.Canvas.Pen.Color := clGray;
    Gris := Round((MH[lineaX][j][0] + MH[lineaX][j][1] + MH[lineaX][j][2]) / 3);

    for j := 1 to nr - 1 do
    begin
      Gris := (MH[lineaX][j][0] + MH[lineaX][j][1] + MH[lineaX][j][2]) div 3; // Canal gris
      ImgHisto.Canvas.LineTo(Round(j * ImgHisto.Width / nr), ImgHisto.Height - Round(fac * Gris));
    end;
  end;
end;

end.
