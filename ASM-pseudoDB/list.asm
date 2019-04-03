.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern printf: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
format_nume db "NAME:%s/", 0
format_parola db "PASS:%s/", 0
format_email db "EMAIL:%s", 13, 10, 0
format_user db "USER:%s/", 0
parolaX db "****", 0
.code

list: ; USER LIST, INDEX
	push EBP
	mov EBP, ESP
	
	mov EBX, 20
	mov SI, [EBP + 12]
next:
	;AFISARE NUME
	push [EBP + 8]
	push offset format_nume
	call printf
	add ESP, 8
	;AFISARE user
	add [EBP + 8], EBX
	push [EBP + 8]
	push offset format_user
	call printf
	add ESP, 8
	;AFISARE parola
	add [EBP + 8], EBX
	push offset parolaX
	push offset format_parola
	call printf
	add ESP, 8
	;Afisare email
	add [EBP + 8], EBX
	push [EBP + 8]
	push offset format_email
	call printf
	add ESP, 8
	;Trecere la urmatorul user
	add [EBP + 8], EBX
	add [EBP + 8], EBX
	dec SI
	cmp SI, 0
	je exit_proc; se iese din procedura cand nu mai avem useri
	jmp next; se reia afisarea urmatorului user
	
exit_proc:
	mov ESP, EBP
	pop EBP
	ret
end list
