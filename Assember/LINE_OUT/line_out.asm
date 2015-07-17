data_s segment para public
message1 db 'Введите координаты первой точки.(0..319 , 0..199)$'
message2 db 'Введите координаты второй точки.(0..319 , 0..199)$'
x1 dw 0
y1 dw 0
x2 dw 100
y2 dw 250
x dw ?
y dw ?
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
		
		mov ax, y1
		mov y, ax

		mov ax , 0010h
		int 10h


;Рисование точки
print:		mov ax ,y               ;ax=x
		sub ax ,y1		;ax=(x-x1)
		mov dx, x2              ;dx=y1
		sub dx, x1              ;dx=y1-y2
		mul dx 			;dx:ax=(x-x1)*(y1-y2)
		mov cx, y2              ;cx=x1
		sub cx, y1		;cx=x1-x2
		div cx

		add ax, x1 
		mov x, ax


		mov ah, 0ch
		mov dx,  x
		mov cx,  y
		mov al, 2h
		int 10h
		inc y

		mov ax, y2
		
		cmp y, ax
		je nready; Если равно, то выходим из цикла
		jmp print; В противном случаеа снова входим в цикл


;Ожидаем нажатия клавишы
nready:		mov ah ,01h
		int 16h
		jz nready

;Переход в текстовый режим с последующим выходом
		mov ax, 0003h
		int 10h
		mov ah, 4ch
		mov al, 0
		int 21h
code_s ends
end begin


