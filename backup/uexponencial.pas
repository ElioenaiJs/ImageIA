unit Uexponencial;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls;

type

  { TFrmExponencial }

  TFrmExponencial = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TrackBar1: TTrackBar;
    Valoralfa: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    alfa: real;
  end;

var
  FrmExponencial: TFrmExponencial;

implementation

{$R *.lfm}

{ TFrmExponencial }

procedure TFrmExponencial.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFrmExponencial.FormCreate(Sender: TObject);
begin
  Valoralfa.Caption:='0.05';
  alfa := 0.05;
end;

procedure TFrmExponencial.Button1Click(Sender: TObject);
begin

end;

end.

