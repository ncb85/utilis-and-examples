REMOVE = rm -f
RENAME = mv
COMPILER = scc8080
ASSEMBLER = as8085
LINKER = aslink
SORTHEX = sort -k1.8,1.9 -k1.4,1.7
PACKHEX = packihx
HEX2COM = hex2bin -e com -c

# Target file name (without extension).
TARGET = utest
STARTADDRESS = 0x0100
# Compiler options
SCCFLAGS = -t -a -u

# Assembler options
AS8085FLAGS = -l -o -s -p -g

# These settings control where the compiler will place the code and variables in memory.
ASLINKFLAGS = -i -i+$(TARGET).ihx -m -u -a CRTSO=$(STARTADDRESS)

LIB_SRC = main.c inout.c print.c test.c test_unsign_ansi.c test_struct.c buggy.c \
		  lib/chio8080.c lib/bdos.c lib/bdos1.c
ASM_SRC = crtso.asm crun8085lib.asm
ASM_OBJ = $(addsuffix .rel, $(basename $(ASM_SRC)))
LIB_OBJ = $(addsuffix .rel, $(basename $(LIB_SRC)))

PATH := /home/pi/Programs/SmallC-85/smallC
PATH := $(PATH):/home/pi/Programs/asxv5p50/asxmak/linux/build
PATH := $(PATH):/usr/local/bin:/usr/bin

all: pre-build $(TARGET).hex post-build

pre-build:
	@echo "Building project"

post-build:
	@echo "Build finished"

$(TARGET).hex: $(LIB_OBJ) $(ASM_OBJ)
	$(LINKER) $(ASLINKFLAGS) $(ASM_OBJ) $(LIB_OBJ)
	$(SORTHEX) $(TARGET).ihx > $(TARGET).hex
	$(HEX2COM) $(TARGET).hex
	
%.s: %.c
	$(COMPILER) $(SCCFLAGS) $<
	
%.rel: %.s
	$(ASSEMBLER) $(AS8085FLAGS) $<

%.rel: %.asm
	$(ASSEMBLER) $(AS8085FLAGS) $<

# keep .s files on disk after succesfull build 
INTERMEDIATE: $(addsuffix .s, $(basename $(LIB_SRC)))

clean:
	@echo "Cleaning project"
	$(REMOVE) *.ihx *.hex *.s *.mem *.rel *.hlr *.map *.sym *.lst *.rst *.lnk
	$(REMOVE) lib/*.ihx lib/*.hex lib/*.s lib/*.mem lib/*.rel lib/*.hlr lib/*.map \
	lib/*.sym lib/*.lst lib/*.rst lib/*.lnk

env:
	@echo PATH = $(PATH)