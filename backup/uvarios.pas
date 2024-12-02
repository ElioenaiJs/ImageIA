unit Uvarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,Graphics, SysUtils,IntfGraphics;
const
  tam_max = 1;
type
  Mat3D = array of array of array of byte;
  ArrInt= array [0..3,0..255] of LongWord;
  ArrLam = array [0..255] of byte;
  procedure BM_MAT(var B: TBitMap; var M:Mat3D);
  procedure MAT_BM(var M:Mat3D;var B:TBitMap; nc,nr: Integer);
  var
    BA:TBitMap;
    bCON: Integer =0;

implementation
procedure BM_MAT(var B: TBitMap; var M: Mat3D);
var
  p: PByteArray;
  i,j,k,Nancho,Nalto: Integer;
  t: TLazIntfImage;
 begin
   Nancho:= B.Width;
   Nalto:=B.Height;
   SetLength(M,Nancho,Nalto,3);
   t:=B.CreateIntfImage;
   for j:= 0 to Nalto-1 do
   begin
        p:=t.GetDataLineStart(j);
        for i:=0 to Nancho-1 do
        begin
             k:=3*i;
             M[i,j,0]:=p^[k];
             M[i,j,1]:=p^[k+1];
             M[i,j,2]:=p^[k+2];
        end;
   end;
   t.Free;
 end;

procedure MAT_BM(var M: Mat3D; var B: TBitMap; nc,nr: Integer);
var
  p: PByteArray;
  i,j,k: Integer;
  t:TLazIntfImage;
  begin
    B.Width:=nc;
    B.Height:=nr;
    t:=B.CreateIntfImage;
    for j:=0 to nr-1 do
    begin
         p:=t.GetDataLineStart(j);
         for i:=0 to nc-1 do
         begin
              k:=3*i;
              p^[k]:=M[i,j,0];
              p^[k+1]:=M[i,j,1];
              p^[k+2]:=M[i,j,2];
         end;
    end;
    B.Assign(t);
    t.Free;
  end;
end.

