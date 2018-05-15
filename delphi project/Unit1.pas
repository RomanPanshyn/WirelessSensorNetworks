unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Spin, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    Image1: TImage;
    Enter: TButton;
    N3: TMenuItem;
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button2: TButton;
    procedure N2Click(Sender: TObject);
    procedure EnterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

 const n=49;                                  {����� ����� � ����}
      l=200000;

 type T=set of 0..n;
      massiv=array  [1..n,1..n] of    real;
         spv=array  [1..l,1..4] of integer;

 var
  Form1: TForm1;
  xy:array  [1..n,1..2] of integer;  {������ ���������  �����}
  MT:array  [1..l]      of       T;
          Ms:array  [1..n]      of       T;
           d:array  [1..n+1]    of       T;
      Mcoced:array  [1..n]      of integer;  {������ �������}
         Gij:array  [1..n,1..n] of    real;
        G1ij:array  [1..n,1..n] of    real;
           G:array  [1..n]      of    real;
         VAL:array  [1..l]      of    real;
        VALr:array  [1..n,1..n] of integer;
          PS:array  [1..1000]   of    real;  {������  ��}
      MPower:array  [1..n]      of integer;  {������ ��������� �����}
          Cv:array  [1..n,1..n] of integer;  {������ ���������}
     Mpravil:array [1..n,1..n]  of integer;  {������ ������}
         Mgr:array  [1..n,1..n] of    real;  {������ ��������}
        Mdis:array  [1..n,1..n] of    real;  {������ ����������}
         Sij:massiv;
    S0,gradus1,gradus2,gradus,kon,sum,F,Fmax,Fmin,Rad,R1,Rad1,Rad2:real;
    st:string;   Ch:char;
    q,z,z1:integer;
    Rmax,Nprav,Uz1,Uz2,Nprogonov,pn,r,i,j,k,m,p,v,per,first:integer;
    perem,perem1,perem2:integer;
    a,b,c:T;
    SP:SPV;
    ByStep,Udalit,Y,RASX,KONEZ,Zakonzit,Done:boolean;
    Niter,Ncvajz:integer;

    Procedure Ugol(var alfa:real;io,i1:integer);
    Procedure Ugol_(var alfa:real;o,a,b:integer);
    Procedure Radius(var R:real; i,j:integer);
    Procedure Graf;
    
implementation
 uses unit2,unit3;

label M1000,m2222;


{$R *.dfm}

procedure Delay(Value: Cardinal);
var
  F, N: Cardinal;
begin
  N := 0;
  while N <= (Value div 10) do
  begin
    SleepEx(1, True);
    Application.ProcessMessages;
    Inc(N);
  end;
  F := GetTickCount;
  repeat
    Application.ProcessMessages;
    N := GetTickCount;
  until (N - F >= (Value mod 10)) or (N < F);
end;


Procedure Ugol(var alfa:real;io,i1:integer);
Label M1;
 begin
 if (xy[io,1]=xy[i1,1]) then
  begin
   if (xy[io,2]>xy[i1,2]) then
    alfa:=90
   else
    alfa:=270;
   goto m1;
  end;
 if (xy[io,2]=xy[i1,2]) then
  begin
   if (xy[io,1]>xy[i1,1]) then
    alfa:=180
   else
    alfa:=0;
   goto m1;
  end;
 alfa:=arctan(abs(xy[i1,2]-xy[io,2])/abs(xy[i1,1]-xy[io,1]))*180/Pi;
 if (xy[io,1]>xy[i1,1])and(xy[io,2]>xy[i1,2]) then
  begin
   alfa:=180-alfa;
   goto m1
  end;
 if (xy[io,1]>xy[i1,1])and(xy[io,2]<xy[i1,2]) then
  begin
   alfa:=alfa+180;
   goto m1
  end;
 if (xy[io,1]<xy[i1,1])and(xy[io,2]>xy[i1,2]) then
  begin
   alfa:=alfa;
   goto m1
  end;
 if (xy[io,1]<xy[i1,1])and(xy[io,2]<xy[i1,2]) then
  alfa:=360-alfa;
 M1: end;

Procedure Ugol_(var alfa:real;o,a,b:integer);
begin
 alfa:=abs(Mgr[o,a]-Mgr[o,b]);
 if alfa>180 then alfa:=360-alfa;
end;


Procedure Radius(var R:real; i,j:integer);
 var ttt,eee:real;
 begin
   ttt:=abs(xy[i,1]-xy[j,1]);ttt:=ttt*ttt;
   eee:=abs(xy[i,2]-xy[j,2]);eee:=eee*eee;
   R:=Sqrt(ttt+eee);
 end;

{-------------------������ ���������� �����������--------------------------------} 
Procedure Raczet_PS(var Suma:real);
Label M4,M5,M7,M6,M8,M9,M10,M11,M13,M12,M14,M15,M16;
begin
 per:=1;
 for i:=1 to l do
  MT[i]:=[];
 for i:=1 to l do
  for j:=1 to 4 do
   sp[i,j]:=0;
 for i:=1 to n do
  for j:=1 to n do
   begin
    Gij[i,j]:=0;
    G1ij[i,j]:=0;
    VALr[i,j]:=0;
   end;
 Ncvajz:=0;
 for i:=1 to n do
  for j:=1 to n do
   if Cv[i,j]<>0 then
    begin
     Ncvajz:= Ncvajz+1;
     Sij[i,j]:=0.3
    end;
 MT[1]:=[1..n];
 for i:=1 to n do
  ms[i]:=[];
 for i:=1 to n do
  for j:=1 to n do
 if (Cv[i,j]<>0)or(i=j) then
  begin
   a:=[j];
   ms[i]:=ms[i]+a;
  end;
 i:=1;
 j:=1;
 k:=1;
 KONEZ:=False;

 m7:    
 a:=[]; b:=[];
 if MT[i]=[0] then i:=i+1;
 for j:=1 to n do
  begin
   b:=d[j]*MT[i];
   if b<>[] then
    begin
     a:=d[j];
     goto m6;
    end;
  end;
 m6:
  if a<>[] then
   begin
    if (a=MT[i]) and (per=1) then
     begin
      k:=k+1;
      first:=k;
      SP[i,1]:=k;
      SP[i,2]:=k;
      MT[k]:=[0];
      per:=2;
     end;
    if (a=MT[i]) and (per=2) then
     begin
      SP[i,1]:=first;
      SP[i,2]:=first;
      SP[i,3]:=j;
      i:=i+1;
      goto m7;
     end;

    SP[i,3]:=j;
    b:=MT[i]-a;
    c:=MT[i]-Ms[j];
    if (per=1) and (b=[]) then
     begin
      k:=k+1;

      first:=k;
      MT[k]:=[0];
      SP[i,1]:=k;
      per:=2;
      goto m10
     end;
    if (per=2) and (b=[]) then
     begin
      SP[i,1]:=first;
      goto m10;
     end;
    y:=False;
    for j:=2 to k do
     if b=MT[j] then
      begin
       y:=True;
       goto m4;
      end;
 m4:  if y=false then
       begin
        k:=k+1;

        MT[k]:=b;
        SP[i,1]:=k
 end
 else SP[i,1]:=j;
 m10:  if (per=1) and (c=[]) then
        begin
         k:=k+1;

      first:=k;
      MT[k]:=[0];
      SP[i,2]:=k;
      per:=2; i:=i+1; goto m7
 end;
 if (per=2) and (c=[]) then
 begin
      SP[i,2]:=first; i:=i+1; goto m7
 end;
 y:=False;
 for j:=2 to k do
 if c=MT[j] then
 begin
      y:=True;  goto m5
 end;

 m5:
 if y=false then
  begin
   k:=k+1;

   MT[k]:=c;
   SP[i,2]:=k
  end
 else SP[i,2]:=j;
 i:=i+1;
 goto m7
 end;
 if KONEZ=True then goto m9;
 m:=k;
 for i:=1 to n do
  begin
   for j:=1 to n do
    begin
     b:=MS[i]*d[j];
     if (b<>[]) and (b<>d[i]) then
      begin
       a:=MS[i]+MS[j];
       if a=MS[i] then
        begin
         VALr[i,j]:=first;
         goto m8
        end;
       a:=MT[1]-a;
       y:=False;
       for p:=1 to k-1 do    //bug in Turbo Pascal version
        if (a=MT[p]) and (a<>[]) and (MT[p]<>[]) then
         begin
          VALr[i,j]:=p;
          y:=True;
          goto m8
         end;
       if (y=False) and (a<>[]) and (MT[p]<>[]) then
        begin
         k:=k+1;
         VALr[i,j]:=k;
       
         MT[k]:=a;
        end;
      end;
 m8:
 end;
 end;
 KONEZ:=True;
 i:=m+1;
 goto m7;

 m9: r:=1;
 for i:=1 to k do
  if (SP[i,1]=SP[i,2]) and (SP[i,1]=first) then
   begin
    SP[first,4]:=i;
    PN:=first;
    goto m11
   end;
 m11:  for i:=1 to k do
        begin
         if SP[i,4]=0 then
          begin
           p:=SP[i,1];
           v:=SP[i,2];
           if (SP[p,4]<>0) and (SP[v,4]<>0) then
            begin
             SP[PN,4]:=I;
             PN:=i;
             SP[i,4]:=200;
             r:=r+1
            end;
      end
 end;
 if PN<>1 then goto m11;
  SP[1,4]:=0;
  VAL[first]:=1; KONEZ:=false;
  
 {--------------------������������ ���������-----------------}
 Fmin:=0; Fmax:=1; F:=0.5;Niter:=0;

 m13: Niter:=Niter+1;
  for i:=1 to n do
   for j:=1 to n do
    if Sij[i,j]<>0 then Gij[i,j]:=Sij[i,j]*F;
    if KONEZ=true then goto m16;

 m14:
 for i:=1 to n do
 begin
  sum:=0;
  for j:=1 to n do
   sum:=sum + Gij[i,j]; G[i]:=sum;
 end;
 i:=SP[first,4];
 for r:=1 to k - 1 do
  begin
   VAL[i]:=VAL[SP[i,1]] + G[SP[i,3]]*VAL[SP[i,2]];
   i:=SP[i,4];
 end;
 for i:=1 to n do
  for j:=1 to n do
   if Cv[i,j]<>0 then
    G1ij[i,j]:=F*Sij[i,j]*VAL[1]/VAL[VALr[i,j]];
 RASx:=false;
 p:=0;
 for i:=1 to n do
  for j:=1 to n do
   begin
    if G1ij[i,j]>1000 then
     begin
      RASX:=true;
      goto m12
     end;
    if (Cv[i,j]<>0) and (abs((G1ij[i,j] - Gij[i,j]))<0.01) then
     p:=p+1;
   end;
 if p=Ncvajz then
  goto m12;
 m15:  for i:=1 to n do
        for j:=1 to n do
         Gij[i,j]:=G1ij[i,j];
  goto m14;

 m12:  if RASX=true then
        Fmax:=F
       else
        Fmin:=F;
 if (Fmax - Fmin)>0.01 then
  begin
   F:=(Fmax + Fmin)/2;
   goto m13
  end
 else
  KONEZ:=true;
 goto m13;

 m16:  for i:=1 to n do
        begin
         sum:=0;
         for j:=1 to n do
          sum:=sum + Gij[i,j];
          G[i]:=sum;
        end;
 i:=SP[first,4];
 for r:=1 to k - 1 do
  begin
   VAL[i]:=VAL[SP[i,1]] + G[SP[i,3]]*VAL[SP[i,2]];
   i:=SP[i,4];
  end;
 for i:=1 to n do
  for j:=1 to n do
   if Cv[i,j]<>0 then
    Sij[i,j]:=Gij[i,j]/VAL[1]*VAL[VALr[i,j]];

 Suma:=0;
 for i:=1 to n do
  for j:=1 to n do
   if Cv[i,j]<>0 then
    Suma:=Sij[i,j]+Suma;
end;

{--------------------------------------------------------------------------------}

Procedure Graf;
var i,j:integer;
begin
with Form1.Image1.Canvas do
 begin
  Pen.Style:=psSolid;
  for i:=1 to n do
   for j:=i to n do
    begin
     Font.Color:=clGreen;
     Pen.Color:=$96866C;
     Brush.Color:=$96866C;
     Rectangle(xy[i,1]-4,xy[i,2]-3,xy[i,1]+4,xy[i,2]+8);
     Brush.Color:=clBlack;
     Pen.Color:=clBlack;
     Rectangle(xy[i,1]-4,xy[i,2]-3,xy[i,1],xy[i,2]-10);
     Brush.Color:=clWhite;
     TextOut(xy[i,1]+4,xy[i,2]+4,IntToStr(i));
     Pen.Color:=clRed;
     if (Cv[i,j]=1) then
      begin
       MoveTo(xy[i,1],xy[i,2]);
       LineTo(xy[j,1],xy[j,2]);
      end;
    end;

   if ByStep=True then
    begin
     Form1.Memo1.Clear;
     Delay(1);
     Form1.Memo1.Lines.Append('������� '+IntToStr(Nprav));
    end;
  if Udalit=True then
    begin
     if ByStep=True then
      Form1.Memo1.Lines.Append('������� '+IntToStr(Uz1)+' - '+IntToStr(Uz2));
     Pen.Color:=clWhite;
     MoveTo(xy[Uz1,1],xy[Uz1,2]);
     LineTo(xy[Uz2,1],xy[Uz2,2]);
     Font.Color:=clBlue;
    end
  else
   begin
    if ByStep=True then
     Form1.Memo1.Lines.Append('�������� '+IntToStr(Uz1)+' - '+IntToStr(Uz2));
    MoveTo(xy[Uz1,1],xy[Uz1,2]);
    LineTo(xy[Uz2,1],xy[Uz2,2]);
   end;
 end;
end;

{-----------------------������� 1-----------------------------}
Procedure Rule_1(var Zakonzit:boolean);
Label M20,M33;
 begin
 m33:      Nprogonov:=Nprogonov+1;          {c������ ��� �����������}
{------------������� �� �������� ���� ����� ������------------------}
   Nprav:=1;
 for i:=1 to n do
  for j:=1 to n do      {������� � ������� ���������}
   if (Cv[i,j]=1)and(i<>j)  then                    {������� �����}
    begin
    for p:=j+1 to n do
     if (Cv[i,p]=1)and(j<>p) then                         {������� �����}
      begin                                          {������� �����}
       Ugol_(gradus,i,j,p);                            {���������� ����}
{--------------------------���� �����-------------------------------}
{  ����  ����  ijp ����� � ���������� i-� �������� �������          }
{  ����� i-k �� ��������� �������� ���� i                           }

     if gradus>90 then
      begin                                              {���� �����}
       R1:=1000; m:=1000;
       for k:=1 to n do       { ����� ���� � ������� �������� �����}
        if (i<>k)and(k<>p)and(k<>j)and(Mdis[i,k]<Rmax)
          and(Mpravil[i,k]<>-1)  { ����� �� ������ ���������� ��������}
         then
          begin
           if    Mdis[i,k]<R1 then
            begin
             Ugol_(gradus1,i,j,k);
             Ugol_(gradus2,i,k,p);
             if (Mdis[j,k]<Mdis[i,k])and(Mdis[p,k]<Mdis[i,k])
                                       { ���� ����� � ��������� ijp }
                and(gradus1<90) and (gradus2<90)  then
              begin
               if Cv[i,k]=1 then
                begin
                 goto m20;
                end;            { ���� ����� ��� ���������� - ��������� }
               R1:=Mdis[i,k];
               m:=k
              end;
            end;
          end;                                              { ����� }
        if  m<>1000 then                             { ������� ��������� }
         begin
          Cv[i,m]:=1;
          Cv[m,i]:=1;
          Sij[i,m]:=0.3;
          Sij[m,i]:=0.3;
          Udalit:=False;
          Uz1:=i;
          Uz2:=m;
          Mpravil[i,m]:=1;
          Mpravil[m,i]:=1;
          Graf;
          if ByStep=True then Exit;
          goto m33;
         end;
      end;
{----------------------- ���� ������--------------------------------}
{    ���� ���� ijp ������ � ���������� i-� ��������                 }
{    �������� ����� i-k ����� ��������� �������� ���� i             }

    if gradus<90 then
     begin                                              {���� ������}
       R1:=1000;
       m:=1000;
       for k:=1 to n do
        if (i<>k)and(k<>p)and(k<>j)and(Mdis[i,k]<Rmax) then
         begin                                    {  �������  ����� }
          if Mdis[i,k]<R1 then
           begin                                 { ����������� ����� }
            Ugol_(gradus1,i,j,k);
            Ugol_(gradus2,i,k,p);
            if (Mdis[j,k]<Mdis[i,k]) and (Mdis[p,k]<Mdis[i,k])
                                       { ���� ����� � ��������� ijp }
              and(gradus1<45)and(gradus2<45) then        { � ������ ���� i }
             begin
              if (Cv[i,k]=1) and (Cv[j,k]=1) and (Cv[p,k]=1) then
               begin
                m:=k;
                R1:=Mdis[i,k];
               end;
             end;
           end;
         end;

       if   m<>1000 then                { ������� ��������� }
        begin                       { ������� ����� i-k }
         Udalit:=True;
         Cv[i,m]:=0;
         Cv[m,i]:=0;
         Sij[i,m]:=0;
         Sij[m,i]:=0;
         Uz1:=i;
         Uz2:=m;
         Mpravil[i,m]:=-1;
         Mpravil[m,i]:=-1;     { ����� ��������� }
         Graf;
         if ByStep=True then Exit;
         goto m33;
        end;
     end;

{-------------------------------------------------------------------}
 m20: end;
 end;
 if m=1000 then
  begin
   Zakonzit:=True;      {������� �� ���������,�������� }
   perem1:=3;
  end;
end;


 {---------------------������� 3 �� ����� ����----------------------}
 { ���� ���� jik ��� � ���������� i-� �������� �������� }
 { ����� i-k, �� ��������� �������� ���� i }
Procedure Rule_3;
 Label M3;
begin
 m3:
   Nprav:=3;
   for i:=1 to n do
    for j:=1 to n do    {������� � m������ ���������}
     if (Cv[i,j]=1)and(i<>j)  then                      {������� �����}
      begin
       for p:=1 to n do
        if (Cv[i,p]=1)and(j<>p) then                   { ������� ����� }
         begin
          Ugol_(gradus,i,j,p);                       { ����������� ���� }
          if (gradus<30)                                     { ���� ��� }
            and(Mdis[i,j]<Mdis[i,p])and(Cv[j,p]=1)
            and(Mpravil[i,p]<>1) then {����� �� ��������� ������  ��������}
           begin
            Udalit:=True;
            Cv[i,p]:=0;
            Cv[p,i]:=0;      {������� ����� }
            Sij[i,p]:=0;
            Sij[p,i]:=0;
            Uz1:=i;Uz2:=p;
            Mpravil[i,p]:=-1;
            Mpravil[p,i]:=-1;
           end; { ������� �� ��������}
         end;
      end;
   Graf;
   perem1:=5;
   if ByStep=True then Exit;
end;

{-------------������� 2 �� ������� ����� �������-------------------}
{ ���������  ���������� ����������� ����� ������� - 4..6           }
Procedure Rule_2;
begin
 Nprav:=2;
 for i:=1 to n do
  begin
   v:=0;             { ��������� ������ ������� ������� ���� }
   for j:=1 to n do
    if Cv[i,j]=1 then
     v:=v+1;
   Mcoced[i]:=v;
  end;
 for i:=1 to n do
  if Mcoced[i]>6 then{����� ������� ������ ������������}
   begin
    for j:=1 to n  do            { ����� ����� �-��� ����� ������ }
     if (i<>j)and(Cv[i,j]=1)                         {������� ����� }
       and(Mcoced[j]>6)            { ����� ������� ���������� ���� }
       and(Mpravil[i,j]<>1) then              { ����� ��� �� ��������� }
      begin
       Cv[i,j]:=0;
       Cv[j,i]:=0;                       { ������� ����� }
       Sij[i,j]:=0;
       Sij[j,i]:=0;
       Mcoced[i]:=Mcoced[i]-1;    { ������� ������� � ������ ������� }
       Mcoced[j]:=Mcoced[j]-1;
       Udalit:=True;
       Uz1:=i;
       Uz2:=j;
       Graf;
       if ByStep=True then Exit;
      end;
   end
  else       { ����� ������� ������ ������������ }
   begin
    for j:=1 to n do         { ����� ����� ������� ����� �������� }
     if (i<>j)and(Cv[i,j]<>1)                   {  ���� ���������� }
        and(Mcoced[j]<4)   { ����� ��� ������� ������ ������������ }
        and(Mdis[i,j]<Rmax)
        and(Mpravil[i,j]<>-1) then                { ����� �� ��������� }
      begin
       Udalit:=False;
       Cv[i,j]:=1;
       Cv[j,i]:=1;
       Sij[i,j]:=0.3;  Sij[j,i]:=0.3;              { �������� ����� }
       Mcoced[i]:=Mcoced[i]+1;   { ������� ������� � ������ ������� }
       Mcoced[j]:=Mcoced[j]+1;
       Uz1:=i;  Uz2:=j;
       Graf;
       if ByStep=True then Exit;
      end;
   end;
   perem1:=4;
end;
{-------------------����� ������� 2--------------------------------}


procedure TForm1.N2Click(Sender: TObject);
begin
Close;
end;

procedure Start;
begin
 {  ��������� �������� � ���������� ��������� �������� ����������   }
z:=1; Zakonzit:=False;  Nprogonov:=1;  Nprav:=0;  per:=1;
     for i:=1 to l do MT[i]:=[]; Uz1:=1; Uz2:=1;
     for i:=1 to l do for j:=1 to 4 do sp[i,j]:=0;
     for i:=1 to n do for j:=1 to n do
      begin
       Mpravil[i,j]:=0; Gij[i,j]:=0; Sij[i,j]:=0; Cv[i,j]:=0;
       Mdis[i,j]:=0; Mgr[i,j]:=0; G1ij[i,j]:=0; VALr[i,j]:=0;
      end;
     for i:=1 to n do d[i]:=[i]; d[n+1]:=[0];
     for i:=1 to 1000 do ps[i]:=0;

                     { ���������� ����� }
 {x} xy[1,1]:=60;xy[2,1]:=160;xy[3,1]:=260;xy[4,1]:=360;xy[5,1]:=460;
     xy[6,1]:=10;xy[7,1]:=110;xy[8,1]:=210;xy[9,1]:=310;xy[10,1]:=410;
     xy[11,1]:=510;xy[12,1]:=60;xy[13,1]:=160;xy[14,1]:=260;xy[15,1]:=360;
     xy[16,1]:=460;xy[17,1]:=10;xy[18,1]:=110;xy[19,1]:=210;xy[20,1]:=310;
     xy[21,1]:=410;xy[22,1]:=510;xy[23,1]:=60;xy[24,1]:=160;xy[25,1]:=260;
     xy[26,1]:=360;xy[27,1]:=460;xy[28,1]:=10;xy[29,1]:=110;xy[30,1]:=210;
     xy[31,1]:=310;xy[32,1]:=410;xy[33,1]:=510;xy[34,1]:=60;xy[35,1]:=160;
     xy[36,1]:=260;xy[37,1]:=360;xy[38,1]:=460;xy[39,1]:=10;xy[40,1]:=110;
     xy[41,1]:=210;xy[42,1]:=310;xy[43,1]:=410;xy[44,1]:=510;xy[45,1]:=60;
     xy[46,1]:=160;xy[47,1]:=260;xy[48,1]:=360;xy[49,1]:=460;

 {y} xy[1,2]:=10;xy[2,2]:=10;xy[3,2]:=10;xy[4,2]:=10;xy[5,2]:=10;
     xy[6,2]:=80;xy[7,2]:=80;xy[8,2]:=80;xy[9,2]:=80;xy[10,2]:=80;
     xy[11,2]:=80;xy[12,2]:=150;xy[13,2]:=150;xy[14,2]:=150;xy[15,2]:=150;
     xy[16,2]:=150;xy[17,2]:=220;xy[18,2]:=220;xy[19,2]:=220;xy[20,2]:=220;
     xy[21,2]:=220;xy[22,2]:=220;xy[23,2]:=290;xy[24,2]:=290;xy[25,2]:=290;
     xy[26,2]:=290;xy[27,2]:=290;xy[28,2]:=360;xy[29,2]:=360;xy[30,2]:=360;
     xy[31,2]:=360;xy[32,2]:=360;xy[33,2]:=360;xy[34,2]:=430;xy[35,2]:=430;
     xy[36,2]:=430;xy[37,2]:=430;xy[38,2]:=430;xy[39,2]:=500;xy[40,2]:=500;
     xy[41,2]:=500;xy[42,2]:=500;xy[43,2]:=500;xy[44,2]:=500;xy[45,2]:=570;
     xy[46,2]:=570;xy[47,2]:=570;xy[48,2]:=570;xy[49,2]:=570;

     Rmax:=200;  { ������ �������� ����� �� ���������}
     for i:=1 to n do
      MPower[i]:=Rmax;
     for i:=1 to n do
      for j:=1 to n do
       if i<>j then
        begin
         Radius(Rad,i,j); Mdis[i,j]:=Rad; { ���������� ������� ����������}
         Ugol(gradus,i,j);  Mgr[i,j]:=gradus;
         if  Rad<MPower[i]   then
          Cv[i,j]:=1;
        end;
end;

procedure TForm1.EnterClick(Sender: TObject);
var Summa,Suma1:real;
begin
 with Image1.Canvas do
  begin
   if perem=1 then
    begin
    Pen.Color:=clWhite;
    Rectangle(0,0,Form1.Image1.Width,Form1.Image1.Height);
    Form2.Logo1.Clear;
     ByStep:=False;
     Graf;
     Button1.Visible:=True;
     Button2.Visible:=False;
     Enter.Caption:=('�������� ���������');
     Enter.Top:=16;
     Enter.Left:=88;
     Enter.Height:=29;
     Enter.Width:=142;
     Label1.Visible:=False;
     Label2.Visible:=False;
     Label3.Visible:=False;
     Label4.Visible:=False;
     Memo1.Visible:=False;
     Memo2.Visible:=False;
     perem:=2;
     perem1:=1;
     Exit;
  end;

  if perem=2 then
   begin
    Enter.Visible:=False;
    ByStep:=False;
    Label1.Visible:=False;
    Label2.Visible:=True;
    Label4.Visible:=True;
    Memo1.Visible:=False;
    Memo2.Visible:=True;
    Memo2.Lines.Clear;
    Label3.Visible:=True;
    Button1.Visible:=False;
    Button2.Visible:=False;
    Delay(1);
    Raczet_PS(Summa);
    S0:=Summa;
    Memo2.Lines.Append('��������� ��= '+FloatToStrF(S0,ffFixed,9,7));
    if Zakonzit=False then
     Rule_1(Zakonzit);
    Rule_2;
    Rule_3;
    Raczet_PS(Summa);
    kon:=Summa;
    Enter.Visible:=True;
    Enter.Caption:='������� ��';
    Memo2.Lines.Append('�������� ��= '+FloatToStrF(kon,ffFixed,9,7));
    Suma1:=kon;
    Summa:=kon/S0*100-100;
    Memo2.Lines.Append('��������� �� � %=   '+FloatToStrF(Summa,ffFixed,9,7));
    Label3.Visible:=False;
    perem:=3;
    Exit;
   end;
  if perem=3 then
   begin
    with Form2.Table1 do
     begin
      Cells[0,0]:='  j \ i';
      for i:=1 to n do
       Cells[0,i]:=IntToStr(i);
      for j:=1 to n do
       Cells[j,0]:=IntToStr(j); 
      for i:=1 to n do
       for j:=1 to n do
        Cells[j,i]:=FloatToStrF(Sij[i,j],ffFixed,9,6);
     end;   
    with Form2.Logo1 do
     begin
      Lines.Append('����� ��������= '+IntToStr(Niter));
      Lines.Append('����� ������= '+IntToStr(k));
      Lines.Append('��������� ���������� ����������� ����= '+FloatToStr(kon));
     end;
    Form2.Show;
    Exit;
   end;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Start;
perem:=1;
perem1:=1;
perem2:=1;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
 with Form3.StringGrid1 do
  begin
   Cells[0,0]:='� �������';
   Cells[1,0]:='���������� �';
   Cells[2,0]:='���������� Y';
   Cells[3,0]:='��������';
   for i:=1 to n do
    begin
     Cells[0,i]:=IntToStr(i);
     Cells[1,i]:=IntToStr(xy[i,1]);
     Cells[2,i]:=IntToStr(xy[i,2]);
     Cells[3,i]:=IntToStr(MPower[i]);
    end;
  end;
 Form3.Show;
end;

procedure TForm1.Button1Click(Sender: TObject);
var Summa,Suma1:real;
begin
 {��������� ����������}
if perem1=1 then
begin
 Enter.Visible:=False;
 Enter.Caption:='��������� ��������� ����������';
 Enter.Width:=250;
 Label1.Visible:=True;
 Label2.Visible:=True;
 Label3.Visible:=True;
 Label4.Visible:=True;
 Memo1.Visible:=True;
 Memo1.Lines.Clear;
 Memo2.Visible:=True;
 Memo2.Lines.Clear;
 Button1.Visible:=False;
 ByStep:=True;
 Delay(1);
 Raczet_PS(Summa);
 S0:=Summa;
 Memo2.Lines.Append('��������� ��= '+FloatToStrF(S0,ffFixed,9,7));
 Label3.Visible:=False;
 Enter.Visible:=True;
 Button2.Visible:=True;
 Delay(1);
 perem1:=2;
 perem:=1;
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var Summa,Suma1:real;
begin
if perem1=2 then
begin
 if Zakonzit=False then
  Rule_1(Zakonzit);
 Exit;
end;

if perem1=3 then
begin
 Rule_2;
 Exit;
end;

if perem1=4 then
begin
 Rule_3;
 Exit;
end;

if perem1=5 then
begin
  Enter.Visible:=False;
  Label3.Visible:=True;
  Button2.Visible:=False;
  Label1.Visible:=False;
  Memo1.Visible:=False;
  Delay(1);
  Raczet_PS(Summa);
  kon:=Summa;
  Memo2.Lines.Append('�������� ��= '+FloatToStrF(kon,ffFixed,9,7));
  Suma1:=kon;
  Summa:=kon/S0*100-100;
  Memo2.Lines.Append('��������� �� � %=   '+FloatToStrF(Summa,ffFixed,9,7));
  Label3.Visible:=False;
  Enter.Visible:=True;
  Enter.Caption:='������� ��';
  Enter.Width:=142;
  Delay(1);
  perem:=3;
  Exit;
end;

end;

end.
