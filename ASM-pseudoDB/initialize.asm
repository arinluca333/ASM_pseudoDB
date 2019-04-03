.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern realloc: proc
extern fread: proc
extern fclose: proc
extern memcpy: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public initialize
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date

.code
initialize: ;File source, destination, index
	
	push EBP
	mov EBP, ESP
	sub ESP, 104
	lea EBX, [EBP - 100]
	mov EDI, 0
bucla_citire:
	push [EBP + 8]
	push 1
	push 100
	push EBX
	call fread
	add ESP, 16
	test EAX, EAX
	jz close_file ; EOF
	add EDI, 1
	mov EAX, EDI;
	mov CL, 100;
	mul CL
	push EAX
	push EAX
	push [EBP + 12]
	call realloc
	add ESP, 8
	mov ESI, EAX
	mov [EBP + 12], EAX
	pop EAX
	lea EAX, [ESI + EAX -100]
	push 100
	push EBX
	push EAX
	call memcpy
	add ESP, 12
	
	jmp bucla_citire
close_file:
	push [EBP + 8]
	call fclose
	add ESP, 4
	
	mov EAX, ESI
	XOR EBX,EBX
	mov EBX, EDI
	
	mov ESP, EBP
	pop EBP
	ret	
end initialize
