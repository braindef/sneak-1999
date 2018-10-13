//---------------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dos.h>
#include <conio.h>
#pragma hdrstop
//---------------------------------------------------------------------------
void DruckeString (char* string, int anzahl) {
  int i;
  for (i=0;i<anzahl;i++) {
    printf("%s",string);
  }
}
//---------------------------------------------------------------------------
void DruckeVerzeichnis (char *pfad, int verzeichnisTiefe) {
  int    i;
  ffblk* dateiInfo;
  char   neuerPfad[256];
  char   dateiName[256];
  dateiInfo=new ffblk;
  strcpy(dateiName,pfad);
  strcat(dateiName,"\\*.*");
  if (findfirst(dateiName,dateiInfo,FA_NORMAL|FA_DIREC)==0) {
    do {
      if ((dateiInfo->ff_attrib & FA_DIREC) !=0) {
        if (strcmp(dateiInfo->ff_name,".") !=0 && strcmp(dateiInfo->ff_name,"..") !=0) {
          DruckeString("  ",verzeichnisTiefe);
          printf("<%s>\n",dateiInfo->ff_name);
          strcpy(neuerPfad,pfad);
          strcat(neuerPfad,"\\");
          strcat(neuerPfad,dateiInfo->ff_name);
          DruckeVerzeichnis(neuerPfad,verzeichnisTiefe+1);
        }
      } else {
        DruckeString("  ",verzeichnisTiefe);
        printf("%s (%d Bytes)\n",dateiInfo->ff_name,dateiInfo->ff_fsize);
      }
    } while (findnext(dateiInfo)==0);
  } else {
    printf("Verzeichnis '%s' nicht gefunden.\n",pfad);
  }
  delete dateiInfo;
}
//---------------------------------------------------------------------------
int main(int argc, char **argv)
{
  if (argc !=2) {
    printf("Usage: listdir <path>\n");
  } else {
    DruckeVerzeichnis(argv[1],0);
  }
}
//---------------------------------------------------------------------------

