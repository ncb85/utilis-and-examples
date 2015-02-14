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
SCCFLAGS = -t -u
#SCCFLAGS = -t

# Assembler options
AS8085FLAGS = -l -o -s -p -g

# These settings control where the compiler will place the code and variables in memory.
ASLINKFLAGS = -n -i -u -o -m -b CRET=$(STARTADDRESS) -b LIB8080=crtsoend+$(STARTADDRESS) -b SMALLC_GENERATED=crun8080_end+crtsoend+$(STARTADDRESS)

# Target file name (without extension).
TARGET = clck
LIB_SRC = main.c font5x7.c graphic.c ks0108.c ks0108-8080.c clock.c console.c uart16552.c \
	  lib/inout.c lib/arglist.c lib/io8080.c lib/printf.c lib/charclass.c lib/bdos.c \
	  lib/bdos1.c lib/itoa.c lib/atoi.c lib/strlen.c lib/reverse.c lib/exit.c
ASM_SRC = cret.asm crun8085lib.asm convert.asm
ASM_OBJ = $(addsuffix .rel, $(basename $(ASM_SRC)))
LIB_OBJ = $(addsuffix .rel, $(basename $(LIB_SRC)))
PATH := /cygdrive/d/Users/roman/hobby/hardware_projects/smallc_rep/smallc_u85ls
PATH := $(PATH):/cygdrive/d/Users/roman/hobby/hardware_projects/8085/asxv5pxx/asxmak/cygwin/exe
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
