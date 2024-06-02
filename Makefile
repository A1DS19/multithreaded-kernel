# gdb:
# target remote | qemu-system-x86_64 -hda ./boot.bin -S -gdb stdio

all: clean compile run-emulator

compile:
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot.bin

run-emulator:
	qemu-system-x86_64 -hda ./boot.bin

run-bless:
	bless ./boot.bin

clean:
	rm -rf ./bin/boot.bin