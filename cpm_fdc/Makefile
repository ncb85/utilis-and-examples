# Include user-specific settings.
-include settings.mk

REMOVE = rm -f
RENAME = mv
COMPILER = scc8080
ASSEMBLER = as8085
LINKER = aslink
SORTHEX = sort -k1.8,1.9 -k1.4,1.7
PACKHEX = packihx
HEX2COM = hex2bin -e com -c


# Target file name (without extension).
TARGET = fdc
STARTADDRESS = 0x0100

# Compiler options - do not use -a flag with lib/printf.c
SCCFLAGS = -t -u

# Assembler options
AS8085FLAGS = -l -o -s -p -g

# These settings control where the linker will place the code and variables in memory.
ASLINKFLAGS = -i -i+$(TARGET).ihx -m -u -a CRET=$(STARTADDRESS)

LIB_SRC = main.c format.c lib/bdos.c lib/chio8080.c lib/arglist.c lib/charclass.c \
	  lib/io8080.c lib/bdos1.c lib/exit.c lib/printf.c lib/itoa.c lib/strlen.c lib/atoi.c \
	  lib/reverse.c lib/scanf.c lib/scanf1.c
ASM_SRC = cret.asm crun8080lib.asm fdc_driver.asm
ASM_OBJ = $(addsuffix .rel, $(basename $(ASM_SRC)))
LIB_OBJ = $(addsuffix .rel, $(basename $(LIB_SRC)))

build: pre-build $(TARGET).hex post-build

pre-build:
	@echo "Building project"

post-build:
	@echo "Build finished"

$(TARGET).hex: $(LIB_OBJ) $(ASM_OBJ)
	$(LINKER) $(ASLINKFLAGS) $(ASM_OBJ) $(LIB_OBJ)
	$(SORTHEX) $(TARGET).ihx > $(TARGET).hex
	$(HEX2COM) $(TARGET).hex

%.rel: %.s
	$(ASSEMBLER) $(AS8085FLAGS) $(addsuffix .s, $(basename $<))

%.s: %.c
	$(COMPILER) $(SCCFLAGS) $<

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
