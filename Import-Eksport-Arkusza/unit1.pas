unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, fpstypes, fpSpreadsheet, laz_fpspreadsheet;

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
  suma: real;
  srednia: real;
  komorka: PCell;
  ostatniWiersz: Integer;
  ostatniaKolumna: Integer;
  wiersz: Integer;


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
           Diag := Concat('Nazwa skoroszytu: ', NazwaPliku);
           Label2.Caption:=Diag;

           skoroszyt_in := TsWorkbook.Create;
           skoroszyt_in.ReadFromFile(NazwaPliku);

           // Utworzenie arkusza wyjściowego
           skoroszyt_out := TsWorkbook.Create;
           arkusz_out := skoroszyt_out.AddWorksheet('Wyniki');

           // Zapisanie nagłówka w arkuszu wyjściowym
           arkusz_out.WriteUTF8Text(0,0, 'Nazwa arkusza');
           arkusz_out.WriteBorders(0,0, [cbNorth, cbSouth]);
           komorka := arkusz_out.WriteUTF8Text(0,1, 'Suma');
           arkusz_out.WriteBackground(komorka, fsThinStripeHor, scBlue, scYellow);
           komorka :=arkusz_out.WriteUTF8Text(0,2, 'Średnia');
           arkusz_out.WriteBackground(komorka, fsThinStripeHor, scCyan, scBlack);


           for i := 0 to skoroszyt_in.GetWorksheetCount() - 1 do
             begin
               arkusz_in := skoroszyt_in.GetWorksheetByIndex(i);

               ostatniaKolumna := arkusz_in.GetLastColIndex();
               ostatniWiersz := arkusz_in.GetLastRowIndex();

               suma:=0;
               // obliczenie sumy wartości w ostatniej kolumnie
               for wiersz := 1 to ostatniWiersz do
                   begin
                     suma:= suma + arkusz_in.ReadAsNumber(wiersz,ostatniaKolumna);
                   end;
               srednia:= suma / ostatniWiersz;
               ///////////////////////////////////////////////////
               Diag := Concat(Diag, LineEnding, 'Nazwa: ', arkusz_in.Name,
                    ' l. wierszy: ', IntToStr(ostatniWiersz),
                    ' l. kolumn: ', IntToStr(ostatniaKolumna + 1));
               Label2.Caption :=Diag;

               arkusz_out.WriteUTF8Text(i + 1,0, arkusz_in.Name);
               arkusz_out.WriteNumber(i+1, 1, suma);
               arkusz_out.WriteNumber(i+1, 2, srednia);

             end;

           skoroszyt_in.Free;

           // Zapis do arkusza wyjściowego:
           if SaveDialog1.Execute then
           begin
                 skoroszyt_out.WriteToFile(SaveDialog1.Filename);
           end;

           skoroszyt_out.Free;

     end;
end;

end.

