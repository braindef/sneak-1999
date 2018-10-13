//---------------------------------------------------------------------------
#include <vcl\condefs.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

#pragma hdrstop
//---------------------------------------------------------------------------
int main(int argc, char **argv)
{
 char i1,i2,i3;
 char z1,z2,z3;
 int count;
 bool numberFound;
 bool none;
 int again;

 do {
  clrscr();
  numberFound=false;
  do {
    randomize();
    z1='0'+random(10);
    z2='0'+random(10);
    z3='0'+random(10);
  } while ((z1==z2) || (z2==z3) || (z1==z3));
  textcolor(LIGHTGREEN);
  cprintf("Erraten Sie eine dreistellige Zahl in neun Versuchen.\n\r");
  cprintf("Eine richtige Ziffer in Ihrer Eingabe ergibt ein 'GUT', und \n\r");
  cprintf("wenn sie sogar an der richtigen Stelle steht ein 'ASS'.\n\r");
  cprintf("Jede Ziffer kommt hoechstens einmal vor.");
  count=1;
  while ((count < 10) && !numberFound) {
    gotoxy(1,16);
    textcolor(WHITE);
    cprintf("Zahl > ");
    textcolor(LIGHTGREEN);
    cscanf("%c%c%c",&i1,&i2,&i3);
    gotoxy(1,16);
    cprintf("                   ");
    textcolor(CYAN);
    gotoxy(1,5+count);
    cprintf("%d) %c%c%c : ",count,i1,i2,i3);
    textcolor(YELLOW);
    none=true;
    if (i1 == z1) {
      cprintf("ASS ");
      none=false;
    }
    if (i2 == z2) {
      cprintf("ASS ");
      none=false;
    }
    if (i3 == z3) {
      cprintf("ASS ");
      none=false;
    }
    if ((i1 == z2) || (i1 == z3)) {
      cprintf("GUT ");
      none=false;
    }
    if ((i2 == z1) || (i2 == z3)) {
      cprintf("GUT ");
      none=false;
    }
    if ((i3 == z1) || (i3 == z2)) {
      cprintf("GUT ");
      none=false;
    }
    if (none) {
      cprintf("KEINE");
    }
    if ((i1 == z1) && (i2 == z2) && (i3 == z3)) {
      numberFound=true;
    }
    count++;
  }
  textcolor(LIGHTRED);
  gotoxy(1,16);
  if (numberFound) {
    cprintf("Bravo! Sie haben die Zahl erraten!");
  } else {
    cprintf("Sorry! Die richtige Nummer waere %c%c%c gewesen",z1,z2,z3);
  }
  textcolor(RED);
  gotoxy(1,18);
  cprintf("Nochmals (j/n)?\n\r");
  while (kbhit()==0);
  again=getch();
 } while (again=='j');
 return 0;
}
//---------------------------------------------------------------------------

