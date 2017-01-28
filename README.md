# FreePascal-import-eksport-Excela
Próba napisania programu w zintegrowanym środowisku programistycznym Lazarus, który importuje i eksportuje skoroszyty programu Excel.

### Kroki wykonywane przez program
1. Wczytanie danych ze wskazanego skoroszytu programu Excel
2. Obliczenie sumy i średniej (jeśli się uda także innych statystyk opisowych) - osobno dla **każdego** arkusza wewnątrz skoroszytu.
3. Zapytanie użytkowanika do jakiego pliku program ma zapisać wynik
4. Utworzenie nowego arkusza z wynikiem.

### Instalacja FPSpreadsheet

Zgodnie z informacją umieszczoną na stronie http://wiki.freepascal.org/FPSpreadsheet#Installation
biblioteka FPSpreadsheet powinna umożliwić swobodne odczytywanie i zapisywanie skoroszytów programu Excel.
Niestety nie można jej zainstalować przez opcję w menu "Package --> Install/Uninstall Packages"

W związku z tym wykonano następujące kroki:
1. Pobrano archiwum z biblioteką https://sourceforge.net/projects/lazarus-ccr/files/FPSpreadsheet/ i rozpakowano je
2. Package ---> Open Package File
3. Wykonano kompilację i dodano plik do projektu (więcej szczegółów można znaleźć na załączonych zrzutach ekranu)
