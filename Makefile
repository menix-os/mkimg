###################################
.PHONY: limine efi clean qemu

BUILD_DIR=build
KERNEL_SRC=../kernel/build/bin
SRC=$(shell find src/ -name '*')
QEMU=qemu-system-x86_64
QEMU_OVMF=/usr/share/qemu/ovmf-x86_64.bin
ifeq ($(DEBUG),1)
QEMU_DEBUG=-d cpu_reset,int
endif
QEMU_FLAGS=-s $(QEMU_DEBUG) -no-reboot -serial stdio -bios $(QEMU_OVMF) -drive file=fat:rw:$(BUILD_DIR)
###################################

# Progress indication
ifneq ($(words $(MAKECMDGOALS)),1)
.DEFAULT_GOAL = all
%:
	@$(MAKE) $@ --no-print-directory -rRf $(firstword $(MAKEFILE_LIST))
else
ifndef ECHO
T := $(shell $(MAKE) $(MAKECMDGOALS) --no-print-directory \
	-nrRf $(firstword $(MAKEFILE_LIST)) \
	ECHO="COUNTTHIS" | grep -c "COUNTTHIS")

N := x
C = $(words $N)$(eval N := x $N)
ECHO = echo "`expr " [\`expr $C '*' 100 / $T\`" : '.*\(....\)$$'`%]"
endif

export MENIX_VERSION=$(shell cat $(KERNEL_SRC)/version)

limine: $(BUILD_DIR)/boot/menix
	@$(ECHO) "Copying limine/"
	@cp -r limine/. $(BUILD_DIR)

	@$(ECHO) "Filling limine config"
	@envsubst < $(BUILD_DIR)/boot/limine.cfg.in > $(BUILD_DIR)/boot/limine.cfg
	@rm $(BUILD_DIR)/boot/limine.cfg.in

	@$(ECHO) "Built limine image to $(BUILD_DIR)"

$(BUILD_DIR)/boot/menix: $(KERNEL_SRC)/menix $(BUILD_DIR)
	@$(ECHO) "Copying kernel"
	@cp $(KERNEL_SRC)/menix $(BUILD_DIR)/boot/

$(BUILD_DIR): $(SRC)
	@$(ECHO) "Creating output directory"
	@mkdir -p $(BUILD_DIR)

	@$(ECHO) "Copying source directory structure"
	@cp -r src/. $(BUILD_DIR)

clean:
	@rm -rf $(BUILD_DIR)
	@rm -f $(OUT_FILE)
	@$(ECHO) "Cleaned output files"

qemu:
	@$(QEMU) $(QEMU_FLAGS)

endif
