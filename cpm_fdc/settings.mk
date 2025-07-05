#
# file paths to tools used in MAKE, change as needed
#
SYSTEM_PATH := $(PATH)
PROJECT_BINS := /home/pi/Programs/SmallC-85/smallC:/home/pi/Programs/asxv5p50/asxmak/linux/build

export PATH := $(foreach dir,$(PROJECT_BINS),$(dir):)$(SYSTEM_PATH)

