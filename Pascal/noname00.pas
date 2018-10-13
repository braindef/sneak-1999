
program Nibbles;


uses WinCrt,WinProcs,WinTypes;


(****************** Typen und Objektdefinitionen ****************)

type
        pos = record                                               (*Benutzerdefinierter Datentyp für Positionen*)
            x, y : byte;
        end;

        zustand = (lebend, fressend, tod);                         (*Enumerierung für eindeutigen Zustand*)

type
   Schlange = object

      constructor Inizialisieren;                                  (*Allgemeiner Konstruktor*)
      destructor Loeschen;                                         (*Allgemeiner Destruktor*)
      procedure bewegen(richtung : integer; var KopfX, KopfY, SchwanzX, SchwanzY : byte);
                                                                   (*Methode für Steuerung der Schlange*)
      private                                                      (*Private Objektdaten*)
         aktZustand : Zustand;
         neuePosition : pos;                                       (*Temporäre Position*)
         Aussehen : array [1..400] of pos;                         (*1.dimension: länge; 2.dimension: x/y position*)
         laenge   : integer;                                       (*länge der Schlange : anfangszustand=1*)
   end;
(****************** Typen und Objektdefinitionen ****************)


(********************** Variabeldefinitionen ********************)

var   Spieler1           : Schlange;
      Spieler2           : Schlange;
      Spielfeld          : Array [1..20,1..20] of byte;
      TasteSpieler1      : byte;                                   (*Für Tastaturabfrage Spieler 1*)
      TasteSpieler2      : byte;                                   (*Für Tastaturabfrage Spieler 2*)
      LaufVarX           : byte;                                   (*Laufvariabel für x-Koordinaten*)
      LaufVarY           : byte;                                   (*Laufvariabel für y-Koordinaten*)
      KopfX, KopfY       : byte;
      SchwanzX, SchwanzY : byte;
(********************** Variabeldefinitionen ********************)


(******************** Funktionen und Prozeduren *****************)

constructor Schlange.Inizialisieren;

var init : integer;                                                (*Laufvariable*)

begin
   for init := 1 to 400 do                                         (*Array Schlange.Aussehen rücksetzen*)
      begin
         Aussehen[init].x := 255;
         Aussehen[init].y := 255;
      end;
   aktZustand := lebend;                                    (*Schlange lebendig machen*)
   laenge := 2;
end;

procedure Schlange.bewegen(richtung : integer; var KopfX, KopfY, SchwanzX, SchwanzY : byte);

var i  : integer;

begin
   case richtung of
      72: neuePosition.y := Aussehen[1].y - 1;
      80: neuePosition.y := Aussehen[1].y + 1;
      75: neuePosition.x := Aussehen[1].x - 1;
      77: neuePosition.x := Aussehen[1].x + 1;
   end;
   if Spielfeld[neuePosition.x, neuePosition.y] <> 0 then
   begin
      if Spielfeld[neuePosition.x,neuePosition.y] = 1 then aktZustand := tod
      else
         begin
            laenge:=laenge+1;
            aktZustand:=fressend;
         end;
   end;
   i:=laenge;
   while i > 0 do
      begin
         aussehen[i+1]:=aussehen[i];
         i := i-1;
      end;
   aussehen[1]:=neuePosition;
   KopfX := Aussehen[1].x;
   KopfY := Aussehen[1].y;
   SchwanzX := Aussehen[Laenge].x;
   SchwanzY := Aussehen[Laenge].y;
end;



destructor Schlange.Loeschen;

begin

end;

var a : integer;

begin
     spieler1.inizialisieren;
     repeat
     begin
          WriteLn('Eingabe ');
          Read(a);
          Spieler1.Bewegen(a, KopfX, KopfY, SchwanzX, SchwanzY);
          Write(KopfX,KopfY,SchwanzX,SchwanzY);
     end
     until a=999
end.