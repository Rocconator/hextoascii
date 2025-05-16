A = nasm
AFLAGS = -f elf32 -g -F dwarf
LD = ld
LDFLAGS = -m elf_i386 

convert.o: convertToASCII.asm
	$(A) $(AFLAGS) -o convertToASCII.o convertToASCII.asm
	$(LD) $(LDFLAGS) -o convertToASCII convertToASCII.o
