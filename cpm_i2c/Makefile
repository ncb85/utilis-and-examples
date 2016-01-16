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
#ASLINKFLAGS = -n -i -u -o -m -b CRTSO=$(STARTADDRESS) -b LIB8080=crtsoend+$(STARTADDRESS) -b USER_GENERATED=crun8080_end+crtsoend+$(STARTADDRESS)
ASLINKFLAGS = -n -i -u -o -m -b CRET=$(STARTADDRESS) -b LIB8080=crtsoend+$(STARTADDRESS) -b SMALLC_GENERATED=crun8080_end+crtsoend+$(STARTADDRESS)

# Target file name (without extension).
TARGET = iic
LIB_SRC = main.c lib/bdos.c lib/chio8080.c lib/arglist.c lib/charclass.c lib/io8080.c \
	  lib/bdos1.c lib/exit.c lib/printf.c lib/itoa.c lib/strlen.c lib/atoi.c \
	  lib/reverse.c lib/inout.c i2c/i2c_master.c i2c/tmp275.c i2c/pca9555.c \
	  i2c/ds1307.c i2c/at24c128.c
ASM_SRC = cret.asm crun8085lib.asm i2c/pcf8584.asm 

ASM_OBJ = $(addsuffix .rel, $(basename $(ASM_SRC)))
LIB_OBJ = $(addsuffix .rel, $(basename $(LIB_SRC)))

PATH := /cygdrive/d/Users/roman/hobby/hardware_projects/smallc_rep/smallc_u85ls

PATH := $(PATH):/cygdrive/d/users/roman/hobby/hardware_projects/8085/asxv5pxx/asxmak/cygwin/exe
PATH := $(PATH):/usr/bin
PATH := $(PATH):/cygdrive/d/users/roman/hobby/hardware_projects/8085/ncb85/Utils
all: pre-build $(TARGET).hex post-build

pre-build:
	@echo 'Building project'

post-build:
	@echo 'Build finished'

$(TARGET).hex: $(LIB_OBJ) $(ASM_OBJ)
	$(LINKER) $(ASLINKFLAGS) $(TARGET) $(ASM_OBJ) $(LIB_OBJ)
	$(SORTHEX) $(TARGET).ihx > $(TARGET).hex
	$(HEX2COM) $(TARGET).hex
	$(REMOVE) $(TARGET).ihx
	
%.rel: %.c
	$(COMPILER) $(SCCFLAGS) $<
	$(ASSEMBLER) $(AS8085FLAGS) $(addsuffix .s, $(basename $<))

%.rel: %.asm
	$(ASSEMBLER) $(AS8085FLAGS) $<

clean:
	@echo 'Cleaning project'
	$(REMOVE) *.ihx *.hex *.s *.mem *.rel *.map *.sym *.lst *.rst *.lnk \
	*.x *.com *.bin
	$(REMOVE) lib/*.ihx lib/*.hex lib/*.s lib/*.mem lib/*.rel lib/*.map \
	lib/*.sym lib/*.lst lib/*.rst lib/*.lnk lib/*.x lib/.com lib/*.bin
	$(REMOVE) i2c/*.ihx i2c/*.hex i2c/*.s i2c/*.mem i2c/*.rel i2c/*.map \
	i2c/*.sym i2c/*.lst i2c/*.rst i2c/*.lnk i2c/*.x i2c/.com i2c/*.bin
