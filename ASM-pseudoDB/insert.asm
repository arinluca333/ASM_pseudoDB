.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
extern realloc: proc
extern memcpy: proc
extern time: proc
extern fopen: proc
extern fclose: proc
extern fscanf: proc
extern fprintf: proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public insert
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
file_name db "index.txt", 0
modec db "r", 0
modes db "w", 0
insert_msg db "User successfully added!", 13, 10, 0
format db "%s", 0
format2 db "%d", 0
req_nume db "NAME:", 0
req_user db "USER:", 0
req_parola db "PASS:", 0
req_email db "EMAIL:", 0
crypted_pass db 20 dup(0)
key db 17,3,5,23,29,37,11,47,57,67,73,97,101,103,2,1,0,2,0,1
USER struct
	nume db 20 dup(0) 
	user_name db 20 dup(0)
	parola db 20 dup(0)
	email db 20 dup(0)
	ID db 6 dup(0)
USER ends
current_user USER {}
.code
crypt proc
	push EBP
	mov EBP, ESP
	
	mov EDI, 0
	mov EAX, [EBP + 8]
again:
	cmp [current_user.parola + EDI], 0
	je exit_c
	mov CL, [key + EDI]
	xor [current_user.parola + EDI], CL
	inc EDI
	cmp EDI, 20
	jne again
exit_c:
	mov ESP, EBP
	pop EBP
	ret
crypt endp

get_ID proc
	push EBP
	mov EBP, ESP
	
	push offset modec
	push offset file_name
	call fopen
	add ESP, 8
	
	mov ESI, EAX
	
	push offset current_user.ID
	push offset format
	push ESI
	call fscanf
	add ESP, 12
	
	inc current_user.ID
	
	push ESI
	call fclose
	add ESP, 4

	push offset modes
	push offset file_name
	call fopen
	add ESP, 8
	
	push offset current_user.ID
	push offset format2
	push ESI
	call fprintf
	add ESP, 12
	
	push ESI
	call fclose
	add ESP, 4
	
	mov ESP, EBP
	pop EBP
	ret
get_ID endp

insert :;USER LIST, INDEX
	push EBP
	mov EBP, ESP
	
	;call get_ID
	
	mov ESI, [EBP + 12]
	inc ESI
	;INTRODUCERE NUME
	push offset req_nume
	call printf
	add ESP, 4
	
	push offset current_user.nume
	push offset format
	call scanf
	add ESP, 8
	
	;INTRODUCERE USER
	push offset req_user
	call printf
	add ESP, 4
	
	push offset current_user.user_name
	push offset format
	call scanf
	add ESP, 8
	
	;INTRODUCERE PAROLA
	push offset req_parola
	call printf
	add ESP, 4
	
	push offset current_user.parola
	push offset format
	call scanf
	add ESP, 8
	call crypt
	;INTRODUCERE EMAIL
	push offset req_email
	call printf
	add ESP, 4
	
	push offset current_user.email
	push offset format
	call scanf
	add ESP, 8
	
	
	;REALOCARE
	cmp ESI, 0
	jne jump
	inc ESI
jump:
	mov EAX, ESI
	mov CL, 100
	mul CL
	push EAX
	push EAX
	push [EBP + 8]
	call realloc
	add ESP, 8
	mov EDI, EAX
	pop EAX
	lea EAX, [EDI + EAX - 100]
	push 100
	push offset current_user
	push EAX
	call memcpy
	add ESP, 12
	
	push offset insert_msg
	call printf
	add ESP, 4
	
	mov ESP, EBP
	pop EBP
	ret
end insert
