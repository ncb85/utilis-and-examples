REMOVE = rm -f
RENAME = mv
COMPILER = scc8080
ASSEMBLER = as8085
LINKER = aslink
SORTHEX = sort -k1.8,1.9 -k1.4,1.7
PACKHEX = packihx
HEX2COM = hex2bin -e com -c

STARTADDRESS = 0x0100
# Compiler options
SCCFLAGS = -t -u
#SCCFLAGS = -t

# Assembler options
AS8085FLAGS = -l -o -s -p -g

# These settings control where the compiler will place the code and variables in memory.
ASLINKFLAGS = -n -i -u -o -m -b CRET=$(STARTADDRESS) -b LIB8080=crtsoend+$(STARTADDRESS) -b SMALLC_GENERATED=crun8080_end+crtsoend+$(STARTADDRESS)
ASLINKFLAGS = -n -i -i+$(TARGET).ihx -u -o -m -a CRET=$(STARTADDRESS)

# Target file name (without extension).
TARGET = env
LIB_SRC = main.c lib/bdos.c lib/chio8080.c lib/arglist.c lib/charclass.c lib/io8080.c \
	  lib/bdos1.c lib/exit.c lib/printf.c lib/itoa.c lib/strlen.c lib/atoi.c \
	  lib/reverse.c lib/inout.c i2c/i2c_master.c i2c/tmp275.c i2c/ds1307.c
ASM_SRC = cret.asm crun8085lib.asm i2c/pcf8584.asm 

ASM_OBJ = $(addsuffix .rel, $(basename $(ASM_SRC)))
LIB_OBJ = $(addsuffix .rel, $(basename $(LIB_SRC)))

PATH := /home/pi/Programs/SmallC-85/smallC
PATH := $(PATH):/home/pi/Programs/asxv5p50/asxmak/linux/build
PATH := $(PATH):/usr/local/bin:/usr/bin/

all: pre-build $(TARGET).com post-build

pre-build:
	@echo "Building project"

post-build:
	@echo "Build finished"

$(TARGET).com: $(LIB_OBJ) $(ASM_OBJ)
	$(LINKER) $(ASLINKFLAGS) $(ASM_OBJ) $(LIB_OBJ)
	$(SORTHEX) $(TARGET).ihx > $(TARGET).hex
	$(HEX2COM) $(TARGET).hex

%.s: %.c
	$(COMPILER) $(SCCFLAGS) $<

%.rel: %.s
	$(ASSEMBLER) $(AS8085FLAGS) $(addsuffix .s, $(basename $<))

%.rel: %.asm
	$(ASSEMBLER) $(AS8085FLAGS) $<

# keep .s files on disk after succesfull build 
INTERMEDIATE: $(addsuffix .s, $(basename $(LIB_SRC)))

clean:
	@echo "Cleaning project"
	$(REMOVE) *.ihx *.hex *.s *.mem *.rel *.map *.sym *.lst *.rst *.lnk \
	*.hlr *.x *.com *.bin
	$(REMOVE) lib/*.ihx lib/*.hex lib/*.s lib/*.mem lib/*.rel lib/*.map \
	lib/*.sym lib/*.lst lib/*.rst lib/*.lnk lib/*.hlr lib/*.x lib/.com lib/*.bin
	$(REMOVE) i2c/*.ihx i2c/*.hex i2c/*.s i2c/*.mem i2c/*.rel i2c/*.map \
	i2c/*.sym i2c/*.lst i2c/*.rst i2c/*.lnk i2c/*.hlr i2c/*.x i2c/.com i2c/*.bin
