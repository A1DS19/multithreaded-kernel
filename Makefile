compile:
	nasm -f bin boot.asm -o boot.bin

run-emulator:
	qemu-system-x86_64 -hda ./boot.bin