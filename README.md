# mkimg
Builds a bootable menix image

This repo is just meant for simple testing with a bootloader, a more mature
solution will be worked on in the future.

# Building
- First, clone the kernel to the same directory as this repository.
- Build the kernel

To create an image with the Limine bootloader, call
```make
make limine
```

# Debugging menix with QEMU
```make
make qemu
```

# Debugging menix with QEMU
```make
make qemu DEBUG=1
```
