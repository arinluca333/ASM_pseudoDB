.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc

extern strcmp: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public find
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
msg_found db "User found:", 13, 10, 0
format_nume db "NAME:%s/", 0
format_parola db "PASS:%s/", 0
format_email db "EMAIL:%s", 13, 10, 0
format_user db "USER:%s/", 0
search_elem db 20 dup(0)
msg_fail db "There is no such element.", 13, 10, 0
format db "%s", 0
parolaX db "****", 0
.code
find:;USER LIST, INDEX
	;aici se scrie codul
	push EBP
	mov EBP, ESP
	mov EBX, [EBP + 8]
	mov ESI, [EBP + 12]
	mov EDI, [EBP + 12]
	push offset search_elem
	push offset format
	call scanf
	add ESP, 8
again:
	;NUME
	push offset search_elem
	push EBX
	call strcmp
	cmp EAX, 0
	je found
	;USER
	add EBX, 20
	push offset search_elem
	push EBX
	call strcmp
	cmp EAX, 0
	je found
	;EMAIL
	add EBX, 40
	push offset search_elem
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
	push offset msg_found
	call printf
	add ESP, 4
	mov EBX, [EBP + 8]
	sub ESI, EDI
	mov EAX, ESI
	mov CL, 100
	mul CL
	add EBX, EAX
	;NUME
	push EBX
	push offset format_nume
	call printf
	add ESP, 8
	;USER
	add EBX, 20
	push EBX
	push offset format_user
	call printf
	add ESP, 8
	;PAROLA
	add EBX, 20
	push offset parolaX
	push offset format_parola
	call printf
	add ESP, 8
	;EMAIL
	add EBX, 20
	push EBX
	push offset format_email
	call printf
	add ESP, 8
	;terminarea programului
	mov ESP, EBP
	pop EBP
	ret
end find
