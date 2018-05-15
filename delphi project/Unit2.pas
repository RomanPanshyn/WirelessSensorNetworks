unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, ExtCtrls;

type
  TForm2 = class(TForm)
    Table1: TStringGrid;
    Logo1: TRichEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
  uses unit1;
  
{$R *.dfm}

end.
