
{$G+,x+}
uses crt;

const factor=5;
type palette=array[0..767] of byte;
var bseg,bseg2: pointer; {pointer;}
    xarray:array[0..319] of word;
    yarray:array[0..399] of word;
    cosinus:array[0..255] of byte;
    sinus:array[0..255] of byte;
    pal:palette;
    x,y:byte;
    i:word;

procedure waitVRT; assembler;
(* waits until a vertictal retrace happens.. *)
asm
   mov dx,03dah
   @VRT:
    in al,dx
  test al,08h
    jz @VRT
   @nVRT:
    in al,dx
  test al,8
   jnz @nVRT
end;

procedure ScaleUp(source, dest: word); assembler;
{ This is where the stuff goes }
label l1,l2;
asm
	mov ax,source
   db 8eh,0e8h; (* mov gs,ax *)
  mov es,dest
{ xor di,di}
  mov di,30*320
(* mov dl,200 *)
  mov dl,170
  db 66h; xor cx,cx (* ecx *)
  mov cx,offset YArray
  add cx,30*4
    l1:
    mov dh,160
    mov si,offset XArray
      l2:
      db 3eh,67h,66h,8bh,19h; (* mov ebx,dword ptr ds:[ecx] *)
      db 3eh,66h,03h,1ch;     (* add ebx,dword ptr ds:[si] *)
      db 65h,8ah,07h;         (* mov al,byte ptr gs:[bx] *)
      db 66h; shr bx,16
      db 65h,8ah,27h;         (* mov ah,byte ptr gs:[bx] *)
      stosw
      add si,4
      dec dh
      jnz l2
    add cx,4
    dec dl
    jnz l1
end;

procedure fire(dest: word); assembler;
{ Standard blur }
label fl1,fl2;
asm
  mov es,dest
  mov di,30*320
  mov cx,320*140
    fl1:
    xor bx,bx
    mov bl,byte ptr es:[di]
    mov ax,bx
    mov bl,byte ptr es:[di-1]
    add ax,bx
    mov bl,byte ptr es:[di+1]
    add ax,bx
    mov bl,byte ptr es:[di+320]
    add ax,bx
    shr ax,2
    jz fl2
    dec al
    fl2:
    stosb
    dec cx
  jnz fl1
end;

procedure CopyDW(source, dest:word); assembler;
{ 32-bit copy }
asm
  push ds
  mov ds,source
  mov es,dest
  mov si,30*320
  mov di,si
  mov cx,140*80
  db 66h; rep movsw;
  pop ds
end;

procedure Dot(x,y,dest: word; color: byte); assembler;
{ No circle :-( }
asm
  mov es,dest
  mov ax,y
  mov bx,320
  mul bx
  mov di,ax
  add di,x
  mov al,color
  mov ah,al
  db 66h; shl ax,16
  mov al,color
  mov ah,al
  stosw;   (* stosd *)
  add di,324   (* 312 *)
  db 66h; stosw;   (* stosd *)
  add di,322
  db 66h; stosw;   (* stosd *)
  add di,322
  stosw;   (* stosd *)
  add di,312
  stosw;   (* stosd *)
  db 66h; stosw;   (* stosd *)
  add di,312
  stosw;   (* stosd *)
  db 66h; stosw;   (* stosd *)
end;

procedure Mode(md:word);assembler;
asm
  mov ax,md
  int 10h
end;

function KeyPressed:byte;assembler;
{Mmmhh, faster ?}
asm
  in al,$60
  xor ah,ah
end;

procedure SetPal;assembler;
asm
  cli
  mov si,offset pal
  mov DX,3dah
  @l1:
  in AL,DX
  test AL,8d
  jnz @l1
  @l2:
  in AL,DX
  test AL,8d
  jz @l2
  mov cx,768
  mov dx,3C8h
  xor al,al
  out dx,al
  inc dx
  rep outsb
  sti
END;

procedure ramp(scol,r1,g1,b1,ecol,r2,g2,b2:byte;var p:palette);
{ramp colors}
var i:word;
    r,g,b:real;
begin
  i:=scol;
  r:=(r2-r1)/(ecol-scol);
  g:=(g2-g1)/(ecol-scol);
  b:=(b2-b1)/(ecol-scol);
  repeat
    p[i*3]  :=r1+round(r*(i-scol));
    p[i*3+1]:=g1+round(g*(i-scol));
    p[i*3+2]:=b1+round(b*(i-scol));
    inc(i);
  until i=ecol+1;
end;

procedure SetUpBuffer(var segment:word;size:word);
{I HATE GETMEM}
var StartAdress:word;
begin
  asm
    mov ax,4821h
    mov bx,size
    int 21h
    mov dx,ax
    jnb @l1
      mov dx,0a000h
      jmp @l2
    @l1:
      shl bx,2
      mov cx,bx
      mov es,ax
      xor di,di
      xor ax,ax
      rep stosw
    @l2:
    mov StartAdress,dx
  end;
  segment:=StartAdress;
  if startadress=$0a000 then begin
    asm mov ax,3h;int 10h;end;
    Writeln('not enough memory');
    halt;
  end;
end;

procedure FreeBuffer(segment:word);assembler;
{I HATE FREEMEM, TOO}
asm
  mov ax,4921h
  mov bx,segment
  int 21h
end;

procedure init;
var i:word;
begin
  randomize;

  {SetUpBuffer(bseg,4096);}
  getmem(bseg,64000);

  {SetUpBuffer(bseg2,4096);}
  {Just a few precalcs to gain speed}
  for i:=0 to 255 do cosinus[i]:=round(cos(2*pi*i/255)*35+82);
  for i:=0 to 255 do sinus[i]:=round(sin(2*pi*i/255)*80+140);

  for i:=0 to 319 do xarray[i]:=round(i/319*(319-(2*factor)))+factor;
  for i:=0 to 199 do begin
                       yarray[2*i]:=  round(i/199*(199-(8*factor))+factor)*320;
                       yarray[2*i+1]:=round(i/199*(199-(8*factor))+factor)*320;
                     end;

  ramp(  0, 0, 0, 0, 31,26, 3,38,pal);
  ramp( 32,26, 3,38, 63,15,39,63,pal);
  ramp( 64,15,39,63, 95,63,63,63,pal);
  ramp( 96,63,63,63,111,63,63, 3,pal);
  ramp(112,63,63, 3,130,63, 3,27,pal);
  mode($13);setpal;
  port[$3c8]:=7; port[$3c9]:=57; port[$3c9]:=60; port[$3c9]:=63;

  directvideo:=false;
  textcolor(7);
  gotoxy(1,4);
  writeln('w    a    t    e    r    f    a    l   l');
end;

procedure leave;
begin
  {FreeBuffer(bseg);}
  freemem(bseg,64000);
  {FreeBuffer(bseg2);}
  mode(3);
end;

begin
  init;

  repeat
    for i:=0 to 100 do dot(random(320),random(140)+15,seg(bseg),95);
    fire(seg(bseg));
    ScaleUp(seg(bseg),$a000);

    (*waitvrt;*)
	 copydw($a000,seg(bseg));
  until keypressed=1;
  leave;
  Writeln('tarzeau/cr');
end.
