.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern fopen: proc
extern fwrite: proc
extern fclose: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public end_program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
mode2 db "wb", 0
.code
end_program: ;FILE_NAME, USER_LIST, INDEX
	push EBP
	mov EBP, ESP
	sub ESP, 4
	;DESCHIDERE FISIER
	push offset mode2
	push [EBP + 8]
	call fopen
	add ESP, 8
	mov EDI, EAX
	;SCRIERE IN FISIER
	push EDI
	push [EBP + 16]
	push 100
	push [EBP + 12]
	call fwrite
	add ESP, 16
	;INCHIDERE FISIER
	push EDI
	call fclose
	add ESP, 4
	
	mov ESP, EBP
	pop EBP
	ret
end end_program
