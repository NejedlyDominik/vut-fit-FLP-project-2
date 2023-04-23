# FLP -- logický projekt -- 2022/2023
## Hamiltonovská kružnice

Autor: Dominik Nejedlý (xnejed09)

### Popis chování programu

Program vyhledávající všechny unikátní Hamiltonovké kružnice v grafu
implementovaný v jazyku Prolog. Vstupem (načítaným ze standardního vstupu) je
reprezentace grafu pomocí hran tvaru `<V1> <V2>`, kde vrcholy jsou velká
písmena anglické abecedy (A-Z). Příklad:

    A B
    A C
    A D
    B C
    B D
    C B

Výstup je poté tvaru `<V1>-<V2> <V2>-<V3> ... <Vn-1>-<Vn>`, kde každá
dvojice vrcholů reprezentuje hranudané kružnice, a je vytištěn na standardní výstup.
Příklad:

    A-B A-C B-D C-D
    A-B A-D B-C C-D
    A-C A-D B-C B-D

### Překlad

Pomocí nástroje `Makefile` příkazem `make` nebo příkazem

    swipl -q -g main -o flp22-log -c flp22-log.pl

### Spuštění

Program lze po přeložení spustit příkazem

    ./flp22-log < /cesta_ke_vstupu/vstupní_oubor > /cesta_k_výstupu/výstupní_soubor

### Metoda řešení

Pro hledání cyklů je využito prohledávání grafu na základě vstupních hran s využitím
backtrackingu. Nejprve je zvolen počáteční vrchol, ve kterého prohledávání vždy začíná.
Každá výsledná kružnice má usporádáné hrany i vrcholy v nich, aby případné duplicitní
kružnice měly vždy stejné hrany na stejných pozicích. To umožňuje jejich snadnou detekci
a jednoduché odstranění (pomocí řazení - predikát `setof` v implementaci).

### Poznámky k implementaci

Všechny části zadání byly implementovanány. Program dále umožňuje robustnější načítání vstupů.
Pokud jsou nějaké první dva nebílé znaky na řádku velkými písmeny anglické abecedy, jsou považovány
za vstupní hranu. Tohle řešení umožňuje načíst vstupní hrany i z řádků s nadbytečnými bílými znaky,
s chybějícím bílým znakem mezi vrcholy hrany nebo s libovolnými symboly za vrcholy hrany. Ostatní
řádky vstupu (tedy řádky, na nichž se vstupní hrany nenachází) jsou ingnorovány/přeskakovány. Program
je také přizpůsoben k práci s různými typy odřádkování (`CR`, `LF`, `CRLF`).

Pro úplný graf o 10 a více uzlech dochází na serveru merlin k přetečení globálního zásobníku
(`ERROR: Out of global stack`).

### Spuštění s přiloženými testovacími vstupy

Adresář `test/` obsahuje několik testovacích vstupů (soubory tvaru `*.in`). Program s nimi lze
spouštět způsobem popsaným výše. Tedy například pro testovací vstup v souboru `test01.in` příkazem

    ./flp22-log < ./test/test01.in

Pro každý testovací vstup byl měřen čas jeho běhu na serveru merlin. Výsledky tohoto měření jsou uvedeny
v následující tabulce tabulka.

*Poznámka: při každém měření byl výstup přesměrován do souboru, výsledný čas tedy nezahrnuje dobu tištění získaných kružnic do terminálu.*

| testovací vstup | čas (s) |
| :-------------: | :-----: |
| `test01.in`     | 0.021   |
| `test02.in`     | 0.602   |
| `test03.in`     | 0.023   |
| `test04.in`     | 0.024   |
| `test05.in`     | 0.022   |
