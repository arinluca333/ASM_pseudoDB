.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern strcmp: proc
extern scanf: proc
extern printf: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public login
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
req_nume db "NAME:", 0
req_user db "USER:", 0
req_parola db "PASS:", 0
req_email db "EMAIL:", 0
format db "%s", 0
username db 20 dup(0)
pass db 20 dup(0)
key db 17,3,5,23,29,37,11,47,57,67,73,97,101,103,2,1,0,2,0,1
;aici declaram date
.code
cryptp proc
	push EBP
	mov EBP, ESP
	mov EDI, 0
	mov EAX, [EBP + 8]
again:
	cmp [pass + EDI], 0
	je exit_c
	mov CL, [key + EDI]
	xor [pass + EDI], CL
	inc EDI
	cmp EDI, 20
	jne again
exit_c:
	mov ESP, EBP
	pop EBP
	ret
cryptp endp
validate proc;USER_LIST, INDEX, user, pass
	push EBP
	mov EBP, ESP
	mov ESI, [EBP + 12]
	mov EBX, [EBP + 8]

again:
	add EBX, 20
	push [EBP + 16]
	push EBX
	call strcmp
	add ESP, 8
	cmp EAX, 0
	je pass_check
	jne	increment
	
increment:
	add EBX, 80
	dec ESI
	cmp ESI,0
	je fail
	jmp again
pass_check:
	add EBX, 20
	push EBX
	push [EBP + 20]
	call strcmp
	add ESP, 8
	cmp EAX, 0
	je success
	sub EBX, 20
	jmp increment
fail:
	mov EAX, -1
success:
	mov ESP, EBP
	pop EBP
	ret
validate endp

login:; USER LIST,INDEX
	push EBP
	mov EBP, ESP
	sub ESP, 8
	
	push offset req_user
	call printf
	add ESP, 4
	
	push offset username
	push offset format
	call scanf
	add ESP, 8
	
	push offset req_parola
	call printf
	add ESP, 4
	
	push offset pass
	push offset format
	call scanf
	add ESP, 8
	call cryptp
	push offset pass
	push offset username
	push [EBP + 12]
	push [EBP + 8]
	call validate
	add ESP, 16
	mov ESP, EBP
	pop EBP
	ret
end login
