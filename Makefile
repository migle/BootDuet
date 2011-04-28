# Copyright 2011 Miguel Lopes Santos Ramos.

DEVICE ?= /dev/null

CFLAGS = -nostdlib -Wl,--oformat=binary -Wl,-Ttext=0x7c00


all : bd16.bin bd32.bin bd12.bin

lba64 : bd16_64.bin bd32_64.bin # bd12_64.bin


clean :
	@rm -f bd16.bin bd32.bin bd12.bin \
		bd16.lst bd32.lst bd12.lst \
		bd16.map bd32.map bd12.map \
		bd16_64.bin bd32_64.bin bd12_64.bin \
		bd16_64.lst bd32_64.lst bd12_64.lst \
		bd16_64.map bd32_64.map bd12_64.map


bd12.bin : BootDuet.S
	gcc -DFAT=12 -DWITH_VALIDATION $(CFLAGS) -o $@ $< -Wa,-a=$(@:.bin=.lst) -Wl,-Map=$(@:.bin=.map)

bd16.bin : BootDuet.S
	gcc -DFAT=16 -DWITH_VALIDATION $(CFLAGS) -o $@ $< -Wa,-a=$(@:.bin=.lst) -Wl,-Map=$(@:.bin=.map)

bd32.bin : BootDuet.S
	gcc -DFAT=32 -DWITH_VALIDATION $(CFLAGS) -o $@ $< -Wa,-a=$(@:.bin=.lst) -Wl,-Map=$(@:.bin=.map)

bd12_64.bin : BootDuet.S
	gcc -DFAT=12 -DWITH_LBA_64BIT $(CFLAGS) -o $@ $< -Wa,-a=$(@:.bin=.lst) -Wl,-Map=$(@:.bin=.map)

bd16_64.bin : BootDuet.S
	gcc -DFAT=16 -DWITH_LBA_64BIT $(CFLAGS) -o $@ $< -Wa,-a=$(@:.bin=.lst) -Wl,-Map=$(@:.bin=.map)

bd32_64.bin : BootDuet.S
	gcc -DFAT=32 -DWITH_LBA_64BIT $(CFLAGS) -o $@ $< -Wa,-a=$(@:.bin=.lst) -Wl,-Map=$(@:.bin=.map)


install-bd12 : bd12.bin
	dd if=$< of=$(DEVICE) bs=1 skip=62 seek=62 count=448

install-bd16 : bd16.bin
	dd if=$< of=$(DEVICE) bs=1 skip=62 seek=62 count=448

install-bd32 : bd32.bin
	dd if=$< of=$(DEVICE) bs=1 skip=90 seek=90 count=420

install-bd12_64 : bd12_64.bin
	dd if=$< of=$(DEVICE) bs=1 skip=62 seek=62 count=444

install-bd16_64 : bd16_64.bin
	dd if=$< of=$(DEVICE) bs=1 skip=62 seek=62 count=444

install-bd32_64 : bd32_64.bin
	dd if=$< of=$(DEVICE) bs=1 skip=90 seek=90 count=416
