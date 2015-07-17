data_s segment para public
data_s ends

st_seg segment para stack
db 256 dup(?)
st_seg ends

code_s segment para public
assume ss:st_seg, ds:data_s
assume cs:code_s

begin:		mov 	ax, data_s
		mov	ds, ax
		mov	ax, st_seg
		mov 	ss, ax

		mov ax, 0013h
		int 10h

		mov ah, 0ch
		mov dx, 1
		mov cx, 1
		mov al, 2h
		int 10h


nready:		mov ah ,01h
		int 16h
		jz nready

		mov ax, 0003h
		int 10h		
		mov ah, 4ch
		mov al, 0
		int 21h
code_s ends
end begin


