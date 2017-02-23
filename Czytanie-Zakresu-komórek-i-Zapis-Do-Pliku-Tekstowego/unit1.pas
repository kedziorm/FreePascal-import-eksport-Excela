unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, fpstypes, fpSpreadsheet, strutils;

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
    procedure btnCzytajClick(Sender: TObject);
    procedure btnZamknijClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
 Type Tablica_dynamiczna = array of array of Real;
 Type
   tablicaZInformacjami = record
     tablica: Tablica_dynamiczna;
     statystyki: string;
   end;
var
  Form1: TForm1;
  Zakres, pierwsza, druga: String;
  mojSkoroszyt: TsWorkbook;
  mojArkusz: TsWorksheet;
  mojaTablica : tablicaZInformacjami;

implementation

function CzytajZakresKomorek
          (Arkusz: TsWorksheet; komorka_s : string; komorka_k: string = '')
                        : tablicaZInformacjami;
 // Przykład użycia:
 // CzytajZakresKomorek(Arkusz,'B2', 'F3')
 // zwróci tablicę liczb z zakresu B2:F3 wraz ze statystykami

  var
    ostatniaKolumna, ostatniWiersz, wiersz, kolumna : integer;
    komorka : PCell;
    suma, liczbaKomorek, srednia : Real;
    tablica : Tablica_dynamiczna;
  begin
    if Arkusz.FindCell(komorka_s) = nil then
       begin
         ShowMessage('Komórka ' + komorka_s +
                              ' nie istnieje w arkuszu: ' + Arkusz.Name);
         exit;
       end;

    komorka := Arkusz.FindCell(komorka_s);

    if ( komorka_k = '' ) or ( Arkusz.FindCell(komorka_k) = nil ) then
       begin
         ostatniaKolumna := Arkusz.GetLastColIndex();
         ostatniWiersz := Arkusz.GetLastRowIndex();
       end
    else
      begin
        ostatniaKolumna := Arkusz.FindCell(komorka_k)^.Col;
        ostatniWiersz := Arkusz.FindCell(komorka_k)^.Row;
      end;

    suma:=0; srednia:=0; liczbaKomorek:=0;
    SetLength(tablica,ostatniWiersz - komorka^.Row + 1,ostatniaKolumna - komorka^.Col + 1);
    for wiersz := komorka^.Row to ostatniWiersz do
        begin
        for kolumna := komorka^.Col to ostatniaKolumna do
            begin
              tablica[wiersz - komorka^.Row, kolumna - komorka^.Col] :=
                          Arkusz.ReadAsNumber(wiersz,kolumna);
              suma:= suma + Arkusz.ReadAsNumber(wiersz,kolumna);
              liczbaKomorek:= liczbaKomorek + 1;
            end;
        end;
    srednia:=suma/liczbaKomorek;

    Result.tablica:= tablica;
    Result.statystyki:='Suma: ' + FloatToStr(suma)
    + LineEnding + 'Średnia: ' + FloatToStr(srednia)
    + LineEnding + 'Liczba komórek: ' +FloatToStr(liczbaKomorek);
  end;

Procedure ZapiszTabliceDoPlikuTekstowego
          (tablica : Tablica_dynamiczna; sciezkaDoPliku : String);
const
  // Tabulator jako separator liczb:
  separator = Char(9);
var
	wiersz, kolumna, wiersz_min, wiersz_maks, kol_min, kol_maks : integer;
	linia : String;
	listaCiagowZnakow: TStringList;
begin
  If not FileExists(sciezkaDoPliku) Then
    begin
      listaCiagowZnakow := TStringList.Create;
      wiersz_min:= Low(tablica); wiersz_maks:= high(tablica);
      kol_min:= Low(tablica[1]); kol_maks:= high(tablica[1]);
      for wiersz := wiersz_min to wiersz_maks do
      begin
        linia := '';
        for kolumna := kol_min to kol_maks do
        begin
          linia := linia + FloatToStr(tablica[wiersz, kolumna]) + separator;
        end;
        // Ostatni separator jest nadmiarowy
        Delete (linia,Length(linia),1);
        listaCiagowZnakow.Add(linia);
      end;
      listaCiagowZnakow.SaveToFile(sciezkaDoPliku);
      listaCiagowZnakow.Free;
      ShowMessage('Tablica została zapisana do pliku: '
                           + Char(39) + sciezkaDoPliku + char(39));
    end
  else
      begin
        ShowMessage('Następujący plik już nie istnieje: '
        + Char(39) + sciezkaDoPliku + Char(39)
          + ' Nie będę go nadpisywać');
      end;
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnZamknijClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btnCzytajClick(Sender: TObject);
begin
  Zakres:=txtZakres.Text;
  pierwsza:=Trim(ExtractWord(1,Zakres,[':']));
  druga:=Trim(ExtractWord(2,Zakres,[':']));


  mojSkoroszyt := TsWorkbook.Create;
  if OpenDialog1.Execute then
    begin
       mojSkoroszyt.ReadFromFile(OpenDialog1.FileName);
       mojArkusz := mojSkoroszyt.GetWorksheetByIndex(0);
       mojaTablica:= CzytajZakresKomorek(mojArkusz,pierwsza,druga);
       lblStatystyki.Caption:= mojaTablica.statystyki;

       if SaveDialog1.Execute then
         ZapiszTabliceDoPlikuTekstowego(
            mojaTablica.tablica, SaveDialog1.FileName);

    end;


end;

end.

