
program Nibbles;


uses WinCrt,WinProcs,WinTypes;


(****************** Typen und Objektdefinitionen ****************)

type
        pos = record                                               (*Benutzerdefinierter Datentyp für Positionen*)
            x, y : byte;
        end;

        zustand = (lebend, tod);                                   (*Enumerierung für eindeutigen Zustand*)

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
      fressen            : pos;
      neuesFressen       : boolean;
(********************** Variabeldefinitionen ********************)


(******************** Funktionen und Prozeduren *****************)

constructor Schlange.Inizialisieren;

var init : integer;                                                (*Laufvariable*)

begin
   for init := 1 to 400 do                                         (*Array Schlange.Aussehen rücksetzen*)
      begin
         Aussehen[init].x := 10;
         Aussehen[init].y := 10;
      end;
   aktZustand := lebend;                                    (*Schlange lebendig machen*)
   laenge := 2;
end;

procedure Schlange.bewegen(richtung : integer; var KopfX, KopfY, SchwanzX, SchwanzY : byte);

var i  : integer;

begin
   case richtung of
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
   KopfX := Aussehen[1].x;
   KopfY := Aussehen[1].y;
   SchwanzX := Aussehen[Laenge].x;
   SchwanzY := Aussehen[Laenge].y;
end;



destructor Schlange.Loeschen;

begin

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

   for LaufVarY := 1 to 20 do                                       (*Spielfeld inizialisieren*)
      for LaufVarX := 1 to 20 do
         begin
            Spielfeld[LaufVarX,LaufVarY] := 0;
         end;
   fressen.x:=random(20)+1;
   fressen.y:=random(20)+1;
   Spielfeld[fressen.x,fressen.y]:=2;
   gotoxy(fressen.x,fressen.y);
   Writeln('F');
   TasteSpieler1 := 52;
   Spielfeld[4,1] := 2;
   while (Spieler1.aktZustand <> tod) do
   begin
      if keypressed = true then
         begin
            TasteSpieler1 := ord(ReadKey);
         end;
   Spieler1.bewegen(TasteSpieler1, KopfX, KopfY, SchwanzX, SchwanzY);
   if neuesFressen then
   begin
        fressen.x:=random(20)+1;
        fressen.y:=random(20)+1;
        Spielfeld[fressen.x,fressen.y]:=2;
        gotoxy(fressen.x,fressen.y);
        Writeln('F');
        neuesFressen:=False;
   end;
   Spielfeld[KopfX,KopfY]:=1;
   gotoxy(KopfX,KopfY);
   Write ('O');
   gotoxy(20,20);
   write(KopfX:3,KopfY:3,SchwanzX:3,SchwanzY:3);
   Spielfeld[SchwanzX,SchwanzY]:=0;
   gotoxy(SchwanzX,SchwanzY);
   write(' ');
   Delay(100);
   end;
   Spieler1.Loeschen;
   Writeln ('Ende');
end.





(************************** Hauptprogramm ***********************)