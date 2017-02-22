unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCzytaj: TButton;
    btnZamknij: TButton;
    lblStatystyki: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    txtZakres: TEdit;
    lblZakres: TLabel;
    Label2: TLabel;
    procedure btnZamknijClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnZamknijClick(Sender: TObject);
begin
  Close;
end;

end.

