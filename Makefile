.PHONY: all clean

KERNEL_SRC=../kernel/build/menix

all:
	@echo "> Building output structure"
	mkdir -p build
	cp -r src/. build

	@echo "> Copying kernel"
	cp $(KERNEL_SRC) build/boot

clean: build
