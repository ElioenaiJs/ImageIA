unit uPuntuales;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,Uvarios,Math;

 const
   lam=255;

   procedure FPNegativo(var M1: Mat3D; var M2 : Mat3D; mc,nr:Integer);
   procedure FPGris1(var M1: Mat3D; var M2 : Mat3D; mc,nr:Integer);
   procedure FPGris2(var M1: Mat3D; var M2 : Mat3D; mc,nr:Integer);
   procedure FPGamma(var M1 : Mat3D; var M2: Mat3D; mc,nr: Integer; g: real);
   procedure AplicaLut(var M1 :Mat3D; var M2: Mat3D; mc,nr: Integer; T: ArrLam);
   procedure FPUmbral(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; sentido: Boolean; p1: Integer);
   procedure FPLogarit(var M1,M2 : Mat3D; mc,nr : integer );
    procedure FSeno(var M1: Mat3D; var M2 : Mat3D; mc,nr:Integer);
    procedure FExponencial(var M1 : Mat3D; var M2: Mat3D; mc,nr: Integer; a: real);
implementation
 var
   tabla : ArrLam;
  procedure FPNegativo(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
  var
    i,j,k: Integer;
    begin
      SetLength(M2,mc,nr,3);
      for j:=0 to nr-1 do
      for i:=0 to mc-1 do
      for k:=0 to 2 do
      M2[i][j][k]:= not M1[i][j][k];

    end;
  procedure FPGris1(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
  var
    i,j,Gris:Integer;
    begin

       SetLength(M2,mc,nr,3);
      for j:=0 to nr-1 do
      for i:=0 to mc-1 do
      begin
       Gris := Round(M1[i][j][0] * 0.299 + M1[i][j][1] *  0.114+ M1[i][j][2] *0.587);

      M2[i][j][0] := Gris;
      M2[i][j][1] := Gris;
      M2[i][j][2] := Gris;
    end;
     end;
  procedure FPGris2(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
  var
    i,j,Gris:Integer;
    begin

       SetLength(M2,mc,nr,3);
      for j:=0 to nr-1 do
      for i:=0 to mc-1 do
      begin
       Gris := Round(integer((M1[i][j][0] + M1[i][j][1]  + M1[i][j][2])div 3));

      M2[i][j][0] := Gris;
      M2[i][j][1] := Gris;
      M2[i][j][2] := Gris;
    end;
     end;
 procedure FPGamma(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; g : Real);
 var
   k: Integer;
   begin
     SetLength(M2,mc,nr,3);
     for k:=1 to lam do
     tabla[k]:= Round(lam * Power(k/lam,g));
     AplicaLut(M1,M2,mc,nr,tabla);
   end;
 procedure AplicaLut(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; T: ArrLam);
 var
   i,j,k,z : Integer;
 begin
   for j:=0 to nr-1 do
       for i:= 0 to mc-1 do
           for k:=0 to 2 do
           begin
           z:= M1[i][j][k];
           M2[i][j][k]:= tabla[z];
           end;
 end;
 procedure FPUmbral(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; sentido: Boolean; p1: Integer);
 var
   i, j: Integer;
 begin
   SetLength(M2, mc, nr, 3);

   for j := 0 to nr - 1 do
   begin
     for i := 0 to mc - 1 do
     begin
       if (sentido and (M1[i][j][0] > p1)) or ((not sentido) and (M1[i][j][0] <= p1)) then
         begin
           M2[i][j][0] := 255;
           M2[i][j][1] := 255;
           M2[i][j][2] := 255; // Blanco
         end
       else
         begin
           M2[i][j][0] := 0;
           M2[i][j][1] := 0;
           M2[i][j][2] := 0;  // Negro
         end;
     end;
   end;
 end;
procedure FPLogarit(var M1,M2 : Mat3D; mc,nr : integer );
var
  k : integer;
begin
   SetLength(M2,mc,nr,3);
   for k:=1 to lam do
   tabla[k] := Round((lam/ln(lam+1))*ln(k+1));
   AplicaLut(M1,M2,mc,nr,tabla);
end;
procedure FSeno(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
var
  k:Integer;
begin
     SetLength(M2,mc,nr,3);
     for k:=1 to lam do
     tabla[k]:= round(lam*sin((Pi*k)/(2*lam)));
     AplicaLut(M1,M2,mc,nr,tabla);
end;

end.

