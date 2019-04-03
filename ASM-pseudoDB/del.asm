.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
extern strcmp: proc
extern realloc: proc
extern memmove: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public del
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
del_msg db "User successfully deleted!", 13, 10, 0
format db "%s", 0
del_elem db 20 dup(0)
msg_fail db "There is no such element.", 13, 10, 0
.code
del: ;USER LIST, INDEX
	;aici se scrie codul
	push EBP
	mov EBP, ESP
	mov EBX, [EBP + 8]
	mov ESI, [EBP + 12]
	mov EDI, [EBP + 12]
	push offset del_elem
	push offset format
	call scanf
	add ESP, 8
again:
	;NUME
	push offset del_elem
	push EBX
	call strcmp
	cmp EAX, 0
	je found
	;USER
	add EBX, 20
	push offset del_elem
	push EBX
	call strcmp
	cmp EAX, 0
	je found
	;EMAIL
	add EBX, 40
	push offset del_elem
	push EBX
	call strcmp
	cmp EAX, 0
	je found
	
	dec EDI
	cmp EDI, 0
	je fail
	add EBX, 40
	jmp again
fail :
	push offset msg_fail
	call printf
	add ESP, 4
	mov ESP, EBP
	pop EBP
	ret
found:
	cmp EDI,1
	jz realloc_only
	
	mov EBX, [EBP + 8]
	mov EAX, EDI
	dec EAX
	mov ECX, 100
	mul ECX
	push EAX

	sub ESI, EDI
	inc ESI
	MOV EAX, ESI
	mul ECX
	add EBX, EAX
	push EBX

	sub EBX, 100
	push EBX

	call memmove
	add ESP, 12
	
	jmp exit_p
realloc_only:
	mov EBX, [EBP + 8]
	mov ESI, [EBP + 12]
	mov EAX, ESI
	mov CL, 100
	sub EAX, 1
	mul CL
	push EAX
	push EBX
	call realloc
	add ESP, 8
	sub ESI, 1
	mov EDI, EAX
exit_p:
	mov ESI, [EBP + 12]
	dec ESI
	mov EDI, [EBP + 8]
	push offset del_msg
	call printf
	add ESP, 4
	;terminarea programului
	mov ESP, EBP
	pop EBP
	ret
end del
