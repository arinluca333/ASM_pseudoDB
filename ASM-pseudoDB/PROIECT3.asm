.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern fopen: proc
extern scanf: proc
extern strcmp: proc
extern list: proc
extern login: proc
extern end_program: proc
extern insert: proc
extern initialize: proc
extern find: proc
extern del: proc
extern fgets: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
index dd 0
file_name db "LIST.txt", 0
user_mem dd 0
mode db "rb", 0
fisier dd 0
msg_logare db "LOGIN SUCCESSFUL! WELCOME!", 13, 10 , 0
optiune db 20 dup(0)
format_optiune db "%s", 0
optiune_add db "add", 0
optiune_del db "del", 0
optiune_list db "list", 0
optiune_find db "find", 0
optiune_exit db "exit", 0
file_name_number db "NUMBER.txt", 0
msg_optiune_gresita db "INVALID COMMAND", 13, 10, 0
msg_no_user db "There are no users in the list", 13, 10 , 0
msg_last_user db "Deleting the last user is not permited!", 13, 10, 0
msg_login_fail db "Incorrect username or password!", 13, 10, 0
.code

start:
	;aici se scrie codul
	;DESCHIDERE FISIER
	push offset mode
	push offset file_name
	call fopen
	add ESP, 8
	mov [fisier], EAX
	
	;APEL proc initialize
	push offset index
	push user_mem
	push fisier
	call initialize
	add ESP, 12
	mov user_mem, EAX
	mov index, EBX
	jmp again
login_fail:	
	push offset msg_login_fail
	call printf
	add ESP, 4
again:
	;APEL LOGIN
	push index
	push user_mem
	call login
	add ESP, 8
	cmp EAX, 0
	jne login_fail
	;LOGARE REUSITA
	push offset msg_logare
	call printf
	add ESP, 4
	jmp opt_again
opt_again_err:

	push offset msg_optiune_gresita
	call printf
	add ESP, 4
	
opt_again:
	;INTRODUCERE OPTIUNE
	mov optiune, 0
	push offset optiune
	push offset format_optiune
	call scanf
	add ESP, 8
	;VERIFICARI OPTIUNE
	;ADD
	push offset optiune
	push offset optiune_add
	call strcmp
	add ESP, 8
	cmp EAX, 0
	je insertU
	;LIST
	push offset optiune
	push offset optiune_list
	call strcmp
	add ESP, 8
	cmp EAX, 0
	je listU
	;DEL
	push offset optiune
	push offset optiune_del
	call strcmp
	add ESP, 8
	cmp EAX, 0
	je delU
	;FIND
	push offset optiune
	push offset optiune_find
	call strcmp
	add ESP, 8
	cmp EAX, 0
	je findU
	;EXIT
	push offset optiune
	push offset optiune_exit
	call strcmp
	add ESP, 8
	cmp EAX, 0
	je ex
	;OTHERS
	jmp opt_again_err
	
listU:
	cmp index, 0
	je no_user
	push offset file_name_number
	push index
	push user_mem
	call list
	add ESP, 8
	jmp opt_again
insertU:
	push index
	push user_mem
	call insert
	add ESP, 8
	mov index, ESI
	mov user_mem, EDI
	jmp opt_again
delU:
	cmp index, 1
	je last_user
	push index
	push user_mem
	call del
	add ESP, 8
	mov index, ESI
	mov user_mem, EDI
	jmp opt_again
last_user:
	push offset msg_last_user
	call printf
	add ESP, 4
	jmp opt_again
no_user:
	push offset msg_no_user
	call printf
	add ESP, 4
	jmp opt_again
findU:
	cmp index, 0
	je no_user
	push index
	push user_mem
	call find
	add ESP, 8
	jmp opt_again
ex:
	push index
	push user_mem
	push offset file_name
	call end_program
	add ESP, 12
	
	push 0
	call exit
end start
