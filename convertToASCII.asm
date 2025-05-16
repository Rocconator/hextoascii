; AUTHOR: Rocco Greco
; CLASS: CMSC 313 1430
; DATE: May 15, 2025


SECTION .data
INPBUF:		db	0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
NUMOFBYTES:	dd	8

SECTION .bss
OUTBUF:		RESB	80

SECTION .text

_start:
	; initialize loop counters
	mov	esi, 0
	mov 	edi, 0
loop:
	; compare the esi counter to NUMOFBYTES, if 
	; equal, jump to the print label 
	cmp	esi, [NUMOFBYTES]
	jz	print
	; move the current byte into eax
	mov	eax, [INPBUF + esi]
	; mask eax so that the first letter is the only
	; thing in eax
	and	eax, 0x00F0
	; shift it to the right so that it is "0x000F"
	shr	eax, 4
	; convert the character in eax to the correct ascii value
	call	convert
	; move the ascii character in eax to the current 
	; place in OUTBUF, using edi as a count to move the pointer
	; forward for each loop
	mov 	[OUTBUF + edi], eax
	inc	edi
	; move the same byte to eax to get the second character
	mov	eax, [INPBUF + esi]
	; mask eax to get the second character (no shifting needed this time)
	and	eax, 0x000F
	; convert the character in eax to the correct ascii value
	call	convert
	mov	[OUTBUF + edi], eax
	; only increment esi once both characters in this current byte
	; have been converted
	inc	esi
	; put a space between this hex value
	inc	edi	
	; 0x20 is space in ascii
	mov	edx, 0x20
	mov	[OUTBUF + edi], edx
	inc	edi
	jmp	loop

convert:
	; if eax is less than or equal to 9, it must be a number, 
	; so jump to the number label. if eax is larger than 9, 
	; it must be a letter, so continue normally
	cmp	eax, 9
	jbe	number
	; add 0x07 to eax to get rid of the letter (example is eax is 0xa, 0xa + 0x07
	; is 0x11). This makes it easier to translate into the correct ascii value on the next line
	add	eax, 0x07
number:
	; add 0x30 to move eax to the correct ascii value
	add	eax, 0x30
    	ret

print:
	; need to add a carriage return and a line feed to OUTBUF
	mov	edx, 0x0d
	mov	[OUTBUF + edi], edx
	add	edi, 1
	mov 	edx, 0x0a
	mov	[OUTBUF + edi], edx

	; print the characters in OUTBUF
	; edx is the length of the buffer (OUTBUF)
	mov	edx, 80
	; ecx is the buffer 
	mov	ecx, OUTBUF
	; ebx is set to write to STDOUT file
	mov	ebx, 1
	; eax is set to call SYS_WRITE 
	mov	eax, 4
	; system interrupt 
	int 	80h	

quit:
	; end program with 0 errors
	mov	ebx, 0
	; call SYS_EXIT
	mov	eax, 1
	; system interrupt
	int 80h
		

