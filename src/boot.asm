bits 16
[org 0x7c00]
start:
	mov si, string_to_print	; Set up si register for function call
	call print_string	
	mov cx, 0xbeef		; Set up cx for function call
	call print_hex
	
	jmp $			; Done

	string_to_print db "I am going to print a hex value: ",0

%include "src/inc/print_hex.asm"
%include "src/inc/print_string.asm"

	times 510-($-$$) db 0
	dw 0xaa55
