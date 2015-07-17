data_s segment para public
string db 'String!$'
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

	MOV ah,9
        MOV dx , offset string
	int 21h

	MOV ah , 4ch
	mov al , 0
	int 21h


code_s ends
end begin
