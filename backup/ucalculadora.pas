unit Ucalculadora;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, Math;

type

  { TFrmCalculadora }

  TFrmCalculadora = class(TForm)
    ImagenR: TImage;
    Suma1: TButton;
    RtoB: TButton;
    AtoB: TButton;
    Button12: TButton;
    Suma2: TButton;
    Resta1: TButton;
    Resta2: TButton;
    Resta3: TButton;
    Refeh: TButton;
    Rvert: TButton;
    Rdoble: TButton;
    RtoA: TButton;
    ImagenA: TImage;
    ImagenB: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    procedure RdobleClick(Sender: TObject);
    procedure RefehClick(Sender: TObject);
    procedure RtoBClick(Sender: TObject);
    procedure AtoBClick(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure RvertClick(Sender: TObject);
    procedure Suma1Click(Sender: TObject);
    procedure Suma2Click(Sender: TObject);
    procedure Resta1Click(Sender: TObject);
    procedure Resta2Click(Sender: TObject);
    procedure Resta3Click(Sender: TObject);
    procedure RtoAClick(Sender: TObject);
    procedure InvertirVerticalmente(Bitmap: TBitmap);
    procedure InvertirHorizontalmente(Bitmap: TBitmap);
  private

  public

  end;

var
  FrmCalculadora: TFrmCalculadora;

implementation

{$R *.lfm}

{ TFrmCalculadora }

procedure TFrmCalculadora.Button12Click(Sender: TObject);
begin
  OpenDialog1.Options := OpenDialog1.Options + [ofAllowMultiSelect];
  if OpenDialog1.Execute and (OpenDialog1.Files.Count >= 2) then
  begin
    ImagenA.Picture.LoadFromFile(OpenDialog1.Files[0]);
    ImagenB.Picture.LoadFromFile(OpenDialog1.Files[1]);
  end
  else
  begin
    ShowMessage('Por favor selecciona al menos dos imágenes.');
  end;
end;

procedure TFrmCalculadora.RvertClick(Sender: TObject);
begin
  InvertirVerticalmente(ImagenA.Picture.Bitmap);
  InvertirVerticalmente(ImagenB.Picture.Bitmap);
  InvertirVerticalmente(ImagenR.Picture.Bitmap);
end;

procedure TFrmCalculadora.RtoBClick(Sender: TObject);
begin
  ImagenB.Picture.Assign(ImagenR.Picture);
end;

procedure TFrmCalculadora.RefehClick(Sender: TObject);
begin
  InvertirHorizontalmente(ImagenA.Picture.Bitmap);
  InvertirHorizontalmente(ImagenB.Picture.Bitmap);
  InvertirHorizontalmente(ImagenR.Picture.Bitmap);
end;

procedure TFrmCalculadora.RdobleClick(Sender: TObject);
begin
  InvertirVerticalmente(ImagenR.Picture.Bitmap);
  InvertirHorizontalmente(ImagenR.Picture.Bitmap);
end;

procedure TFrmCalculadora.AtoBClick(Sender: TObject);
var
  TempPicture: TPicture;
begin

  // Crear una instancia temporal de TPicture
  TempPicture := TPicture.Create;
  try
    // Guardar la imagen de ImagenA en TempPicture
    TempPicture.Assign(ImagenA.Picture);

    // Pasar la imagen de ImagenB a ImagenA
    ImagenA.Picture.Assign(ImagenB.Picture);

    // Pasar la imagen de TempPicture (original de ImagenA) a ImagenB
    ImagenB.Picture.Assign(TempPicture);
  finally

  end;
end;

procedure TFrmCalculadora.Suma1Click(Sender: TObject);
var
  x, y: integer;
  MinWidth, MinHeight: integer;
  R1, G1, B1, R2, G2, B2, R, G, B: byte;
  Color1, Color2: TColor;
  Bitmap1, Bitmap2, BitmapResult: TBitmap;
begin
  Label1.Caption := '+';
  // Verificar que ambas imágenes estén cargadas
  if (ImagenA.Picture.Graphic = nil) or (ImagenB.Picture.Graphic = nil) then
  begin
    ShowMessage('Por favor, carga ambas imágenes antes de realizar la operación.');
    Exit;
  end;

  // Crear bitmaps temporales para manipular las imágenes
  Bitmap1 := TBitmap.Create;
  Bitmap2 := TBitmap.Create;
  BitmapResult := TBitmap.Create;

  try
    // Asignar las imágenes cargadas a los bitmaps
    Bitmap1.Assign(ImagenA.Picture.Bitmap);
    Bitmap2.Assign(ImagenB.Picture.Bitmap);

    // Calcular el tamaño mínimo entre las dos imágenes
    MinWidth := Min(Bitmap1.Width, Bitmap2.Width);
    MinHeight := Min(Bitmap1.Height, Bitmap2.Height);

    // Configurar el Bitmap de resultado
    BitmapResult.SetSize(MinWidth, MinHeight);
    BitmapResult.PixelFormat := pf24bit; // Asegurar formato de 24 bits

    // Procesar cada píxel dentro del área común
    for y := 0 to MinHeight - 1 do
    begin
      for x := 0 to MinWidth - 1 do
      begin
        // Obtener los colores de los píxeles correspondientes
        Color1 := Bitmap1.Canvas.Pixels[x, y];
        Color2 := Bitmap2.Canvas.Pixels[x, y];

        // Extraer componentes RGB de ambas imágenes
        R1 := Red(Color1);
        G1 := Green(Color1);
        B1 := Blue(Color1);

        R2 := Red(Color2);
        G2 := Green(Color2);
        B2 := Blue(Color2);

        // Realizar la suma normalizada
        R := (R1 + R2) div 2;
        G := (G1 + G2) div 2;
        B := (B1 + B2) div 2;

        // Asignar el nuevo color al píxel del BitmapResult
        BitmapResult.Canvas.Pixels[x, y] := RGBToColor(R, G, B);
      end;
    end;

    // Mostrar el resultado en Image3
    ImagenR.Picture.Assign(BitmapResult);
    ShowMessage('Suma completada y mostrada en la tercera imagen.');
  finally

  end;
end;

procedure TFrmCalculadora.Suma2Click(Sender: TObject);
var
  x, y: integer;
  MinWidth, MinHeight: integer;
  R1, G1, B1, R2, G2, B2, R, G, B: byte;
  Color1, Color2: TColor;
  Bitmap1, Bitmap2, BitmapResult: TBitmap;
begin
  Label1.Caption := '+';
  // Verificar que ambas imágenes estén cargadas
  if (ImagenA.Picture.Graphic = nil) or (ImagenB.Picture.Graphic = nil) then
  begin
    ShowMessage('Por favor, carga ambas imágenes antes de realizar la operación.');
    Exit;
  end;

  // Crear bitmaps temporales para manipular las imágenes
  Bitmap1 := TBitmap.Create;
  Bitmap2 := TBitmap.Create;
  BitmapResult := TBitmap.Create;

  try
    // Asignar las imágenes cargadas a los bitmaps
    Bitmap1.Assign(ImagenA.Picture.Bitmap);
    Bitmap2.Assign(ImagenB.Picture.Bitmap);

    // Calcular el tamaño mínimo entre las dos imágenes
    MinWidth := Min(Bitmap1.Width, Bitmap2.Width);
    MinHeight := Min(Bitmap1.Height, Bitmap2.Height);

    // Configurar el Bitmap de resultado
    BitmapResult.SetSize(MinWidth, MinHeight);
    BitmapResult.PixelFormat := pf24bit; // Asegurar formato de 24 bits

    // Procesar cada píxel dentro del área común
    for y := 0 to MinHeight - 1 do
    begin
      for x := 0 to MinWidth - 1 do
      begin
        // Obtener los colores de los píxeles correspondientes
        Color1 := Bitmap1.Canvas.Pixels[x, y];
        Color2 := Bitmap2.Canvas.Pixels[x, y];

        // Extraer componentes RGB de ambas imágenes
        R1 := Red(Color1);
        G1 := Green(Color1);
        B1 := Blue(Color1);

        R2 := Red(Color2);
        G2 := Green(Color2);
        B2 := Blue(Color2);

        // Realizar la suma normalizada
        R := (R1 + R2);
        G := (G1 + G2) div 2;
        B := (B1 + B2) div 2;

        // Asignar el nuevo color al píxel del BitmapResult
        BitmapResult.Canvas.Pixels[x, y] := RGBToColor(R, G, B);
      end;
    end;

    // Mostrar el resultado en Image3
    ImagenR.Picture.Assign(BitmapResult);
    ShowMessage('Suma completada y mostrada en la tercera imagen.');
  finally

  end;
end;

procedure TFrmCalculadora.Resta1Click(Sender: TObject);
begin
  Label1.Caption := '-';
end;

procedure TFrmCalculadora.Resta2Click(Sender: TObject);
var
  x, y: integer;
  MinWidth, MinHeight: integer;
  R1, G1, B1, R2, G2, B2, R, G, B: byte;
  Color1, Color2: TColor;
  Bitmap1, Bitmap2, BitmapResult: TBitmap;
begin
  Label1.Caption := '-';
  // Verificar que ambas imágenes estén cargadas
  if (Imagena.Picture.Graphic = nil) or (Imagenb.Picture.Graphic = nil) then
  begin
    ShowMessage('Por favor, carga ambas imágenes antes de realizar la operación.');
    Exit;
  end;

  // Crear bitmaps temporales para manipular las imágenes
  Bitmap1 := TBitmap.Create;
  Bitmap2 := TBitmap.Create;
  BitmapResult := TBitmap.Create;

  try
    // Asignar las imágenes cargadas a los bitmaps
    Bitmap1.Assign(ImagenA.Picture.Bitmap);
    Bitmap2.Assign(ImagenB.Picture.Bitmap);

    // Calcular el tamaño mínimo entre las dos imágenes
    MinWidth := Min(Bitmap1.Width, Bitmap2.Width);
    MinHeight := Min(Bitmap1.Height, Bitmap2.Height);

    // Configurar el Bitmap de resultado
    BitmapResult.SetSize(MinWidth, MinHeight);
    BitmapResult.PixelFormat := pf24bit;

    // Procesar cada píxel dentro del área común
    for y := 0 to MinHeight - 1 do
    begin
      for x := 0 to MinWidth - 1 do
      begin
        // Obtener los colores de los píxeles correspondientes
        Color1 := Bitmap1.Canvas.Pixels[x, y];
        Color2 := Bitmap2.Canvas.Pixels[x, y];

        // Extraer componentes RGB de ambas imágenes
        R1 := Red(Color1);
        G1 := Green(Color1);
        B1 := Blue(Color1);

        R2 := Red(Color2);
        G2 := Green(Color2);
        B2 := Blue(Color2);

        // Calcular la resta con valor absoluto
        R := Abs(R1 - R2);
        G := Abs(G1 - G2);
        B := Abs(B1 - B2);

        // Asignar el nuevo color al píxel del BitmapResult
        BitmapResult.Canvas.Pixels[x, y] := RGBToColor(R, G, B);
      end;
    end;

    // Mostrar el resultado en Image3
    ImagenR.Picture.Assign(BitmapResult);
    ShowMessage('Resta 2 completada y mostrada en la tercera imagen.');
  finally

  end;
end;

procedure TFrmCalculadora.Resta3Click(Sender: TObject);
var
  x, y: integer;
  MinWidth, MinHeight: integer;
  R1, G1, B1, R2, G2, B2: byte;
  R, G, B: integer;
  Color1, Color2: TColor;
  Bitmap1, Bitmap2, BitmapResult: TBitmap;
begin
  Label1.Caption := '-';
  // Verificar que ambas imágenes estén cargadas
  if (ImageNA.Picture.Graphic = nil) or (ImagenB.Picture.Graphic = nil) then
  begin
    ShowMessage('Por favor, carga ambas imágenes antes de realizar la operación.');
    Exit;
  end;

  // Crear bitmaps temporales para manipular las imágenes
  Bitmap1 := TBitmap.Create;
  Bitmap2 := TBitmap.Create;
  BitmapResult := TBitmap.Create;

  try
    // Asignar las imágenes cargadas a los bitmaps
    Bitmap1.Assign(ImagenA.Picture.Bitmap);
    Bitmap2.Assign(ImagenB.Picture.Bitmap);

    // Calcular el tamaño mínimo entre las dos imágenes
    MinWidth := Min(Bitmap1.Width, Bitmap2.Width);
    MinHeight := Min(Bitmap1.Height, Bitmap2.Height);

    // Configurar el Bitmap de resultado
    BitmapResult.SetSize(MinWidth, MinHeight);
    BitmapResult.PixelFormat := pf24bit;

    // Procesar cada píxel dentro del área común
    for y := 0 to MinHeight - 1 do
    begin
      for x := 0 to MinWidth - 1 do
      begin
        // Obtener los colores de los píxeles correspondientes
        Color1 := Bitmap1.Canvas.Pixels[x, y];
        Color2 := Bitmap2.Canvas.Pixels[x, y];

        // Extraer componentes RGB de ambas imágenes
        R1 := Red(Color1);
        G1 := Green(Color1);
        B1 := Blue(Color1);

        R2 := Red(Color2);
        G2 := Green(Color2);
        B2 := Blue(Color2);

        // Calcular la resta con norma shift
        R := (255 div 2) + ((R1 - R2) div 2);
        G := (255 div 2) + ((G1 - G2) div 2);
        B := (255 div 2) + ((B1 - B2) div 2);

        // Limitar valores al rango [0, 255]
        R := Max(0, Min(255, R));
        G := Max(0, Min(255, G));
        B := Max(0, Min(255, B));

        // Asignar el nuevo color al píxel del BitmapResult
        BitmapResult.Canvas.Pixels[x, y] := RGBToColor(R, G, B);
      end;
    end;

    // Mostrar el resultado en Image3
    ImagenR.Picture.Assign(BitmapResult);
    ShowMessage('Resta 3 completada y mostrada en la tercera imagen.');
  finally

  end;

end;

procedure TFrmCalculadora.RtoAClick(Sender: TObject);
begin
  ImagenA.Picture.Assign(ImagenR.Picture);
end;

procedure TFrmCalculadora.InvertirVerticalmente(Bitmap: TBitmap);
var
  x, y: integer;
  TempColor: TColor;
begin
  // Iterar sobre la mitad superior de la imagen
  for y := 0 to (Bitmap.Height div 2) - 1 do
  begin
    for x := 0 to Bitmap.Width - 1 do
    begin
      // Intercambiar píxeles de la fila superior con la inferior
      TempColor := Bitmap.Canvas.Pixels[x, y];
      Bitmap.Canvas.Pixels[x, y] := Bitmap.Canvas.Pixels[x, Bitmap.Height - y - 1];
      Bitmap.Canvas.Pixels[x, Bitmap.Height - y - 1] := TempColor;
    end;
  end;
end;
// Procedimiento para invertir la imagen horizontalmente
procedure TFrmCalculadora.InvertirHorizontalmente(Bitmap: TBitmap);
var
  x, y: Integer;
  TempColor: TColor;
begin
  // Iterar sobre cada fila de la imagen
  for y := 0 to Bitmap.Height - 1 do
  begin
    // Iterar sobre la mitad de las columnas
    for x := 0 to (Bitmap.Width div 2) - 1 do
    begin
      // Intercambiar píxeles de la columna izquierda con la derecha
      TempColor := Bitmap.Canvas.Pixels[x, y];
      Bitmap.Canvas.Pixels[x, y] := Bitmap.Canvas.Pixels[Bitmap.Width - x - 1, y];
      Bitmap.Canvas.Pixels[Bitmap.Width - x - 1, y] := TempColor;
    end;
  end;
end;

end.
