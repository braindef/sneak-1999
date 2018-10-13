{

needed:

 - way to calculate weekday

}

{
        Program Name:   CPA DOS
        Version:        0.3.4
        Coded by:       Cockroach
        Bugfixed by:    Tekka
        Work started:   January 14, 1998
        Last touched:   February 27, 1999
}
uses crt,dos;


const MaxQuestions=14;

      weekday: Array[1..7] of string[9]=('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
      month: Array[1..12] of String[9]=('January','February','March','April','May','June','July','August',
                                        'September','October','November','December');
      Question: Array[1..MaxQuestions] of String[100]=
      ('Party name [leave blank to abort]',
      'Music style',
      'Weekday [*] [1-7, monday=1, saturday=6]',
      'Month [*] [1-12, january=1, august=8]',
      'Day [*]',
      'Year',
      'Time',
      'Location [*]',
      'DJs',
      'Organized by',
      'Web Site',
      'Age you need to have',
      'Ticket price',
      'Get tickets at');

var
  answer: array [1..14] of string[100];
  Exitrequest: Boolean;
  servicesh: array [1..10] of string[3];
  servicelo: array [1..10] of string;
  orgsh, orglo: array [1..40] of string;
  option: array [1..4] of string;

  y, m, d, wd: word;
  numservices, numclubs, numorgs, numquestions: integer;
  version, lamemonth, temp, temp2, tempurl, endmsg: string;
  sourcefile: text;
  counter, tempint, trashint: integer;
  found, org, lastwasinfo: boolean;
  ch: char;

procedure definewindow;
  begin
    version:='0.3.4';
    clrscr;
    textbackground(9);
    textcolor(15);
    gotoxy(1,24);
    write(chr(200));
    gotoxy(1,1);
    write(chr(201));
    gotoxy(80,1);
    write(chr(187));
    gotoxy(80,24);
    write(chr(188));
    for tempint:=2 to 79 do begin
      gotoxy(tempint,1);
      write(chr(205));
      gotoxy(tempint,24);
      write(chr(205));
    end;
    gotoxy(1,2);
    write('∫ CPA DOS v',version,'                                    (p) 1998/1999 by cockroach ∫');
    gotoxy(1,3);
    write(chr(199));
    gotoxy(80,3);
    write(chr(182));
    for tempint:=2 to 79 do begin
      gotoxy(tempint,3);
      write(chr(196));
    end;
    gotoxy(1,4);
    write('∫ Questions with [*] need to be answered, otherwise the output file won''t work ∫');
    for tempint:=5 to 23 do begin
      gotoxy(1,tempint);
      write(chr(186));
      clreol;
      gotoxy(80,tempint);
      write(chr(186));
    end;
    window(3,6,78,23);
  end;

procedure endprogram;
  begin
    textbackground(0);
    textcolor(7);
    window(1,1,80,25);
    clrscr;
    writeln('thank you for using CPA DOS v',version);
    if endmsg<>'' then begin
     writeln;
     writeln;
     write('exit message: ');
     textcolor(red);
     writeln(endmsg);
     textcolor(7);
     end;
    halt;
  end;

procedure lite;
  begin
    textcolor(15);
    if counter=0 then counter:=4;
    if counter=5 then counter:=1;
    gotoxy(counter*15-14,1);
    write(chr(16),' ',option[counter],' ',chr(17));
  end;

procedure unlite;
  begin
    textcolor(0);
    gotoxy(counter*15-14,1);
    write('  ',option[counter],'  ');
  end;

procedure info;
  begin
    lastwasinfo:=true;
    window(20,10,59,21);
     textbackground(9);
     clrscr;
     textbackground(7);
     writeln('…Õ[ about CPA DOS ]ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª');
     writeln('∫                                   ∫');
     writeln('∫              CPA DOS              ∫');
     writeln('∫                                   ∫');
     writeln('∫           Version ',version,'           ∫');
     writeln('∫                                   ∫');
     writeln('∫  contact: cockroach@mindless.com  ∫');
     writeln('∫                                   ∫');
     writeln('∫                                   ∫');
     writeln('∫                                   ∫');
     writeln('»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº');
     textcolor(black);
     textbackground(9);
     gotoxy(38,1);
     write('   ');
     for tempint:=2 to 11 do begin
       gotoxy(38,tempint);
       write('€€ ');
     end;
     gotoxy(1,wherey+1);
     write('  €€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€');
     gotoxy(17,wherey-3);
     textbackground(green);
     textcolor(white);
     write(chr(16),' OK ',chr(17));
     textbackground(7);
     textcolor(black);
     write('‹');
     gotoxy(18,wherey+1);
     write('ﬂﬂﬂﬂﬂﬂ');
     gotoxy(23,wherey-1);
     readkey;
     textbackground(9);
     clrscr;
    window(3,6,78,23);
  end;

procedure whatwasselected;
  begin
   if counter=1 then begin
     assign(sourcefile,'add.tdb');
     {$I-}
     append(sourcefile);
     {$I+}
     if IOResult<>0 then begin
      endmsg:='Error at ADD.TDB';
      endprogram;
     end;
    end;
   if counter=2 then begin
     assign(sourcefile,'add.tdb');
     rewrite(sourcefile);
    end;
   if counter=3 then info;
   if counter=4 then endprogram;
 end;

procedure lightbar;
 begin
   counter:=1;
   option[1]:=' Append ';
   option[2]:='New File';
   option[3]:='  Info  ';
   option[4]:='  Quit  ';
   textcolor(0);
   textbackground(7);
   for counter:=1 to 4 do begin
     write('  ',option[counter],'  ');
     gotoxy(wherex+3,wherey);
   end;
   textcolor(black);
   textbackground(9);
   for counter:=1 to 4 do begin
     gotoxy(counter*13+(counter-1)*2,wherey);
     write('‹');
   end;
   writeln;
   for counter:=1 to 4 do begin
     write(' ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ');
     gotoxy(wherex+2,wherey);
   end;
   if lastwasinfo then counter:=3 else counter:=1;
   lastwasinfo:=false;
   textbackground(7);
   lite;
   repeat
    ch:=readkey;
    if ch=#27 then endprogram;
    if ch=#13 then exitrequest:=true;
    if ch=#0 then begin
     ch:=readkey;
     if ch='K' then begin {left}
       unlite;
       dec(counter);
       lite;
      end;
     if ch='M' then begin {right}
       unlite;
       inc(counter);
       lite;
      end;
    end;
   until exitrequest;
   exitrequest:=false;
  end;

procedure managelightbar;
  begin
    repeat
      lightbar;
      whatwasselected;
    until counter<>3;
  end;

procedure setvars;
  begin
    for tempint:=1 to MaxQuestions do answer[tempint]:='';
    org:=false;
    lastwasinfo:=false;
    tempurl:='';
    temp:='';
  end;

procedure initvars;
  begin
    getdate(y,m,d,wd);
    {read cpa.ini}
    assign(sourcefile,'cpa.ini');
    {$I-}
    reset(sourcefile);
    {$I+}
    if ioResult<>0 then
    Begin
      endmsg:='Error at CPA.INI';
      endprogram;
    End;
    while not eof(sourcefile) do begin
      readln(sourcefile,temp);
      if pos('serviceshortcut',temp)=1 then begin
        inc(numservices);
        delete(temp,1,16);
        servicesh[numservices]:=temp;
      end;
      if pos('servicelong',temp)=1 then begin
        delete(temp,1,12);
        servicelo[numservices]:=temp;
      end;
      if pos('orgshort',temp)=1 then begin
        inc(numorgs);
        delete(temp,1,9);
        orgsh[numorgs]:=temp;
      end;
      if pos('orglong',temp)=1 then begin
        delete(temp,1,8);
        orglo[numorgs]:=temp;
      end;
    end;
    close(sourcefile);
  {end of cpa.ini}
end;

function two(S: String): String;
  begin
    if length(S)=1 then S:='0'+S;
    two:=S;
  end;

function IntToStr(I: Longint): String;
var S: string[11];
  begin
    Str(I, S);
    IntToStr := S;
  end;

procedure ask(questionnumber: integer);
var yaint: integer;
  begin
    TextColor(15);
    write(question[questionnumber]);
    if (questionnumber=11) and (tempurl<>'') then write(' [',tempurl,', -:none]');
    if questionnumber=14 then begin
      write(' [');
      if numservices>1 then begin
        for yaint:=1 to numservices-1 do write(servicesh[yaint],'/');
      end;
      write(servicesh[numservices],']');
    end;
    write(' ? ');
    TextColor(Lightgray);
    readln(answer[questionnumber]);
    if answer[1]='' then Exitrequest:=true;
  end;

procedure translate;
  begin
    temp:=answer[counter];
       case counter of
          1:  begin
                for tempint:=1 to length(temp) do begin
                 temp[tempint]:=upcase(temp[tempint]);
                end;
              end;
          {2=style}
          3:  begin {weekday}
                while temp='' do begin
                  ask(3);
                  temp:=answer[3];
                end;
                val(temp,tempint,trashint);
                temp:=weekday[tempint];
              end;
          4:  begin {month}
                while temp='' do begin
                  ask(4);
                  temp:=answer[4];
                end;
                lamemonth:=temp;
                val(temp,tempint,trashint);
                temp:=month[tempint];
              end;
          5:  begin {date}
                while temp='' do begin
                  ask(5);
                  temp:=answer[5];
                end;
              end;
          6:  if temp='' then str(y,temp); {year}
          {7=time}
          8:  begin
                found:=false;
{               while pos(',',temp)=0 do begin}
                repeat
                  assign(sourcefile,'cpa.ini');
                  reset(sourcefile);
                  while not eof(sourcefile) do begin
                    readln(sourcefile,temp2);
{                   if (pos('clubname',temp2)=1) and (pos(temp,temp2)=10) then begin}
                    if temp2='clubname='+temp then begin
                      found:=true;
                      readln(sourcefile,temp2);
                      delete(temp2,1,12);
                      temp:=temp+', '+temp2;
                      readln(sourcefile,temp2);
                      if pos('cluburl',temp2)=1 then begin
                        delete(temp2,1,8);
                        tempurl:=temp2;
                      end;
                    end;
                  end;
                  close(sourcefile);
                  if pos(',',temp)=0 then begin
                    ask(8);
                    temp:=answer[8];
                  end;
                until pos(',',temp)<>0
              end;
          {9=djs}
          10: if temp<>'' then repeat {organizer}
                found:=false;
                for tempint:=1 to numorgs do if temp=orgsh[tempint] then begin
                  temp:=orglo[tempint];
                  found:=true;
                end;
                if pos('/',temp)=1 then begin
                  delete(temp,1,1);
                  found:=true;
                end;
                if not found then begin
                  ask(10);
                  temp:=answer[10];
                end;
                until found;
          11: begin
                if temp='' then temp:=tempurl;
                if temp='-' then temp:='';
              end;
          {12=age, 13=price}
          14: for tempint:=1 to numservices do if temp=servicesh[tempint] then temp:=servicelo[tempint];
          end;
      answer[counter]:=temp;
    end;

procedure save;
  begin
    assign(sourcefile,'add.tdb');
    append(sourcefile);
    write(sourcefile,answer[6],two(lamemonth),two(answer[5]),'|');
    for tempint:=1 to maxquestions do write(sourcefile,answer[tempint],'|');
    writeln(sourcefile);
    close(sourcefile);
  end;

procedure main;

begin
  Exitrequest:=False;
  repeat
    textbackground(9);
    clrscr;
    setvars;
    for counter:=1 to maxquestions do begin
      ask(counter);
      if exitrequest then endprogram;
      translate;
    end;
    save;
  until Exitrequest;
  endprogram;
end;

begin
  definewindow;
  initvars;
  managelightbar;
  main;
end.

