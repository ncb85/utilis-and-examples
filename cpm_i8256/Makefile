REMOVE = /usr/bin/rm -f
RENAME = /usr/bin/mv
COMPILER = scc8080
ASSEMBLER = as8085
LINKER = aslink
SORTHEX = /usr/bin/sort -k1.8,1.9 -k1.4,1.7
PACKHEX = packihx
HEX2COM = hex2bin -e com -c

STARTADDRESS = 0x0100
# Compiler options
SCCFLAGS = -t -u
#SCCFLAGS = -t

# Assembler options
AS8085FLAGS = -l -o -s -p -g

# These settings control where the compiler will place the code and variables in memory.
#ASLINKFLAGS = -n -i -u -o -m -b CRET=$(STARTADDRESS) -b LIB8080=crtsoend+$(STARTADDRESS) -b SMALLC_GENERATED=crun8080_end+crtsoend+$(STARTADDRESS)
ASLINKFLAGS = -i -i+$(TARGET).ihx -m -u -a CRET=$(STARTADDRESS)

# Target file name (without extension).
TARGET = muart
LIB_SRC = main.c console.c i8256.c led595.c \
	  lib/inout.c lib/arglist.c lib/io8080.c lib/printf.c lib/charclass.c lib/bdos.c \
	  lib/bdos1.c lib/itoa.c lib/atoi.c lib/strlen.c lib/reverse.c lib/exit.c
ASM_SRC = cret.asm crun8085lib.asm
ASM_OBJ = $(addsuffix .rel, $(basename $(ASM_SRC)))
LIB_OBJ = $(addsuffix .rel, $(basename $(LIB_SRC)))
PATH := /home/pi/Programs/SmallC-85/smallC
PATH := $(PATH):/home/pi/Programs/asxv5p50/asxmak/linux/build
PATH := $(PATH):/usr/local/bin

all: pre-build $(TARGET).com post-build

pre-build:
	@echo "Building project"

post-build:
	@echo "Build finished"

$(TARGET).com: $(LIB_OBJ) $(ASM_OBJ)
	$(LINKER) $(ASLINKFLAGS) $(ASM_OBJ) $(LIB_OBJ)
	$(SORTHEX) $(TARGET).ihx > $(TARGET).hex
	$(REMOVE) $(TARGET).ihx
	$(HEX2COM) $(TARGET).hex
	
%.rel: %.c
	$(COMPILER) $(SCCFLAGS) $<
	$(ASSEMBLER) $(AS8085FLAGS) $(addsuffix .s, $(basename $<))

%.rel: %.asm
	$(ASSEMBLER) $(AS8085FLAGS) $<

clean:
	@echo "Cleaning project"
	$(REMOVE) *.ihx *.hex *.s *.mem *.rel *.map *.sym *.lst *.rst *.lnk \
	*.hlr *.x *.com *.bin
	$(REMOVE) lib/*.ihx lib/*.hex lib/*.s lib/*.mem lib/*.rel lib/*.map \
	lib/*.sym lib/*.lst lib/*.rst lib/*.lnk lib/*.hlr lib/*.x lib/.com lib/*.bin
