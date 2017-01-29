unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, fpSpreadsheet;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  NazwaPliku: string;
  Diag: string;
  skoroszyt_out: TsWorkbook;
  skoroszyt_in: TsWorkbook;
  arkusz_out: TsWorksheet;
  arkusz_in: TsWorksheet;
  i: Integer;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     if OpenDialog1.Execute then
     begin
           NazwaPliku := OpenDialog1.FileName;
           Diag := Concat('Nazwa pliku: ', NazwaPliku);
           Label2.Caption:=Diag;

           skoroszyt_in := TsWorkbook.Create;
           skoroszyt_in.ReadFromFile(NazwaPliku);

           for i := 0 to skoroszyt_in.GetWorksheetCount() - 1 do
             begin
               arkusz_in := skoroszyt_in.GetWorksheetByIndex(i);
               Diag := Diag + LineEnding +  arkusz_in.Name;
               Label2.Caption:=Diag;
               //ShowMessage(arkusz_in.Name);
               // Do something with MyWorksheet
             end;

           skoroszyt_in.Free;
     end;
end;

end.

