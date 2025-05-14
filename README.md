Description:


This 32-bit x86 NASM assembly program reads a series of bytes, converts them to their ASCII hexadecimal representation, and prints the result to the terminal. 
Each byte is represented as two hex characters (e.g., `0x83` -> `83`), with a space between each value. A newline is printed at the end.


Sample Output:
83 6A 88 DE 9A C3 54 9A


To Run:

nasm -f elf32 hw11translate2Ascii.asm -o hw11translate2Ascii.o

ld -m elf_i386 hw11translate2Ascii.o -o hw11translate2Ascii

./hw11translate2Ascii
83 6A 88 DE 9A C3 54 9A


Sample screenshot for clarity:

![{B9705980-6510-4E8E-9F6E-AE5FF252BD34}](https://github.com/user-attachments/assets/4a41a144-5e7d-4e79-9f5a-5f9de7123f6c)


