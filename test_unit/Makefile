REMOVE = rm -f
RENAME = mv
COMPILER = scc8080
ASSEMBLER = as8085
LINKER = aslink
SORTHEX = sort -k1.8,1.9 -k1.4,1.7
PACKHEX = packihx

STARTADDRESS = 0x0800
# Compiler options
SCCFLAGS = -t -a

# Assembler options
AS8085FLAGS = -l -o -s -p -g

# These settings control where the compiler will place the code and variables in memory.
ASLINKFLAGS = -n -i -u -o -m -b CRTSO=$(STARTADDRESS) -b LIB8080=crtsoend+$(STARTADDRESS) -b SMALLC_GENERATED=crun8080_end+crtsoend+$(STARTADDRESS)

# Target file name (without extension).
TARGET = main
LIB_SRC = test.c inout.c
ASM_SRC = crtso.asm crun8080lib.asm
ASM_OBJ = $(addsuffix .rel, $(basename $(ASM_SRC)))
LIB_OBJ = $(addsuffix .rel, $(basename $(LIB_SRC)))

all: pre-build $(TARGET).hex post-build

pre-build:
	@echo 'Building project'

post-build:
	@echo 'Build finished'

main.hex: $(TARGET).s $(LIB_OBJ) $(ASM_OBJ)
	$(ASSEMBLER) $(AS8085FLAGS) $<
	$(LINKER) $(ASLINKFLAGS) $(TARGET) $(TARGET).rel $(ASM_OBJ) $(LIB_OBJ)
	$(SORTHEX) $(TARGET).ihx > $(TARGET).hex
	#${PACKHEX} $(TARGET).ihx > $(TARGET).hex
	tail -59 $(TARGET).map | head -10
	
	
%.s: %.c
	$(COMPILER) $(SCCFLAGS) $<
	
%.rel: %.c
	$(COMPILER) $(SCCFLAGS) $<
	$(ASSEMBLER) $(AS8085FLAGS) $(addsuffix .s, $(basename $<))

%.rel: %.asm
	$(ASSEMBLER) $(AS8085FLAGS) $<

clean:
	@echo 'Cleaning project'
	$(REMOVE) *.ihx *.hex *.s *.mem *.rel *.map *.sym *.lst *.rst *.lnk
	$(REMOVE) lib/*.ihx lib/*.hex lib/*.s lib/*.mem lib/*.rel lib/*.map lib/*.sym lib/*.lst lib/*.rst lib/*.lnk

env:
	@echo PATH = $(PATH)