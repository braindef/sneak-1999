program Nibbles;

uses Crt,Graph;

(****************** Typen und Objektdefinitionen ****************)

const Feldbreite = 40;                                             (* definition der Spielfeldbreite *)
      Feldhoehe  = 20;                                             (* definition der Spielfeldhoehe *)

type
        zeile = record                                             (*Benutzerdefinierter Datentyp f�r Rangliste*)
            Name   : String[40];
            Punkte : Integer;
        end;

type
        pos = record                                               (*Benutzerdefinierter Datentyp f�r Positionen*)
            x, y : byte;                                           (*Position beinhaltet x- und y-Komponente*)
        end;

        inhalt     = (leer, hinderniss, futter);                   (*Enumerierung f�r Inhalt des Schlangenarrays*)

        richtungen = (links, rechts, auf, ab);                     (*Enumerierung f�r Richtungen*)

        zustand    = (lebend, tod);                                (*Enumerierung f�r eindeutigen Zustand*)

type
   Schlange = object

      public
         constructor Inizialisieren(x,y : byte);                   (*Allgemeiner Konstruktor*)
         destructor Loeschen;                                      (*Allgemeiner Destruktor*)
         function getZustand:zustand;                              (*Methode f�r die Zustandsabfrage*)
         procedure bewegen(richtung : richtungen; var Kopf, Schwanz : pos);
                                                                   (*Methode f�r Steuerung der Schlange*)

      private                                                      (*Private Objektdaten*)
         aktZustand : Zustand;                                     (*Variabel f�r den Zustand der Schlange (lebend/tod)*)
         neuePosition : pos;                                       (*Tempor�re Position*)
         Aussehen : array [1..feldbreite*feldhoehe] of pos;        (*1.dimension: l�nge; 2.dimension: x/y position*)
         laenge   : integer;                                       (*l�nge der Schlange : anfangszustand=1*)
   end;
(****************** Typen und Objektdefinitionen ****************)


(********************** Variabeldefinitionen ********************)


var      Spielfeld          : Array [1..Feldbreite,1..Feldhoehe] of inhalt;
         Spieler1           : Schlange;
         Spieler2           : Schlange;
         TasteSpieler       : byte;                                (*F�r Tastaturabfrage Spieler*)
         richtungSpieler1   : richtungen;                          (*�bergabevariabel f�r Richtung von Spieler 1*)
         richtungSpieler2   : richtungen;                          (*�bergabevariabel f�r Richtung von Spieler 2*)
         LaufVar            : pos;                                 (*Laufvariabel f�r x-Koordinaten*)
         Kopf1              : pos;                                 (*�bergabe Variabel f�r Position des Spieler1-Kopfes*)
         Schwanz1           : pos;                                 (*�bergabe Variabel f�r Position des Spieler1-Schwanzes*)
         Kopf2              : pos;                                 (*�bergabe Variabel f�r Position des Spieler2-Kopfes*)
         Schwanz2           : pos;                                 (*�bergabe Variabel f�r Position des Spieler2-Schwanzes*)
         fressen            : pos;                                 (*Variabel f�r Position des Fressen*)
         neuesFressen       : boolean;                             (*Zum entscheiden ob ein neues Fressen braucht*)
         mauer              : pos;
         Startpunkt1        : pos;
         Startpunkt2        : pos;
         anzSpieler         : char;

         Gd, Gm             : Integer;
         Color              : Word;


(********************** Variabeldefinitionen ********************)


(******************** Funktionen und Prozeduren *****************)

constructor Schlange.Inizialisieren(x,y : byte);

var init : integer;                                                (*Laufvariable*)

begin
   for init := 0 to feldbreite*feldhoehe do                        (*Array Schlange.Aussehen r�cksetzen*)
      begin
         Aussehen[init].x := x;
         Aussehen[init].y := y;
      end;
   aktZustand := lebend;
                                              (*Schlange lebendig machen*)
   laenge := 2;                                                    (*Anfangsl�ne definieren*)
end;

procedure Schlange.bewegen(richtung : richtungen; var Kopf, Schwanz : pos);
                                                                   (*Obiekt zur Steuerung der Schlange*)
var i  : integer;

begin
   case ord(richtung) of                                 (*Auswertung und Verarbeitung des �bergebenen Tasten-Codes*)
      0: neuePosition.x := Aussehen[1].x - 1;
      1: neuePosition.x := Aussehen[1].x + 1;
      2: neuePosition.y := Aussehen[1].y - 1;
      3: neuePosition.y := Aussehen[1].y + 1;
   end;
   if Spielfeld[neuePosition.x, neuePosition.y] <> leer then
   begin
      if Spielfeld[neuePosition.x,neuePosition.y] = hinderniss then aktZustand := tod
      else                                                         (*�brig bleibt fressen*)
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


function Schlange.getZustand:zustand;

begin
     getZustand:=aktZustand;
end;


destructor Schlange.Loeschen;

begin
(* Mit dieser Routine wird das Objekt wieder aus dem Speicher gel�scht*)
end;

procedure FressenGenerieren;

begin
     while (Spielfeld[fressen.x,fressen.y] <> leer) or NeuesFressen do
     begin
          fressen.x := random(Feldbreite);
          fressen.y := random(Feldhoehe);
          NeuesFressen := False;
     end;
     Spielfeld[Fressen.x,Fressen.y] := futter;
     GotoXY(Fressen.x,Fressen.y);
     Write('�');
end;

Procedure Spielfeldbauen;

var j : byte;

begin
     For j := 1 to Feldbreite do
     begin
          Spielfeld[j,1]:=hinderniss;
          Gotoxy(j,1);
          Write('@');
          Spielfeld[j,Feldhoehe]:=hinderniss;
          Gotoxy(j,Feldhoehe);
          Write('@');
     end;
For j := 1 to Feldhoehe do
     begin
          Spielfeld[1,j]:=hinderniss;
          Gotoxy(1,j);
          Write('@');
          Spielfeld[Feldbreite,j]:=hinderniss;
          Gotoxy(Feldbreite,j);
          Write('@');
     end;
end;

(*
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

 *)

Procedure EinSpieler;

begin
   clrscr;
   randomize;
   Spieler1.Inizialisieren(30, 5);
   for LaufVar.y := 1 to feldhoehe do                              (*Spielfeld inizialisieren*)
      for LaufVar.x := 1 to feldbreite do
      begin
         Spielfeld[LaufVar.x,LaufVar.y] := leer;
      end;
   Spielfeldbauen;
   NeuesFressen := True;
   FressenGenerieren;
   RichtungSpieler1 := ab;
   while (Spieler1.getZustand <> tod)  do
   begin
      if keypressed = true then
      begin
         TasteSpieler := ord(ReadKey);
         case TasteSpieler of
               52: if richtungSpieler1 <> rechts then richtungSpieler1 := links;
               54: if richtungSpieler1 <> links then richtungSpieler1 := rechts;
               56: if richtungSpieler1 <> ab then richtungSpieler1 := auf;
               50: if richtungSpieler1 <> auf then richtungSpieler1 := ab;
         end;
      end;
      if NeuesFressen then FressenGenerieren;
      Spieler1.bewegen(richtungSpieler1, Kopf1, Schwanz1);
      Spielfeld[Kopf1.x,Kopf1.y]:=hinderniss;
      GotoXY(Kopf1.x,Kopf1.y);
      Write ('O');
      Spielfeld[Schwanz1.x,Schwanz1.y]:=leer;
      GotoXY(Schwanz1.x,Schwanz1.y);
      write(' ');
      Delay(80);
   end;
   Spieler1.Loeschen;
   Writeln ('Ende');
end;

Procedure ZweiSpieler;

begin
   clrscr;
   randomize;
   Spieler1.Inizialisieren(30, 5);
   Spieler2.Inizialisieren(10, 5);
   for LaufVar.y := 1 to feldhoehe do                              (*Spielfeld inizialisieren*)
      for LaufVar.x := 1 to feldbreite do
      begin
         Spielfeld[LaufVar.x,LaufVar.y] := leer;
      end;
   Spielfeldbauen;
   NeuesFressen := True;
   FressenGenerieren;
   RichtungSpieler1 := ab;
   RichtungSpieler2 := ab;
   while ((Spieler1.getZustand <> tod) and (Spieler2.getZustand <> tod)) do
   begin
      if keypressed = true then
      begin
         TasteSpieler := ord(ReadKey);
         case TasteSpieler of
               52: if richtungSpieler1 <> rechts then richtungSpieler1 := links;
               54: if richtungSpieler1 <> links then richtungSpieler1 := rechts;
               56: if richtungSpieler1 <> ab then richtungSpieler1 := auf;
               50: if richtungSpieler1 <> auf then richtungSpieler1 := ab;
              115: if richtungSpieler2 <> rechts then richtungSpieler2 := links;                 (*s*)
              102: if richtungSpieler2 <> links then richtungSpieler2 := rechts;                (*f*)
              101: if richtungSpieler2 <> ab then richtungSpieler2 := auf;                   (*e*)
               99: if richtungSpieler2 <> auf then richtungSpieler2 := ab;                    (*c*)
         end;
      end;
      if NeuesFressen then FressenGenerieren;
      Spieler1.bewegen(richtungSpieler1, Kopf1, Schwanz1);
      Spieler2.bewegen(richtungSpieler2, Kopf2, Schwanz2);
      Spielfeld[Kopf1.x,Kopf1.y]:=hinderniss;
      GotoXY(Kopf1.x,Kopf1.y);
      Write ('O');
      Spielfeld[Schwanz1.x,Schwanz1.y]:=leer;
      GotoXY(Schwanz1.x,Schwanz1.y);
      write(' ');
      Spielfeld[Kopf2.x,Kopf2.y]:=hinderniss;
      GotoXY(Kopf2.x,Kopf2.y);
      Write ('O');
      Spielfeld[Schwanz2.x,Schwanz2.y]:=leer;
      GotoXY(Schwanz2.x,Schwanz2.y);
      write(' ');
      Delay(80);
   end;
   Spieler1.Loeschen;
   Spieler2.Loeschen;
   Writeln ('Ende');
end;

(******************** Funktionen und Prozeduren *****************)



(************************** Hauptprogramm ***********************)


begin
       Gd := Detect;
  InitGraph(Gd, Gm, '');
  if GraphResult <> grOk then
    Halt(1);
  Color := GetMaxColor;

     clrscr;
     Writeln('Willkommen bei Nibbles V0.4');
     Writeln('Bitte eine beliebige Taste dr�cken');
     anzSpieler:='0';
     while (anzSpieler <> 'e') and (anzSpieler <> 'E') do
     begin
          Delay(500);
          repeat until keypressed;
          Clrscr;
          Writeln ('1 f�r ein Spieler, 2 f�r zwei Spieler, e f�r Ende');
          anzSpieler:=Readkey;
          if anzSpieler = '1' then einSpieler
          else if anzSpieler = '2' then ZweiSpieler;
     end;
end.

(************************** Hauptprogramm ***********************)