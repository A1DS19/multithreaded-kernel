# Multithreaded kernel in C
This is a multithreaded kernel written in C.

## How to run
- Run `make compile` to compile the kernel.
- Run `make run-emulator` to run the kernel in an emulator.
- To test on your own computer, you can copy boot.bin on a usb stick and boot from it, for example `sudo dd if=./boot.bin of=/dev/sdc`.