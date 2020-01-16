global _main
extern _printf

section .text
_main:

	mov eax,1
	mov ebx,0
	cmp eax,ebx
	jz fincond1

	push	_msg1
	call	_printf
	add	esp, 4

	fincond1:

	mov eax,0
	mov ebx,0
	cmp eax,ebx
	jz fincond2

	push	_msg2
	call	_printf
	add	esp, 4

	fincond2:

	ret


section .data
	_msg1: db "debeimprimirse",0Ah,0
	_msg2: db "nodebeimprimirse",0Ah,0
