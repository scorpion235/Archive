data_s segment para public
string db 'Введите строку: $'
string2 db 'Введенная строка: $'
file_name db 'M:\assembler\myfile.txt$'
Buffer equ $
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

	mov ah, 09h	
	mov dx, offset string
	int 21h


	mov AH, 3FH
	mov BX, 0
	mov DX, offset Buffer
	mov CX, 100
	int 21h

	mov ah,09h
	mov dx, offset string2
	int 21h

	mov AH, 40h
	mov BX, 0
	mov DX, offset Buffer
	mov CX, 100
	int 21h
	
        MOV ah , 4ch
	int 21h


code_s ends
end begin
