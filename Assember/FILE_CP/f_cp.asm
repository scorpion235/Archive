data_s segment para public
file_name db 'M:\myfile.txt',0
new_file db 'M:\new.txt',0
error_message1 db '�訡�� �� ����⨨ 䠩�� �� �⥭��$'
error_message2 db '�訡�� �� ᮧ����� 䠩��.$'
bufer db 30000 dup(?)
desc_a dw 0
desc_b dw 0
symb_readed dw 0
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

;����⨥ 䠩�� ��� �⥭��
	mov ah, 3dh
	mov al ,0h
	mov dx, offset file_name
	int 21h

	JC error1

	mov desc_a, ax

;�������� 䠩�� ��� �����
	mov ah, 3ch
	mov dx , offset new_file
	mov cx, 01h 
	int 21h

	JC error2

	mov desc_b,ax	


;�⥭�� �� 䠩�� � ����	
	mov ah, 3fh
	mov bx, desc_a
	mov dx, offset bufer
	mov cx, 10000
	int 21h

;�뢮� ᮤ�ন���� ���� � 䠩�
	mov cx, ax
	mov ah, 40h
	mov bx , desc_b
	mov dx , offset bufer
	int 21h

;�����⨥ 䠩���
	mov ax ,3eh
	mov bx ,desc_a
	int 21h
	mov ax ,3eh
	mov bx, desc_b
	int 21h

;��室
exit:	mov ah, 4ch
	mov al , 0
	int 21h

error1:
	mov ah ,09h
	mov dx ,offset error_message1
	int 21h
	jmp exit

error2:
	mov ah, 09h
	mov dx, offset error_message2
	int 21h
	jmp exit

	
code_s ends
end begin
