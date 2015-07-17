data_s segment para public
mes db 'Введите символ: $'
mess db 'Вы ввели символ: $'
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
	
	mov ah , 09h
	mov dx , offset mes
	int 21h
	
	mov ah , 01h
	int 21h


	mov DL, AL
	mov AH, 02h
	int 21h

	mov ah, 4ch
	mov al, 0
	int 21h


code_s ends
end begin
