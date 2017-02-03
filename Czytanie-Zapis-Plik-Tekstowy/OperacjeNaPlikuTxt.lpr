program OperacjeNaPlikuTxt;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, sysutils
  { you can add units after this };

const
  Nazwa_Pliku_Wyjsciowego = 'tablica.txt';
var
  strumien_plikowy: TFileStream;
  // Zdefiniowanie dwóch tablic do testowania
  Tablica : array [1..5] of Real = (1.4, 2.4, 3.5, 4.5, 6.0);
  Tablica_dwuwymiarowa: array [1..2,1..3] of Real =
    ((0.5, 2.4, 1.2), (3.4, 5.3, 6.5));

begin
  strumien_plikowy := TFileStream.Create(Nazwa_Pliku_Wyjsciowego, fmCreate);
  //strumien_plikowy.Write(FloatToStr(Tablica), Length(FloatToStr(Tablica)));
  strumien_plikowy.Write(Tablica, SizeOf(Tablica));
  strumien_plikowy.Free;
  WriteLn('Zapisano Plik pod Nazwą:' + Nazwa_Pliku_Wyjsciowego);
  ReadLn;
end.

