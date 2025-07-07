REMOVE = rm -f
RENAME = mv
COMPILER = scc8080
ASSEMBLER = as8085
LINKER = aslink
SORTHEX = sort -k1.8,1.9 -k1.4,1.7
PACKHEX = packihx
HEX2COM = hex2bin -e com -c

# CP/M start address 0100H
STARTADDRESS = 0x0100
# Compiler options
SCCFLAGS = -t

# Assembler options
AS8085FLAGS = -l -o -s -p -g

# These settings control where the compiler will place the code and variables in memory.
ASLINKFLAGS = -n -i -u -o -m -b CRET=$(STARTADDRESS) -b LIB8080=crtsoend+$(STARTADDRESS) -b SMALLC_GENERATED=crun8080_end+crtsoend+$(STARTADDRESS)

# Target file name (without extension, max 6 chars).
TARGET = sccut
LIB_SRC = main.c test.c test_unsign_ansi.c test_struct.c test_pointer.c test_expr.c buggy.c \
	  lib/bdos.c lib/chio8080.c lib/arglist.c lib/charclass.c lib/io8080.c \
	  lib/bdos1.c lib/exit.c lib/printf.c lib/itoa.c lib/strlen.c lib/atoi.c lib/reverse.c
ASM_SRC = cret.asm crun8080lib.asm
ASM_OBJ = $(addsuffix .rel, $(basename $(ASM_SRC)))
LIB_OBJ = $(addsuffix .rel, $(basename $(LIB_SRC)))
	
all: pre-build $(TARGET).com post-build

pre-build:
	@echo 'Building project'

post-build:
	@echo 'Build finished. ALWAYS test both 8080 and 8085 versions!!!'

$(TARGET).com: $(LIB_OBJ) $(ASM_OBJ)
	$(LINKER) $(ASLINKFLAGS) $(TARGET) $(ASM_OBJ) $(LIB_OBJ)
	$(SORTHEX) $(TARGET).ihx > $(TARGET).hex
	$(HEX2COM) $(TARGET).hex
	
%.rel: %.c
	$(COMPILER) $(SCCFLAGS) $<
	$(ASSEMBLER) $(AS8085FLAGS) $(addsuffix .s, $(basename $<))

%.rel: %.asm
	$(ASSEMBLER) $(AS8085FLAGS) $<

clean:
	@echo 'Cleaning project'
	$(REMOVE) *.ihx *.hex *.s *.mem *.rel *.map *.sym *.hlr *.lst *.rst *.lnk *.com
	$(REMOVE) lib/*.ihx lib/*.hex lib/*.s lib/*.mem lib/*.rel lib/*.map lib/*.sym \
	lib/*.hlr lib/*.lst lib/*.rst lib/*.lnk

env:
	@echo PATH = $(PATH)