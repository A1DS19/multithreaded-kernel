all: compile run-emulator

compile:
	nasm -f bin boot.asm -o boot.bin
	dd if=./message.txt >> boot.bin
	dd if=/dev/sdc bs=512 count=1 >> boot.bin

run-emulator:
	qemu-system-x86_64 -hda ./boot.bin

run-bless:
	bless ./boot.bin