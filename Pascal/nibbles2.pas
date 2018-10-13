program Nibbles;

uses WinCrt,WinProcs,WinTypes;

(****************** Typen und Objektdefinitionen ****************)

const Feldbreite = 20;                                             (* definition der Spielfeldbreite *)
      Feldhoehe  = 20;                                             (* definition der Spielfeldhoehe *)

type
        pos = record                                               (*Benutzerdefinierter Datentyp f�r Positionen*)
            x, y : byte;                                           (*Position beinhaltet x- und y-Komponente*)
        end;

        zustand = (lebend, tod);                                   (*Enumerierung f�r eindeutigen Zustand*)

type
   Schlange = object

      public
         constructor Inizialisieren;                               (*Allgemeiner Konstruktor*)
         destructor Loeschen;                                      (*Allgemeiner Destruktor*)
         procedure bewegen(richtung : integer; var Kopf, Schwanz : pos);
                                                                   (*Methode f�r Steuerung der Schlange*)
      private                                                      (*Private Objektdaten*)
         aktZustand : Zustand;                                     (*Variabel f�r den Zustand der Schlange (lebend/tod)*)
         neuePosition : pos;                                       (*Tempor�re Position*)
         Aussehen : array [1..feldbreite*feldhoehe] of pos;        (*1.dimension: l�nge; 2.dimension: x/y position*)
         laenge   : integer;                                       (*l�nge der Schlange : anfangszustand=1*)
   end;
(****************** Typen und Objektdefinitionen ****************)


(********************** Variabeldefinitionen ********************)


var      Spielfeld          : Array [1..Feldbreite,1..Feldhoehe] of byte;
         Spieler1           : Schlange;
         Spieler2           : Schlange;
         TasteSpieler1      : byte;                                (*F�r Tastaturabfrage Spieler 1*)
         TasteSpieler2      : byte;                                (*F�r Tastaturabfrage Spieler 2*)
         LaufVar            : pos;                                 (*Laufvariabel f�r x-Koordinaten*)
         Kopf               : pos;                                 (*�bergabe Variabel f�r Position des Kopfes*)
         Schwanz            : pos;                                 (*�bergabe Variabel f�r Position des Schwanzes*)
         fressen            : pos;                                 (*Variabel f�r Position des Fressen*)
         neuesFressen       : boolean;                             (*Zum entscheiden ob ein neues Fressen braucht*)
         mauer              : pos;

(********************** Variabeldefinitionen ********************)


(******************** Funktionen und Prozeduren *****************)

constructor Schlange.Inizialisieren;

var init : integer;                                                (*Laufvariable*)

begin
   for init := 1 to feldbreite*feldhoehe do                        (*Array Schlange.Aussehen r�cksetzen*)
      begin
         Aussehen[init].x := 10;
         Aussehen[init].y := 10;
      end;
   aktZustand := lebend;                                           (*Schlange lebendig machen*)
   laenge := 2;                                                    (*Anfangsl�ne definieren*)
end;

procedure Schlange.bewegen(richtung : integer; var Kopf, Schwanz : pos);
                                                                   (*Obiekt zur Steuerung der Schlange*)
var i  : integer;

begin
   case richtung of                                                (*Auswertung und Verarbeitung des �bergebenen Tasten-Codes*)
      56: neuePosition.y := Aussehen[1].y - 1;
      50: neuePosition.y := Aussehen[1].y + 1;
      52: neuePosition.x := Aussehen[1].x - 1;
      54: neuePosition.x := Aussehen[1].x + 1;
   end;
   if Spielfeld[neuePosition.x, neuePosition.y] <> 0 then
   begin
      if Spielfeld[neuePosition.x,neuePosition.y] = 1 then aktZustand := tod
      else
      begin
           laenge:=laenge+1;
           neuesFressen:=True;
      end;
   end;
   i:=laenge;
   while i > 0 do
      begin
         aussehen[i+1]:=aussehen[i];
         i := i-1;
      end;
   aussehen[1]:=neuePosition;
   Kopf.x := Aussehen[1].x;
   Kopf.y := Aussehen[1].y;
   Schwanz.x := Aussehen[Laenge].x;
   Schwanz.y := Aussehen[Laenge].y;
end;



destructor Schlange.Loeschen;

begin
(* Mit dieser Routine wird das Objekt wieder aus dem Speicher gel�scht*)
end;

procedure FressenGenerieren;

begin
     while (Spielfeld[fressen.x,fressen.y] <> 0) or NeuesFressen do
     begin
          fressen.x := random(Feldbreite)+1;
          fressen.y := random(Feldhoehe)+1;
          NeuesFressen := False;
     end;
     Spielfeld[Fressen.x,Fressen.y] := 2;
     GotoXY(Fressen.x,Fressen.y);
     Write('F');
end;


Procedure Delay(ms : LongInt);
  Var
    TickCount : LongInt;
    M         : TMsg;
  Begin
    TickCount := GetTickCount;
    While GetTickCount - TickCount < ms do
      If PeekMessage(M,0,0,0,pm_Remove) then
        Begin
          TranslateMessage(M); DispatchMessage(M);

        End;
End;

(******************** Funktionen und Prozeduren *****************)



(************************** Hauptprogramm ***********************)
begin
   randomize;
   Spieler1.Inizialisieren;
   for LaufVar.y := 1 to feldhoehe do                              (*Spielfeld inizialisieren*)
      for LaufVar.x := 1 to feldbreite do
      begin
         Spielfeld[LaufVar.x,LaufVar.y] := 0;
      end;
   NeuesFressen := True;
   FressenGenerieren;
   TasteSpieler1 := 52;
   while (Spieler1.aktZustand <> tod) do
   begin
      if keypressed = true then
      begin
         TasteSpieler1 := ord(ReadKey);
      end;
      Spieler1.bewegen(TasteSpieler1, Kopf, Schwanz);
      if NeuesFressen then FressenGenerieren;
      Spielfeld[Kopf.x,Kopf.y]:=1;
      GotoXY(Kopf.x,Kopf.y);
      Write ('O');
      GotoXY(30,25);
      write(Kopf.x:3,Kopf.y:3,Schwanz.x:3,Schwanz.y:3);
      Spielfeld[Schwanz.x,Schwanz.y]:=0;
      GotoXY(Schwanz.x,Schwanz.y);
      write(' ');
      Delay(100);
   end;
   Spieler1.Loeschen;
   Writeln ('Ende');
end.





(************************** Hauptprogramm ***********************)