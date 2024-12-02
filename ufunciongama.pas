unit Ufunciongama;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls;

type

  { TFrmfunciongama }

  TFrmfunciongama = class(TForm)
    Baceptar: TButton;
    Bcancelar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblPosicion: TLabel;
    TrackBar1: TTrackBar;
    procedure BaceptarClick(Sender: TObject);
    procedure BcancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private

  public
     g : real;
  end;

var
  Frmfunciongama: TFrmfunciongama;

implementation

{$R *.lfm}

{ TFrmfunciongama }


procedure TFrmfunciongama.TrackBar1Change(Sender: TObject);
begin
  g := TrackBar1.Position/20;
  lblPosicion.Caption:=FloatToStr(g);
end;


procedure TFrmfunciongama.BcancelarClick(Sender: TObject);
begin
  close;
end;

procedure TFrmfunciongama.BaceptarClick(Sender: TObject);
begin

end;

procedure TFrmfunciongama.FormCreate(Sender: TObject);
begin
  lblPosicion.Caption:='1.0';
  g:=1.0;
end;

end.

