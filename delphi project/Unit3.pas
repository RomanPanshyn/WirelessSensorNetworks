unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ComCtrls;

type
  TForm3 = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
 uses unit1,unit2;
{$R *.dfm}



procedure TForm3.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TForm3.Button1Click(Sender: TObject);
var i,j:integer;
begin
{  обнуление массивов и присвоение начальных значений переменным   }
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

Form2.Logo1.Clear;
with StringGrid1 do
 begin
 for i:=1 to n do
  begin
   xy[i,1]:=StrToInt(Cells[1,i]);
   xy[i,2]:=StrToInt(Cells[2,i]);
   MPower[i]:=StrToInt(Cells[3,i]);
  end;
 end;  
   for i:=1 to n do
    for j:=1 to n do
      if i<>j then
       begin
        Radius(Rad,i,j); Mdis[i,j]:=Rad; { заполнение массива расстояний}
        Ugol(gradus,i,j);  Mgr[i,j]:=gradus;
        if  Rad<MPower[i]   then
         Cv[i,j]:=1;
       end;
   with Form1.Image1.Canvas do
    begin
     Pen.Color:=clWhite;
     Rectangle(0,0,Form1.Image1.Width,Form1.Image1.Height);
     ByStep:=False;
     Graf;
    end;
   with Form1 do
    begin
     Button1.Visible:=True;
     Button2.Visible:=False;
     Memo1.Visible:=False;
     Memo1.Lines.Clear;
     Memo2.Visible:=False;
     Memo2.Lines.Clear;
     Label1.Visible:=False;
     Label2.Visible:=False;
     Label3.Visible:=False;
     Label4.Visible:=False;
     Enter.Caption:=('Конечный результат');
     Enter.Top:=16;
     Enter.Left:=88;
     Enter.Height:=29;
     Enter.Width:=142;
    end;
     perem:=2;
     perem1:=1;
     Close;
end;

end.
