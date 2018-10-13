		mov ax,3
		int 10h
		mov ax,0b800h
		mov ds,ax
		mov byte ptr ds:680,2ah
		mov byte ptr ds:681,70h
		mov ah,4ch
		int 21h
		