data_s segment para public
;��������
	 	db 10
		dw 100 ;����� +
		dw -100 ;����� -
		dd 32767; ���. 楫�� +
		dd -32767; ���. 楫�� -
		dq 104; ����. 楫�� +
		dq -104; ����. 楫�� -
		dd 3.123; �����.+
		dd -3.123;�����.-
		dq 3.123 ;�����. �������
		dq -3.123;�����. ������� -
		dt 3.123
		dt -3.123
		dd 10.
		dd 10.1
		dd -10.
		dd 0.625
		dd 1.
		dt 12345678910
data_s ends

st_seg segment para public
	db 256 dup(?)
st_seg ends

code_s segment para public
	assume ds:data_s
	assume ss:st_seg
	assume cs:code_s
begin:
	mov ax, data_s
	mov ds, ax
	mov ax, st_seg
	mov ss, ax
code_s ends
end begin




