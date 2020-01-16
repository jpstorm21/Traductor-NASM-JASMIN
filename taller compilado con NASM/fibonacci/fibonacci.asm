global _main
extern _printf

section .text
_main:

	mov eax,10
	push eax

	mov eax,1
	push eax

	mov eax,10
	push eax

	add esp, 8
	pop eax
	sub esp, 12
	mov ebx,0
	cmp eax,ebx
	jz finciclo1
	ciclo1:

	add esp, 4
	pop eax
	sub esp, 8
	push eax
	add esp, 4
	pop eax
	sub esp, 8
	push eax
	pop ebx
	pop eax
	mul ebx
	push eax
	pop eax
	add esp,4
	pop ebx
	push eax
	sub esp,4

	add esp, 0
	pop eax
	sub esp, 4
	push eax
	mov eax, 1
	push eax
	pop ebx
	pop eax
	sub eax, ebx
	push eax
	pop eax
	add esp,0
	pop ebx
	push eax
	sub esp,0

	add esp, 8
	pop eax
	sub eax,1
	push eax
	sub esp, 8
	cmp eax,0
	jnz ciclo1
	finciclo1:

	add esp, 4
	pop eax
	sub esp, 8
	push eax
	push	_msg1
	call	_printf
	add	esp, 8

	add esp, 12
	ret


section .data
	_msg1: db "factorialDeDiez%i",0Ah,0
