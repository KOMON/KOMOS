print_string:
	pusha
print_string_loop:	 
	mov al, [bx]
	cmp al, 0
	je print_string_end
	mov ah, 0x0e
	int 0x10
	inc bx
	jmp print_string_loop

print_string_end:	
	popa
	ret
