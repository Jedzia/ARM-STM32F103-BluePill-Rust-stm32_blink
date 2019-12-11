ARCH = arm-none-eabi
CARGO = cargo
#BOARD = BLUEPILL
BOARD = OLIMEX_H103
OBJDUMP = $(ARCH)-objdump
OBJDUMP_SYMBOLS = -ts
OBJDUMP_DISASSEMBLE = -D
QEMU = "C:\Toolchain\ARM\GNU MCU Eclipse\QEMU\bin\qemu-system-gnuarmeclipse.exe"
#CC=arm-none-eabi-gcc
SIZE=$(ARCH)-size
OBJCOPY = $(ARCH)-objcopy
STRIP = $(ARCH)-strip

BUILDTYPE = --release
# Debug
#set BUILDTYPE=

#RUSTFLAGS = -C linker=$(ARCH)-ld

BINNAME = stm32_blink
BINDIR = target/thumbv7m-none-eabi
ifeq ($(BUILDTYPE), --release)
BINTARGET=$(BINDIR)/release/$(BINNAME)
else
BINTARGET=$(BINDIR)/debug/$(BINNAME)
endif

setup:
ifeq ($(BUILDTYPE), --release)
	@echo release
else
	@echo debug
endif

build: setup src/main.rs
	$(CARGO) build $(BUILDTYPE) --features $(BOARD)
	@echo $(BINTARGET)
	#$(OBJDUMP) $(OBJDUMP_SYMBOLS) $(BINTARGET)
	#$(OBJCOPY) --output-target binary $(BINTARGET) $(BINTARGET).bin
	$(OBJCOPY) --output-target srec $(BINTARGET) $(BINTARGET).srec
	$(OBJCOPY) --output-target ihex $(BINTARGET) $(BINTARGET).hex
	$(SIZE) $(BINTARGET)
	

disassemble: build
	cp $(BINTARGET) $(BINTARGET).stripped
	$(STRIP) $(BINTARGET).stripped
	$(OBJDUMP) $(OBJDUMP_DISASSEMBLE) $(BINTARGET).stripped

emu: build
	#$(QEMU) --verbose --verbose --board STM32-H103 --mcu STM32F103RB -d unimp,guest_errors --image $(BINTARGET) --semihosting-config enable=on,target=native --semihosting-cmdline test 1 2 3
	$(QEMU) --verbose --verbose --board STM32-H103 --mcu STM32F103RB -d unimp,guest_errors --image $(BINTARGET)

clean:
	$(CARGO) clean $(BUILDTYPE)
	rm -f $(BINTARGET).stripped $(BINTARGET).srec $(BINTARGET).hex $(BINTARGET).bin $(BINTARGET)
 