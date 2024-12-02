unit uImagen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, ComCtrls,Uvarios,Uhistograma,uPuntuales,Ufunciongama,Ucalculadora,UPerfil,Uexponencial,Math;

type

  { TFrmImagen }

  TFrmImagen = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    mAGuardar: TMenuItem;
    mASalir: TMenuItem;
    meeDeshacer: TMenuItem;
    mnuOpExpo: TMenuItem;
    mnuOpRPerfilIn: TMenuItem;
    mnuOpSeno: TMenuItem;
    MHCalculadora: TMenuItem;
    mnuOpLogaritmico: TMenuItem;
    mnuOpUmbral: TMenuItem;
    mnuPuntualGamma: TMenuItem;
    mnuVImagenCompleta: TMenuItem;
    mnuOpgris2: TMenuItem;
    mnuOpNegativo: TMenuItem;
    MHHistograma: TMenuItem;
    mnuArchivo: TMenuItem;
    mAABRIR: TMenuItem;
    nmuEditar: TMenuItem;
    nmuVer: TMenuItem;
    MenuItem5: TMenuItem;
    nmuOpRegionales: TMenuItem;
    nmuHerramientas: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    mnuOpGris1: TMenuItem;
    TrackBar1: TTrackBar;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1Paint(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure mAABRIRClick(Sender: TObject);
    procedure mAGuardarClick(Sender: TObject);
    procedure mASalirClick(Sender: TObject);
    procedure maaAbrirotsClick(Sender: TObject);
    procedure meeDeshacerClick(Sender: TObject);
    procedure MHCalculadoraClick(Sender: TObject);
    procedure MHHistogramaClick(Sender: TObject);
    procedure MImagen(B:TBitmap);
    procedure mnuOpExpoClick(Sender: TObject);
    procedure mnuOpGris1Click(Sender: TObject);
    procedure mnuOpgris2Click(Sender: TObject);
    procedure mnuOpLogaritmicoClick(Sender: TObject);
    procedure mnuOpNegativoClick(Sender: TObject);
    procedure mnuOpRPerfilInClick(Sender: TObject);
    procedure mnuOpSenoClick(Sender: TObject);
    procedure mnuOpUmbralClick(Sender: TObject);
    procedure mnuPuntualGammaClick(Sender: TObject);
    procedure mnuVImagenCompletaClick(Sender: TObject);
    procedure GuardaEstadoImg();
    procedure RestauraEstadoImg();
    procedure TrackBar1Change(Sender: TObject);

  private
    procedure CropImage;
  public
   Bm: TBitmap;
    ImageHistory: TList;
   Iancho,Ialto: Integer;
    MTR,MRES: Mat3D;
     Picture: TPicture;
      StartPoint, EndPoint: TPoint;
  IsSelecting: Boolean;
       imagenes : array of TBitMap;//Para deshacer
    currentImageIndex : Integer;
  end;

var
  FrmImagen: TFrmImagen;

implementation

{$R *.lfm}

{ TFrmImagen }
procedure TFrmImagen.mASalirClick(Sender: TObject);
begin
  close;
end;

procedure TFrmImagen.maaAbrirotsClick(Sender: TObject);
var
    nom: String;

begin
  if OpenDialog1.Execute then
  begin
    nom := OpenDialog1.FileName;
    Picture := TPicture.Create;  // Crea una instancia de TPicture

      Picture.LoadFromFile(nom);  // Carga la imagen en TPicture
      Image1.Picture.Assign(Picture);  // Asigna la imagen cargada a TImage
     Bm:=Picture.Bitmap;
     MImagen(Bm);



  end;
end;
procedure TFrmImagen.GuardaEstadoImg;
var
  Backup: TBitmap;
begin
  Backup := TBitmap.Create;
  Backup.Assign(Image1.Picture.Bitmap);

  if ImageHistory.Count = 2 then
  begin
    TBitmap(ImageHistory.First).Free;
    ImageHistory.Delete(0);
  end;

  ImageHistory.Add(Backup);
end;
procedure TFrmImagen.RestauraEstadoImg;
var
  LastImage: TBitmap;
begin
  if ImageHistory.Count > 0 then
  begin
    LastImage := TBitmap(ImageHistory.Last);
    Image1.Picture.Bitmap.Assign(LastImage);
    LastImage.Free;
    ImageHistory.Delete(ImageHistory.Count - 1);
  end;
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







procedure TFrmImagen.meeDeshacerClick(Sender: TObject);
begin
         RestauraEstadoImg;
end;

procedure TFrmImagen.MHCalculadoraClick(Sender: TObject);
begin
   FrmCalculadora.show;
end;

procedure TFrmImagen.MHHistogramaClick(Sender: TObject);
begin
  BA.Assign(FrmImagen.Image1.Picture.Bitmap);
    FrmHistograma.show;
end;

procedure TFrmImagen.mAABRIRClick(Sender: TObject);
VAR
  nom : String;
begin
  if OpenDialog1.Execute then
  begin
    nom := OpenDialog1.FileName;
    Picture := TPicture.Create;  // Crea una instancia de TPicture

      Picture.LoadFromFile(nom);  // Carga la imagen en TPicture
      Image1.Picture.Assign(Picture);  // Asigna la imagen cargada a TImage
     Bm:=Picture.Bitmap;
     MImagen(Bm);


  end;


end;

procedure TFrmImagen.mAGuardarClick(Sender: TObject);
var
  nom : String;
begin
  SaveDialog1.Filter:='BMP';
  SaveDialog1.FileName:='BMP';
  if SaveDialog1.Execute then
  begin
    nom:=SaveDialog1.FileName;
    if nom <> ''then
    begin
      nom := nom+'.bmp';
      Image1.Picture.SaveToFile(nom);
    end;
  end;
end;

procedure TFrmImagen.FormCreate(Sender: TObject);
begin
  Bm := TBitmap.Create;
  BA:=TBitmap.Create;
   ImageHistory := TList.Create;
end;

procedure TFrmImagen.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ImageHistory.Count - 1 do
    TBitmap(ImageHistory[i]).Free;
  ImageHistory.Free;
  Bm.Free;
  BA.Free;
end;

procedure TFrmImagen.Image1Click(Sender: TObject);
var
  ClickY: Integer;
  SelectedBitmap: TBitmap;
  RectWidth, RectHeight: Integer;
  SelectionRect: TRect;
begin
  // Asegúrate de que el formulario del histograma esté visible
  if not frmHistograma.Visible then
    Exit;

  // Verifica si hay una imagen cargada en Image1
  if Image1.Picture.Bitmap = nil then
  begin
    ShowMessage('No hay imagen cargada.');
    Exit;
  end;

  // Restaura la imagen actual si es necesario
  if (currentImageIndex >= 0) and (currentImageIndex < Length(imagenes)) then
  begin
    Image1.Picture.Assign(imagenes[currentImageIndex]);
  end
  else
  begin
    ShowMessage('Índice de imagen inválido.');
    Exit;
  end;

  // Determina la posición del clic en el eje Y
  ClickY := Mouse.CursorPos.Y - Image1.ClientOrigin.Y;

  // Define las dimensiones del rectángulo
  RectWidth := Image1.Picture.Bitmap.Width;
  RectHeight := 10; // Altura fija de 10 píxeles

  // Ajusta el rectángulo para que no exceda los límites de la imagen
  if ClickY + RectHeight > Image1.Picture.Bitmap.Height then
    ClickY := Image1.Picture.Bitmap.Height - RectHeight;

  SelectionRect := Rect(0, ClickY, RectWidth, ClickY + RectHeight);

  // Crea un nuevo bitmap con las dimensiones seleccionadas
  SelectedBitmap := TBitmap.Create;
  try
    SelectedBitmap.Width := RectWidth;
    SelectedBitmap.Height := RectHeight;

    // Copia la sección seleccionada de la imagen original
    SelectedBitmap.Canvas.CopyRect(
      Rect(0, 0, RectWidth, RectHeight),
      Image1.Picture.Bitmap.Canvas,
      SelectionRect
    );

    // Actualiza las variables BM y BA
    BM.Assign(SelectedBitmap);
    BA.Assign(SelectedBitmap);

    // Pinta el rectángulo azul sobre la imagen original
    Image1.Picture.Bitmap.Canvas.Brush.Color := clBlue;
    Image1.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
    Image1.Picture.Bitmap.Canvas.FillRect(SelectionRect);

    // Fuerza la actualización visual de Image1
    Image1.Repaint;

    // Llama al método para actualizar el histograma, si es necesario
    frmHistograma.UpdateHistogram(BA);
  finally
    SelectedBitmap.Free;
  end;
end;

procedure TFrmImagen.Image1DblClick(Sender: TObject);
  begin

end;


procedure TFrmImagen.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
        if Assigned(Image1.Picture.Bitmap) then
  begin
    IsSelecting := True;
    StartPoint := Point(X, Y);
  end;
end;

procedure TFrmImagen.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if IsSelecting then
  begin
    EndPoint := Point(X, Y);
    Image1.Repaint;
  end;
end;
procedure TFrmImagen.Image1Paint(Sender: TObject);
begin
  if IsSelecting then
  begin
    with Image1.Canvas do
    begin
    Image1.Canvas.Brush.Color := clRed;
    Image1.Canvas.Pen.Style := psDot;
      Image1.Canvas.Brush.Style := bsClear;
      Image1.Canvas.Rectangle(StartPoint.X, StartPoint.Y, EndPoint.X, EndPoint.Y);
    end;
  end;
end;
procedure TFrmImagen.CropImage;
var
  CropRect: TRect;
  CroppedBitmap: TBitmap;
begin
  if not Assigned(Image1.Picture.Bitmap) then Exit;

  // Asegúrate de que los puntos están dentro de la imagen
  CropRect := Rect(
    Max(0, Min(StartPoint.X, EndPoint.X)),
    Max(0, Min(StartPoint.Y, EndPoint.Y)),
    Min(Image1.Picture.Bitmap.Width, Max(StartPoint.X, EndPoint.X)),
    Min(Image1.Picture.Bitmap.Height, Max(StartPoint.Y, EndPoint.Y))
  );

  // Valida que el área no sea vacía
  if (CropRect.Width > 0) and (CropRect.Height > 0) then
  begin
    CroppedBitmap := TBitmap.Create;
    try
      CroppedBitmap.Width := CropRect.Width;
      CroppedBitmap.Height := CropRect.Height;

      CroppedBitmap.Canvas.CopyRect(
        Rect(0, 0, CroppedBitmap.Width, CroppedBitmap.Height),
        Image1.Picture.Bitmap.Canvas, CropRect
      );

      // Asigna la imagen recortada al componente
      Image1.Picture.Bitmap.Assign(CroppedBitmap);
    finally
      CroppedBitmap.Free;
    end;
  end
  else
  begin
    // Elimina el mensaje si el área de recorte no es válida
    Exit;
  end;
end;
procedure TFrmImagen.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if IsSelecting then
  begin
    IsSelecting := False;
    EndPoint := Point(X, Y);
    if (Abs(EndPoint.X - StartPoint.X) > 1) and (Abs(EndPoint.Y - StartPoint.Y) > 1) then
    begin
      CropImage; // Llama al método de recorte
    end;
  end;
end;

procedure TFrmImagen.Label1Click(Sender: TObject);
begin

end;

procedure TFrmImagen.Label3Click(Sender: TObject);
begin

end;


procedure TFrmImagen.MImagen(B:TBitmap);
begin
  GuardaEstadoImg;
    Image1.Picture.Assign(B);
end;

procedure TFrmImagen.mnuOpExpoClick(Sender: TObject);
var
  alf:Real;
begin
    FrmExponencial.ShowModal;
    showMessage('s');
    if FrmExponencial.ModalResult = mrOK then
    begin
      alf := FrmExponencial.alfa;
      Iancho:=Bm.Width;
      Ialto:=Bm.Height;
      BM_MAT(Bm,MTR);
      FExponencial(MTR,MRES,Iancho,Ialto,alf);
      MAT_BM(MRES,Bm,Iancho,Ialto);
      MImagen(bm);
    end;
end;

procedure TFrmImagen.mnuOpGris1Click(Sender: TObject);
begin
   Iancho:=Bm.Width;
   Ialto:=Bm.Height;
   BM_MAT(Bm,MTR);
   FPGris1(MTR,MRES,Iancho,Ialto);
   MAT_BM(MRES,Bm,Iancho,Ialto);
   MImagen(Bm);
end;

procedure TFrmImagen.mnuOpgris2Click(Sender: TObject);
begin
      Iancho:=Bm.Width;
   Ialto:=Bm.Height;
   BM_MAT(Bm,MTR);
   FPGris2(MTR,MRES,Iancho,Ialto);
   MAT_BM(MRES,Bm,Iancho,Ialto);
   MImagen(Bm);
end;

procedure TFrmImagen.mnuOpLogaritmicoClick(Sender: TObject);
begin
 Iancho:=Bm.Width;
   Ialto:=Bm.Height;
   BM_MAT(Bm,MTR);
   FPLogarit(MTR,MRES,Iancho,Ialto);
   MAT_BM(MRES,Bm,Iancho,Ialto);
   MImagen(Bm);
end;

procedure TFrmImagen.mnuOpNegativoClick(Sender: TObject);
begin
   Iancho:=Bm.Width;
   Ialto:=Bm.Height;
   BM_MAT(Bm,MTR);
   FPNegativo(MTR,MRES,Iancho,Ialto);
   MAT_BM(MRES,Bm,Iancho,Ialto);
   MImagen(Bm);
end;

procedure TFrmImagen.mnuOpRPerfilInClick(Sender: TObject);
begin
  UPerfil.Perfildeintensidad.Show;
end;

procedure TFrmImagen.mnuOpSenoClick(Sender: TObject);
begin
    Iancho:=Bm.Width;
   Ialto:=Bm.Height;
   BM_MAT(Bm,MTR);
   FSeno(MTR,MRES,Iancho,Ialto);
   MAT_BM(MRES,Bm,Iancho,Ialto);
   MImagen(Bm);
end;

procedure TFrmImagen.mnuOpUmbralClick(Sender: TObject);
var
  umbralStr: String;
  umbral: Integer;
  sentidoStr: String;
  sentido: Boolean;
begin
  // Solicita el umbral
  umbralStr := InputBox('Configuración de Umbral', 'Introduzca el umbral (0-255):', '128');
  if TryStrToInt(umbralStr, umbral) and (umbral >= 0) and (umbral <= 255) then
  begin
    // Solicita el sentido
    sentidoStr := InputBox('Configuración de Sentido', 'Introduzca 1 para invertido, 0 para normal:', '0');
    sentido := (sentidoStr = '1');

    // Llama al procedimiento con los valores ingresados
        // Procesa la imagen con los valores recibidos por mensaje
    Iancho := BM.Width;
    Ialto := BM.Height;
    BM_MAT(BM, MTR);
    FPGris2(MTR, MRES, Iancho, Ialto);
    FPUmbral(MTR, MRES, Iancho, Ialto, sentido, umbral);
    MAT_BM(MRES, BM, Iancho, Ialto);
    MImagen(BM);
  end
  else
  begin
    ShowMessage('El umbral debe ser un número entre 0 y 255.');
  end;
end;

procedure TFrmImagen.mnuPuntualGammaClick(Sender: TObject);
var
  gam: real;
begin
    frmfunciongama.ShowModal;
    if frmfunciongama.ModalResult = mrOK then
    begin
      gam:= frmfunciongama.g;
      Iancho:=Bm.Width;
      Ialto:=Bm.Height;
      BM_MAT(Bm,MTR);
      FPGamma(MTR,MRES,Iancho,Ialto,gam);
      MAT_BM(MRES,Bm,Iancho,Ialto);
       MImagen(Bm);
    end;
end;

procedure TFrmImagen.mnuVImagenCompletaClick(Sender: TObject);
begin

  // Cambia el estado de Stretch según el valor de Checked
  Image1.Stretch := mnuVImagenCompleta.Checked;
  Image1.AutoSize:=not mnuVImagenCompleta.Checked;

  // Cambia el estado de Checked al hacer clic
  mnuVImagenCompleta.Checked := not mnuVImagenCompleta.Checked;



  // Si Stretch es falso, redimensiona el TImage al tamaño original de la imagen
end;


end.

