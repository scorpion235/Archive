data_s segment para public
file_name db 'M:\myfile.txt$'
bufer db 10000 dup(?)
descriptor dw 0
data_s ends

st_seg segment para stack
db 256 dup(?)
st_seg ends

code_s segment para public
assume ss: st_seg , ds: data_s
assume cs: code_s

begin: 
	MOV ax , data_s
	MOV ds , ax
	MOV ax , st_seg
	MOV ss , ax


	mov ah, 3dh
	mov al ,0h
	mov dx, offset file_name
	int 21h

	mov descriptor , ax

;Чтение из файлов	
	mov ah, 3fh
	mov bx, descriptor
	mov dx, offset bufer
	mov cx, 10000
	int 21h

;вывод содержимого буфера на экран
	mov cx, ax
	mov ah, 40h
	mov bx , 1
	mov dx , offset bufer
	int 21h

;выход
	mov ah, 4ch
	mov al , 0
	int 21h

	 
code_s ends
end begin
